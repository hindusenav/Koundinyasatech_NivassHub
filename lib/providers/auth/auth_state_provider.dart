import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

/// Where Splash should send the user, and with what route arguments.
class AuthStartDestination {
  const AuthStartDestination(this.routeName, [this.arguments]);

  final String routeName;
  final Object? arguments;
}

/// Sign-up → KYC → access state, held **in memory only**.
///
/// Nothing about registration or KYC (tokens, drafts, flow state, uploaded
/// documents) is written to disk: the backend is the record, and the user-
/// check screen re-derives where they are. The only thing persisted is the
/// login session (access/refresh token + logged-in flag), which is what
/// auto-login uses until it expires or the user logs out.
class AuthStateProvider extends ChangeNotifier {
  AuthStateProvider({
    required LocalStorageService localStorage,
    required SecureStorageService secureStorage,
  }) : _localStorage = localStorage,
       _secureStorage = secureStorage;

  /// Only used to purge keys written by older builds.
  final LocalStorageService _localStorage;
  final SecureStorageService _secureStorage;

  AuthFlowState _state = AuthFlowState.unauthenticated;
  AuthFlowContext _context = AuthFlowContext.empty;
  bool _isLoaded = false;

  String? _kycToken;
  String? _registrationToken;

  AuthFlowState get state => _state;
  AuthFlowContext get context => _context;
  bool get isLoaded => _isLoaded;

  /// Marks the provider ready. Nothing is read back from disk.
  Future<void> load() async {
    _isLoaded = true;
    // Callers may invoke this from initState; notifying synchronously would
    // mark providers dirty mid-build. Defer to after the current build.
    await Future<void>.delayed(Duration.zero);
    notifyListeners();
  }

  /// In-memory transition; nothing is persisted.
  Future<void> moveTo(AuthFlowState next, {AuthFlowContext? context}) async {
    _state = next;
    if (context != null) _context = context;
    debugPrint('[AuthFlow] -> ${next.wireValue}');
    notifyListeners();
  }

  /// Merges fields into the in-memory context without changing the state.
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

  /// Stores the login session (the only thing that is persisted) and flips
  /// to [AuthFlowState.authenticated].
  Future<void> markAuthenticated({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.saveRefreshToken(refreshToken);
    }
    await _secureStorage.saveSession();
    _clearFlowMemory();
    await moveTo(AuthFlowState.authenticated);
  }

  // Registration/KYC tokens live in memory for the current run only.
  Future<void> saveKycToken(String kycToken) async => _kycToken = kycToken;

  Future<String?> readKycToken() async => _kycToken;

  Future<void> saveRegistrationToken(String token) async =>
      _registrationToken = token;

  Future<String?> readRegistrationToken() async => _registrationToken;

  Future<void> clearRegistrationToken() async => _registrationToken = null;

  void _clearFlowMemory() {
    _kycToken = null;
    _registrationToken = null;
    _state = AuthFlowState.unauthenticated;
    _context = AuthFlowContext.empty;
  }

  /// Removes everything older builds persisted about registration / KYC.
  Future<void> _purgeLegacyFlowStorage() async {
    await _secureStorage.delete(StorageKeys.kycToken);
    await _secureStorage.delete(StorageKeys.registrationToken);
    await _localStorage.remove(StorageKeys.registrationDraft);
    await _localStorage.remove(StorageKeys.authFlowState);
    await _localStorage.remove(StorageKeys.authFlowContext);
    await _localStorage.remove(StorageKeys.kycUploadedDocuments);
    await _localStorage.remove(StorageKeys.kycMockLedger);
  }

  /// Drops the in-memory flow (and any legacy persisted traces) without
  /// touching a login session. Used after the last document upload.
  Future<void> clearKycLocalData() async {
    _clearFlowMemory();
    await _purgeLegacyFlowStorage();
    debugPrint('[AuthFlow] KYC data cleared');
    notifyListeners();
  }

  /// Logout / start over: the login session and the whole flow.
  Future<void> clear() async {
    await _secureStorage.clearSession();
    _clearFlowMemory();
    await _purgeLegacyFlowStorage();
    debugPrint('[AuthFlow] cleared');
    notifyListeners();
  }

  /// Where Splash should land: the dashboard when a login session exists
  /// (auto-login), otherwise the welcome screen. Registration and KYC are
  /// never resumed from local data — the user-check screen decides from the
  /// backend.
  Future<AuthStartDestination> resolveStartDestination() async {
    await load();
    await _purgeLegacyFlowStorage();

    if (await _secureStorage.hasValidSession()) {
      return const AuthStartDestination(AppRoutes.dashboard);
    }
    return const AuthStartDestination(AppRoutes.welcome);
  }
}
