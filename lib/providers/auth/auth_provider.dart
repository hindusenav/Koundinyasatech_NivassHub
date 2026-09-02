import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/auth/register_request.dart';
import 'package:flutter_nivasshub/models/auth/resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/verify_otp_request.dart';
import 'package:flutter_nivasshub/services/auth/auth_service_base.dart';

enum AuthOtpStatus {
  idle,
  sendingOtp,
  otpSent,
  sendOtpError,
  verifyingOtp,
  otpVerified,
  verifyOtpError,
  resendingOtp,
  resendOtpError,
}

/// Drives the mobile-number + OTP login flow: sending an OTP, verifying it,
/// and resending it. Mirrors `DashboardProvider`'s loading/success/error
/// pattern, but returns `Future<bool>` from each action (rather than
/// `Future<void>`) since the calling screen needs to act on *that specific
/// call's* outcome — navigate vs. show a snackbar — not just react to a
/// rebuild.
class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthServiceBase authService}) : _authService = authService;

  final AuthServiceBase _authService;

  AuthOtpStatus _status = AuthOtpStatus.idle;
  String? _mobileNumber;
  int _otpExpirySeconds = 0;
  bool _userExists = false;
  String? _registrationToken;
  String? _errorMessage;

  bool _isRegistering = false;
  String? _userId;
  String? _accessToken;
  String? _refreshToken;

  AuthOtpStatus get status => _status;
  String? get mobileNumber => _mobileNumber;
  int get otpExpirySeconds => _otpExpirySeconds;
  bool get userExists => _userExists;
  String? get registrationToken => _registrationToken;
  String? get errorMessage => _errorMessage;

  bool get isSendingOtp => _status == AuthOtpStatus.sendingOtp;
  bool get isVerifyingOtp => _status == AuthOtpStatus.verifyingOtp;
  bool get isResendingOtp => _status == AuthOtpStatus.resendingOtp;

  bool get isRegistering => _isRegistering;
  String? get userId => _userId;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  /// Clears state scoped to a single OTP verification attempt — called at
  /// the start of [sendOtp] so a stale `userExists`/`registrationToken`
  /// from a previous, abandoned flow (e.g. user backed out and re-entered
  /// Login) can never leak into a new verification. Deliberately does not
  /// touch `_accessToken`/`_refreshToken`/`_userId` (set by
  /// `completeRegistration`, meaningful only after a flow completes) or
  /// `_otpExpirySeconds` (reused by `resendOtp`).
  void _resetOtpFlowState() {
    _userExists = false;
    _registrationToken = null;
    _errorMessage = null;
  }

  Future<bool> sendOtp(String mobileNumber) async {
    _resetOtpFlowState();
    _status = AuthOtpStatus.sendingOtp;
    notifyListeners();

    final response = await _authService.sendOtp(SendOtpRequest(mobileNumber: mobileNumber));

    if (response.isSuccess && response.data != null) {
      _mobileNumber = response.data!.mobileNumber;
      _otpExpirySeconds = response.data!.otpExpiry;
      _status = AuthOtpStatus.otpSent;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = AuthOtpStatus.sendOtpError;
    notifyListeners();
    return false;
  }

  Future<bool> verifyOtp(String otp) async {
    final mobile = _mobileNumber;
    if (mobile == null) return false;

    _status = AuthOtpStatus.verifyingOtp;
    _errorMessage = null;
    notifyListeners();

    final response =
        await _authService.verifyOtp(VerifyOtpRequest(mobileNumber: mobile, otp: otp));

    if (response.isSuccess && response.data != null) {
      _userExists = response.data!.userExists;
      _registrationToken = response.data!.registrationToken;
      _status = AuthOtpStatus.otpVerified;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = AuthOtpStatus.verifyOtpError;
    notifyListeners();
    return false;
  }

  Future<bool> resendOtp() async {
    final mobile = _mobileNumber;
    if (mobile == null) return false;

    _status = AuthOtpStatus.resendingOtp;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.resendOtp(ResendOtpRequest(mobileNumber: mobile));

    if (response.isSuccess) {
      // Resend has no data payload per the real contract — _otpExpirySeconds
      // is deliberately left untouched, so the OTP screen's existing
      // `_secondsRemaining = auth.otpExpirySeconds` restarts the countdown
      // using the last known duration from the original sendOtp call, which
      // is the only value the backend ever supplies.
      _status = AuthOtpStatus.otpSent;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = AuthOtpStatus.resendOtpError;
    notifyListeners();
    return false;
  }

  /// Resets all in-memory auth state back to its initial (never-logged-in)
  /// values. Called on manual logout so a subsequent login flow — within
  /// the same running app process — starts clean instead of inheriting
  /// stale OTP/registration state from the previous session. This is a
  /// superset of [_resetOtpFlowState], which stays scoped to its narrower
  /// purpose inside [sendOtp].
  void logout() {
    _status = AuthOtpStatus.idle;
    _mobileNumber = null;
    _otpExpirySeconds = 0;
    _userExists = false;
    _registrationToken = null;
    _errorMessage = null;
    _isRegistering = false;
    _userId = null;
    _accessToken = null;
    _refreshToken = null;
    debugPrint('[Auth] AuthProvider.logout() - in-memory auth state reset');
    notifyListeners();
  }

  Future<bool> completeRegistration({
    required String fullName,
    String? email,
    required String password,
    required String confirmPassword,
    required String address,
  }) async {
    final mobile = _mobileNumber;
    final token = _registrationToken;
    if (mobile == null || token == null) return false;

    _isRegistering = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.register(
      RegisterRequest(
        mobileNumber: mobile,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        address: address,
        registrationToken: token,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _userId = response.data!.userId;
      _accessToken = response.data!.accessToken;
      _refreshToken = response.data!.refreshToken;
      _isRegistering = false;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _isRegistering = false;
    notifyListeners();
    return false;
  }
}
