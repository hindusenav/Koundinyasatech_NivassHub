import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_request.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';

/// Which channel the user picked on the "Choose Option" screen — drives
/// whether `cont_code` is sent on Send/Resend OTP and which `otp_type` is
/// sent on Verify OTP.
enum ForgotPasswordChannel { mobile, email }

enum ForgotPasswordStatus {
  idle,
  sendingOtp,
  otpSent,
  sendOtpError,
  verifyingOtp,
  otpVerified,
  verifyOtpError,
  resendingOtp,
  resendOtpError,
  updatingPassword,
  passwordUpdated,
  updatePasswordError,
}

/// Drives the Forgot Password flow: sending an OTP (mobile or email),
/// verifying it, resending it, and updating the password — all through
/// [ForgotPasswordServiceBase], so the real, Dio-backed service and the
/// demo mock can be swapped at the composition root without this provider
/// or any screen knowing which one is in use.
class ForgotPasswordProvider extends ChangeNotifier {
  ForgotPasswordProvider({
    required ForgotPasswordServiceBase forgotPasswordService,
  }) : _forgotPasswordService = forgotPasswordService;

  final ForgotPasswordServiceBase _forgotPasswordService;

  ForgotPasswordStatus _status = ForgotPasswordStatus.idle;
  ForgotPasswordChannel? _channel;
  String? _identifier;
  String? _countryCode;
  String? _otpKey;

  /// The `identifier`/`OTPType` the backend itself returned from the last
  /// GENERATE/RESEND call (e.g. `"E"`/`"UFP"`) — opaque values tied to the
  /// OTP record server-side, distinct from the raw mobile/email [identifier]
  /// typed by the user. Verify OTP must echo these back exactly; sending
  /// the raw identifier and a guessed `otp_type` instead produces a
  /// documented-but-misleading `401 Process declined - identifier
  /// mismatch.` even when the OTP itself is correct.
  String? _backendIdentifier;
  String? _backendOtpType;
  String? _fpToken;
  String? _errorMessage;
  int _resendCount = 0;
  DateTime? _lastResendTime;

  ForgotPasswordStatus get status => _status;
  ForgotPasswordChannel? get channel => _channel;
  String? get identifier => _identifier;
  String? get countryCode => _countryCode;
  String? get otpKey => _otpKey;
  String? get fpToken => _fpToken;
  String? get errorMessage => _errorMessage;

  bool get isSendingOtp => _status == ForgotPasswordStatus.sendingOtp;
  bool get isVerifyingOtp => _status == ForgotPasswordStatus.verifyingOtp;
  bool get isResendingOtp => _status == ForgotPasswordStatus.resendingOtp;
  bool get isUpdatingPassword =>
      _status == ForgotPasswordStatus.updatingPassword;

  /// Sends the initial OTP. [countryCode] (e.g. `+91`) is required for
  /// [ForgotPasswordChannel.mobile] and ignored for
  /// [ForgotPasswordChannel.email] — callers source it from the same
  /// API-driven country picker used elsewhere in the auth flow, never a
  /// hardcoded default.
  Future<bool> sendOtp({
    required String identifier,
    required ForgotPasswordChannel channel,
    String? countryCode,
  }) async {
    _channel = channel;
    _identifier = identifier;
    _countryCode = channel == ForgotPasswordChannel.mobile ? countryCode : null;
    _errorMessage = null;
    _status = ForgotPasswordStatus.sendingOtp;
    notifyListeners();

    final response = await _forgotPasswordService.sendOtp(
      ForgotPasswordSendOtpRequest(
        identifier: identifier,
        countryCode: _countryCode,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _otpKey = response.data!.otpKey;
      _backendIdentifier = response.data!.identifier;
      _backendOtpType = response.data!.otpType;
      _resendCount = 0;
      _lastResendTime = DateTime.now();
      _status = ForgotPasswordStatus.otpSent;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = ForgotPasswordStatus.sendOtpError;
    notifyListeners();
    return false;
  }

  Future<bool> resendOtp() async {
    final identifier = _identifier;
    final channel = _channel;
    if (identifier == null || channel == null) return false;

    if (!canResend()) {
      _errorMessage =
          'Please wait ${getRemainingCooldownSeconds()} second(s) before requesting another resend.';
      _status = ForgotPasswordStatus.resendOtpError;
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    _status = ForgotPasswordStatus.resendingOtp;
    notifyListeners();

    final response = await _forgotPasswordService.resendOtp(
      ForgotPasswordResendOtpRequest(
        identifier: identifier,
        countryCode: _countryCode,
      ),
    );

    if (response.isSuccess && response.data != null) {
      // A resend may rotate the OtpKey (and identifier/otpType) server-side
      // — always take the latest.
      _otpKey = response.data!.otpKey;
      _backendIdentifier = response.data!.identifier;
      _backendOtpType = response.data!.otpType;
      _resendCount++;
      _lastResendTime = DateTime.now();
      _status = ForgotPasswordStatus.otpSent;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = ForgotPasswordStatus.resendOtpError;
    notifyListeners();
    return false;
  }

  Future<bool> verifyOtp(String otp) async {
    final otpKey = _otpKey;
    final identifier = _backendIdentifier;
    final otpType = _backendOtpType;
    if (otpKey == null ||
        identifier == null ||
        identifier.isEmpty ||
        otpType == null ||
        otpType.isEmpty) {
      return false;
    }

    _errorMessage = null;
    _status = ForgotPasswordStatus.verifyingOtp;
    notifyListeners();

    final response = await _forgotPasswordService.verifyOtp(
      ForgotPasswordVerifyOtpRequest(
        otpToken: otpKey,
        otp: otp,
        // Echoed back exactly as the GENERATE/RESEND response returned
        // them — NOT the raw mobile/email or a guessed channel string.
        // Sending the raw identifier produces a real-but-misleading
        // `401 Process declined - identifier mismatch.` even when the OTP
        // digits are correct.
        identifier: identifier,
        otpType: otpType,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _fpToken = response.data!.fpToken;
      _status = ForgotPasswordStatus.otpVerified;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = ForgotPasswordStatus.verifyOtpError;
    notifyListeners();
    return false;
  }

  Future<bool> updatePassword(String newPassword) async {
    final fpToken = _fpToken;
    if (fpToken == null || fpToken.isEmpty) return false;

    _errorMessage = null;
    _status = ForgotPasswordStatus.updatingPassword;
    notifyListeners();

    final response = await _forgotPasswordService.updatePassword(
      ForgotPasswordUpdatePasswordRequest(
        fpToken: fpToken,
        newPassword: newPassword,
      ),
    );

    if (response.isSuccess) {
      _status = ForgotPasswordStatus.passwordUpdated;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message;
    _status = ForgotPasswordStatus.updatePasswordError;
    notifyListeners();
    return false;
  }

  bool canResend() {
    if (_resendCount >= 5) return false;
    if (_lastResendTime == null) return true;
    return DateTime.now().difference(_lastResendTime!).inSeconds >= 30;
  }

  int getRemainingCooldownSeconds() {
    if (_lastResendTime == null) return 0;
    final remaining =
        30 - DateTime.now().difference(_lastResendTime!).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  int getRemainingResendAttempts() => 5 - _resendCount;

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  /// Resets all in-memory state back to its initial values. Called when
  /// (re-)entering the "Choose Option" screen so a stale `fpToken`/`otpKey`
  /// from a previous, abandoned attempt can never leak into a new one.
  void reset() {
    _status = ForgotPasswordStatus.idle;
    _channel = null;
    _identifier = null;
    _countryCode = null;
    _otpKey = null;
    _backendIdentifier = null;
    _backendOtpType = null;
    _fpToken = null;
    _errorMessage = null;
    _resendCount = 0;
    _lastResendTime = null;
    notifyListeners();
  }
}
