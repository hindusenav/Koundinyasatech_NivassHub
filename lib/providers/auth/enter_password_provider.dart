import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';

enum LoginStatus { idle, submitting, success, invalidPassword, error }

/// Backs the password screen for an account that already exists.
///
/// Screen-scoped: the identifier arrives as typed route arguments, so
/// there is no cross-route provider handoff to keep in sync.
class EnterPasswordProvider extends ChangeNotifier {
  EnterPasswordProvider({
    required AuthEntryServiceBase authService,
    required AuthStateProvider authState,
  }) : _authService = authService,
       _authState = authState;

  final AuthEntryServiceBase _authService;
  final AuthStateProvider _authState;

  LoginStatus _status = LoginStatus.idle;
  String? _errorMessage;

  LoginStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _status == LoginStatus.submitting;

  void clearError() {
    if (_errorMessage == null && _status == LoginStatus.idle) return;
    _errorMessage = null;
    _status = LoginStatus.idle;
    notifyListeners();
  }

  /// Returns true only when the session has been stored and the caller
  /// should navigate. A wrong password resolves false with
  /// [LoginStatus.invalidPassword] — the screen renders that inline and
  /// stays put.
  Future<bool> login({
    required AuthIdentifier identifier,
    required String password,
  }) async {
    _status = LoginStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.loginUser(
      LoginUserRequest(identifier: identifier, password: password),
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      if (!data.authenticated || data.accessToken.isEmpty) {
        // A 200 that neither authenticates nor explains itself — treat as
        // a failure rather than storing an empty session.
        _errorMessage = KycStrings.genericError;
        _status = LoginStatus.error;
        notifyListeners();
        return false;
      }

      // The real `/auth/login` contract returns no user id or display
      // name (MISSING API CONTRACT for a login-time profile fetch) — only
      // merge them in when a service actually supplied one, so an empty
      // string never overwrites context set during registration.
      await _authState.updateContext(
        identifier: identifier,
        userId: data.userId.isNotEmpty ? data.userId : null,
        fullName: data.fullName.isNotEmpty ? data.fullName : null,
      );
      await _authState.markAuthenticated(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      _status = LoginStatus.success;
      notifyListeners();
      return true;
    }

    // A rejected credential is its own state so the screen can show the
    // spec's exact wording rather than whatever the transport said.
    final isCredentialFailure =
        response.error?.type == ApiExceptionType.unauthorized;
    _errorMessage = isCredentialFailure
        ? KycStrings.invalidPassword
        : (response.message ?? KycStrings.genericError);
    _status = isCredentialFailure
        ? LoginStatus.invalidPassword
        : LoginStatus.error;
    notifyListeners();
    return false;
  }
}
