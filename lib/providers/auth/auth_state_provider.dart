import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_verification_status_screen.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

/// Where Splash should send the user, and with what route arguments.
class AuthStartDestination {
  const AuthStartDestination(this.routeName, [this.arguments]);

  final String routeName;
  final Object? arguments;
}

/// Owns the persisted sign-up → KYC → access state machine (spec §21).
///
/// Global because Splash, the entry screens, the KYC screens and logout
/// all read or write it, and it has to survive the route replacements
/// that happen between those. Kept deliberately small — it holds no form
/// state, so "global" stays defensible.
class AuthStateProvider extends ChangeNotifier {
  AuthStateProvider({
    required LocalStorageService localStorage,
    required SecureStorageService secureStorage,
  }) : _localStorage = localStorage,
       _secureStorage = secureStorage;

  final LocalStorageService _localStorage;
  final SecureStorageService _secureStorage;

  AuthFlowState _state = AuthFlowState.unauthenticated;
  AuthFlowContext _context = AuthFlowContext.empty;
  bool _isLoaded = false;

  AuthFlowState get state => _state;
  AuthFlowContext get context => _context;
  bool get isLoaded => _isLoaded;

  /// Reads the persisted state back into memory. Safe to call repeatedly.
  Future<void> load() async {
    final rawState = _localStorage.getString(StorageKeys.authFlowState);
    _state = AuthFlowState.fromName(rawState);

    final rawContext = _localStorage.getJson(StorageKeys.authFlowContext);
    _context = rawContext is Map
        ? AuthFlowContext.fromJson(Map<String, dynamic>.from(rawContext))
        : AuthFlowContext.empty;

    _isLoaded = true;
    notifyListeners();
  }

  /// The single write path for the machine — every transition goes
  /// through here so state and context can never drift apart on disk.
  Future<void> moveTo(AuthFlowState next, {AuthFlowContext? context}) async {
    _state = next;
    if (context != null) _context = context;

    await _localStorage.setString(StorageKeys.authFlowState, next.wireValue);
    await _localStorage.setJson(StorageKeys.authFlowContext, _context.toJson());

    debugPrint('[AuthFlow] -> ${next.wireValue}');
    notifyListeners();
  }

  /// Merges fields into the stored context without changing the state.
  Future<void> updateContext({
    AuthIdentifier? identifier,
    String? userId,
    String? fullName,
    String? email,
    UserRole? role,
    String? subBranch,
    LocationSelection? location,
    String? kycId,
    int? kycAttemptNumber,
  }) {
    return moveTo(
      _state,
      context: _context.copyWith(
        identifier: identifier,
        userId: userId,
        fullName: fullName,
        email: email,
        role: role,
        subBranch: subBranch,
        location: location,
        kycId: kycId,
        kycAttemptNumber: kycAttemptNumber,
      ),
    );
  }

  /// Stores the credentials and flips to [AuthFlowState.authenticated].
  /// The KYC scratch state is dropped here rather than on logout alone:
  /// once access is granted, the review ledger and the uploaded-document
  /// cache have served their purpose.
  Future<void> markAuthenticated({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.saveRefreshToken(refreshToken);
    }
    await _secureStorage.saveSession();
    await _secureStorage.delete(StorageKeys.kycToken);
    await _localStorage.remove(StorageKeys.kycUploadedDocuments);
    await _localStorage.remove(StorageKeys.kycMockLedger);
    await moveTo(AuthFlowState.authenticated);
  }

  Future<void> saveKycToken(String kycToken) =>
      _secureStorage.write(StorageKeys.kycToken, kycToken);

  Future<String?> readKycToken() => _secureStorage.read(StorageKeys.kycToken);

  /// Wipes everything this feature owns — both storages.
  ///
  /// `SecureStorageService.clearSession()` predates this flow and knows
  /// nothing about the local keys below, so logout must come through
  /// here or a second user on the same device would inherit the first
  /// user's KYC ledger and land mid-flow.
  Future<void> clear() async {
    await _secureStorage.clearSession();
    await _secureStorage.delete(StorageKeys.kycToken);
    await _localStorage.remove(StorageKeys.authFlowState);
    await _localStorage.remove(StorageKeys.authFlowContext);
    await _localStorage.remove(StorageKeys.kycUploadedDocuments);
    await _localStorage.remove(StorageKeys.kycMockLedger);

    _state = AuthFlowState.unauthenticated;
    _context = AuthFlowContext.empty;
    debugPrint('[AuthFlow] cleared');
    notifyListeners();
  }

  /// Resolves the screen Splash should land on, resuming a half-finished
  /// registration rather than dumping the user back at the entry form.
  Future<AuthStartDestination> resolveStartDestination() async {
    await load();

    final hasSession = await _secureStorage.hasValidSession();
    if (_state == AuthFlowState.authenticated) {
      if (hasSession) return const AuthStartDestination(AppRoutes.dashboard);
      // Flagged authenticated with no session behind it — a partially
      // wiped keystore is real Android behaviour, so treat it as a
      // corrupt record rather than trusting either half.
      debugPrint('[AuthFlow] authenticated without a session — resetting');
      await clear();
      return const AuthStartDestination(AppRoutes.authEntry);
    }

    switch (_state) {
      case AuthFlowState.unauthenticated:
        // Preserves the existing first-launch behaviour: only someone who
        // has logged out before skips the welcome/onboarding screens.
        final hasLoggedOut = await _secureStorage.hasLoggedOutBefore();
        return AuthStartDestination(
          hasLoggedOut ? AppRoutes.authEntry : AppRoutes.welcome,
        );

      case AuthFlowState.registration:
        final identifier = _context.identifier;
        if (identifier == null) {
          return _corrupt('registration without an identifier');
        }
        return AuthStartDestination(
          AppRoutes.userDetails,
          UserDetailsScreenArgs(
            identifier: identifier,
            prefillFullName: _context.fullName,
          ),
        );

      case AuthFlowState.kycPending:
        final kycToken = await readKycToken();
        final userId = _context.userId;
        final role = _context.role;
        if (kycToken == null || userId == null || role == null) {
          return _corrupt('kycPending without a token, user or role');
        }
        return AuthStartDestination(
          AppRoutes.kycDocuments,
          KycDocumentsScreenArgs(
            userId: userId,
            kycToken: kycToken,
            role: role,
          ),
        );

      // `approved` shares the status screen with `underReview` on purpose:
      // its first poll returns APPROVED from the frozen ledger, mints the
      // token and forwards to the Dashboard — one code path, not two.
      case AuthFlowState.underReview:
      case AuthFlowState.approved:
        final kycId = _context.kycId;
        final userId = _context.userId;
        final role = _context.role;
        if (kycId == null || userId == null || role == null) {
          return _corrupt('review state without a kycId, user or role');
        }
        return AuthStartDestination(
          AppRoutes.kycVerificationStatus,
          KycVerificationStatusScreenArgs(
            kycId: kycId,
            userId: userId,
            role: role,
          ),
        );

      case AuthFlowState.authenticated:
        // Handled above; unreachable.
        return const AuthStartDestination(AppRoutes.dashboard);
    }
  }

  Future<AuthStartDestination> _corrupt(String reason) async {
    debugPrint('[AuthFlow] inconsistent stored state ($reason) — resetting');
    await clear();
    return const AuthStartDestination(AppRoutes.authEntry);
  }
}
