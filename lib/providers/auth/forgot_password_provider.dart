// import 'package:flutter/foundation.dart';
// import 'package:flutter_nivasshub/models/auth/forgot_password_resend_otp_request.dart';
// import 'package:flutter_nivasshub/models/auth/forgot_password_send_otp_request.dart';
// import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_request.dart';
// import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_request.dart';
// import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';

// /// Which channel the user picked on the "Choose Option" screen — drives
// /// whether `cont_code` is sent on Send/Resend OTP and which `otp_type` is
// /// sent on Verify OTP.
// enum ForgotPasswordChannel { mobile, email }

// enum ForgotPasswordStatus {
//   idle,
//   sendingOtp,
//   otpSent,
//   sendOtpError,
//   verifyingOtp,
//   otpVerified,
//   verifyOtpError,
//   resendingOtp,
//   resendOtpError,
//   updatingPassword,
//   passwordUpdated,
//   updatePasswordError,
// }

// /// Drives the Forgot Password flow: sending an OTP (mobile or email),
// /// verifying it, resending it, and updating the password. Mirrors
// /// `AuthProvider`'s loading/success/error pattern but is kept as its own
// /// provider — this flow's state shape (`otpKey`, `fpToken`, `channel`) is
// /// disjoint from the login/registration OTP flow `AuthProvider` already
// /// owns, so sharing one class would mean two parallel sets of "OTP" state
// /// on the same object.
// class ForgotPasswordProvider extends ChangeNotifier {
//   ForgotPasswordProvider({required ForgotPasswordServiceBase forgotPasswordService})
//       : _forgotPasswordService = forgotPasswordService;

//   final ForgotPasswordServiceBase _forgotPasswordService;

//   ForgotPasswordStatus _status = ForgotPasswordStatus.idle;
//   ForgotPasswordChannel? _channel;
//   String? _identifier;
//   String? _otpKey;
//   String? _fpToken;
//   String? _errorMessage;

//   ForgotPasswordStatus get status => _status;
//   ForgotPasswordChannel? get channel => _channel;
//   String? get identifier => _identifier;
//   String? get fpToken => _fpToken;
//   String? get errorMessage => _errorMessage;

//   bool get isSendingOtp => _status == ForgotPasswordStatus.sendingOtp;
//   bool get isVerifyingOtp => _status == ForgotPasswordStatus.verifyingOtp;
//   bool get isResendingOtp => _status == ForgotPasswordStatus.resendingOtp;
//   bool get isUpdatingPassword => _status == ForgotPasswordStatus.updatingPassword;

//   /// India-only, matching `CountryCodeBadge`/`FormValidators.mobileNumber`
//   /// elsewhere in the auth flow.
//   static const String _mobileCountryCode = '+91';

//   Future<bool> sendOtp({
//     required String identifier,
//     required ForgotPasswordChannel channel,
//   }) async {
//     _channel = channel;
//     _identifier = identifier;
//     _errorMessage = null;
//     _status = ForgotPasswordStatus.sendingOtp;
//     notifyListeners();

//     final response = await _forgotPasswordService.sendOtp(
//       ForgotPasswordSendOtpRequest(
//         identifier: identifier,
//         countryCode: channel == ForgotPasswordChannel.mobile ? _mobileCountryCode : null,
//       ),
//     );

//     if (response.isSuccess && response.data != null) {
//       _otpKey = response.data!.otpKey;
//       _status = ForgotPasswordStatus.otpSent;
//       notifyListeners();
//       return true;
//     }
//     _errorMessage = response.message;
//     _status = ForgotPasswordStatus.sendOtpError;
//     notifyListeners();
//     return false;
//   }

//   Future<bool> resendOtp() async {
//     final identifier = _identifier;
//     final channel = _channel;
//     if (identifier == null || channel == null) return false;

//     _errorMessage = null;
//     _status = ForgotPasswordStatus.resendingOtp;
//     notifyListeners();

//     final response = await _forgotPasswordService.resendOtp(
//       ForgotPasswordResendOtpRequest(
//         identifier: identifier,
//         countryCode: channel == ForgotPasswordChannel.mobile ? _mobileCountryCode : null,
//       ),
//     );

//     if (response.isSuccess && response.data != null) {
//       // A resend may rotate the OtpKey server-side — always take the latest.
//       _otpKey = response.data!.otpKey;
//       _status = ForgotPasswordStatus.otpSent;
//       notifyListeners();
//       return true;
//     }
//     _errorMessage = response.message;
//     _status = ForgotPasswordStatus.resendOtpError;
//     notifyListeners();
//     return false;
//   }

//   Future<bool> verifyOtp(String otp) async {
//     final otpKey = _otpKey;
//     final identifier = _identifier;
//     final channel = _channel;
//     if (otpKey == null || identifier == null || channel == null) return false;

//     _errorMessage = null;
//     _status = ForgotPasswordStatus.verifyingOtp;
//     notifyListeners();

//     final response = await _forgotPasswordService.verifyOtp(
//       ForgotPasswordVerifyOtpRequest(
//         otpToken: otpKey,
//         otp: otp,
//         identifier: identifier,
//         // TODO(backend): contract only documents 'SMS' for the mobile
//         // flow — confirm the correct otp_type value for the email flow.
//         otpType: channel == ForgotPasswordChannel.mobile ? 'SMS' : 'EMAIL',
//       ),
//     );

//     if (response.isSuccess && response.data != null) {
//       _fpToken = response.data!.fpToken;
//       _status = ForgotPasswordStatus.otpVerified;
//       notifyListeners();
//       return true;
//     }
//     _errorMessage = response.message;
//     _status = ForgotPasswordStatus.verifyOtpError;
//     notifyListeners();
//     return false;
//   }

//   Future<bool> updatePassword(String newPassword) async {
//     final fpToken = _fpToken;
//     if (fpToken == null) return false;

//     _errorMessage = null;
//     _status = ForgotPasswordStatus.updatingPassword;
//     notifyListeners();

//     final response = await _forgotPasswordService.updatePassword(
//       ForgotPasswordUpdatePasswordRequest(fpToken: fpToken, newPassword: newPassword),
//     );

//     if (response.isSuccess) {
//       _status = ForgotPasswordStatus.passwordUpdated;
//       notifyListeners();
//       return true;
//     }
//     _errorMessage = response.message;
//     _status = ForgotPasswordStatus.updatePasswordError;
//     notifyListeners();
//     return false;
//   }

//   /// Resets all in-memory state back to its initial values. Called when
//   /// (re-)entering the "Choose Option" screen so a stale `fpToken`/`otpKey`
//   /// from a previous, abandoned attempt can never leak into a new one.
//   void reset() {
//     _status = ForgotPasswordStatus.idle;
//     _channel = null;
//     _identifier = null;
//     _otpKey = null;
//     _fpToken = null;
//     _errorMessage = null;
//     notifyListeners();
//   }
// }

/////////////////////////////////////////

// lib/providers/auth/forgot_password_provider.dart

// import 'package:flutter/material.dart';

// enum ForgotPasswordChannel { mobile, email }

// class ForgotPasswordProvider extends ChangeNotifier {
//   bool _isSendingOtp = false;
//   bool _isVerifyingOtp = false;
//   bool _isResendingOtp = false;
//   String? _errorMessage;
//   String? _otpKey;
//   String? _identifier;
//   String? _otpType;
//   ForgotPasswordChannel? _channel;
//   String? _fpToken;
//   int? _resendCount;
//   DateTime? _lastResendTime;

//   // Getters
//   bool get isSendingOtp => _isSendingOtp;
//   bool get isVerifyingOtp => _isVerifyingOtp;
//   bool get isResendingOtp => _isResendingOtp;
//   String? get errorMessage => _errorMessage;
//   String? get otpKey => _otpKey;
//   String? get identifier => _identifier;
//   String? get otpType => _otpType;
//   ForgotPasswordChannel? get channel => _channel;
//   String? get fpToken => _fpToken;
//   int? get resendCount => _resendCount;
//   DateTime? get lastResendTime => _lastResendTime;

//   // ========== NEW METHOD: Set OTP Data ==========
//   void setOtpData({
//     required String otpKey,
//     required String identifier,
//     required String otpType,
//     required ForgotPasswordChannel channel,
//   }) {
//     _otpKey = otpKey;
//     _identifier = identifier;
//     _otpType = otpType;
//     _channel = channel;
//     _resendCount = 0;
//     _lastResendTime = DateTime.now();
//     notifyListeners();
//   }

//   // ========== NEW METHOD: Set FP Token ==========
//   void setFpToken(String token) {
//     _fpToken = token;
//     notifyListeners();
//   }

//   // ========== Loading State Setters ==========
//   void setSendingOtp(bool value) {
//     _isSendingOtp = value;
//     notifyListeners();
//   }

//   void setVerifyingOtp(bool value) {
//     _isVerifyingOtp = value;
//     notifyListeners();
//   }

//   void setResendingOtp(bool value) {
//     _isResendingOtp = value;
//     notifyListeners();
//   }

//   void setError(String? message) {
//     _errorMessage = message;
//     notifyListeners();
//   }

//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   // ========== Resend Tracking ==========
//   void incrementResendCount() {
//     _resendCount = (_resendCount ?? 0) + 1;
//     _lastResendTime = DateTime.now();
//     notifyListeners();
//   }

//   bool canResend() {
//     if (_resendCount == null) return true;
//     if (_resendCount! >= 5) return false;
//     if (_lastResendTime == null) return true;
//     final elapsed = DateTime.now().difference(_lastResendTime!);
//     return elapsed.inSeconds >= 30;
//   }

//   int getRemainingCooldownSeconds() {
//     if (_lastResendTime == null) return 0;
//     final elapsed = DateTime.now().difference(_lastResendTime!);
//     final remaining = 30 - elapsed.inSeconds;
//     return remaining > 0 ? remaining : 0;
//   }

//   int getRemainingResendAttempts() {
//     if (_resendCount == null) return 5;
//     return 5 - _resendCount!;
//   }

//   // ========== Reset ==========
//   void reset() {
//     _isSendingOtp = false;
//     _isVerifyingOtp = false;
//     _isResendingOtp = false;
//     _errorMessage = null;
//     _otpKey = null;
//     _identifier = null;
//     _otpType = null;
//     _channel = null;
//     _fpToken = null;
//     _resendCount = null;
//     _lastResendTime = null;
//     notifyListeners();
//   }

//   // ========== Helper methods (for compatibility) ==========
//   Future<bool> sendOtp({
//     required String identifier,
//     required ForgotPasswordChannel channel,
//   }) async {
//     setSendingOtp(true);
//     clearError();
//     // The actual API call is handled in the screen
//     return true;
//   }

//   Future<bool> resendOtp() async {
//     setResendingOtp(true);
//     clearError();
//     // The actual API call is handled in the screen
//     return true;
//   }

//   Future<bool> verifyOtp({required String otp}) async {
//     setVerifyingOtp(true);
//     clearError();
//     // The actual API call is handled in the screen
//     return true;
//   }
// }

//////////////////////////////////////////

// lib/providers/auth/forgot_password_provider.dart

import 'package:flutter/material.dart';

enum ForgotPasswordChannel { mobile, email }

/// Drives the Forgot Password flow: sending an OTP (mobile or email),
/// verifying it, resending it, and updating the password.
/// Uses simple boolean flags for loading states and stores OTP data
/// that is used across screens.
class ForgotPasswordProvider extends ChangeNotifier {
  // ========== LOADING STATES ==========
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  bool _isResendingOtp = false;
  bool _isUpdatingPassword = false;

  // ========== DATA ==========
  String? _errorMessage;
  String? _otpKey;
  String? _identifier;
  String? _otpType;
  ForgotPasswordChannel? _channel;
  String? _fpToken;
  int? _resendCount;
  DateTime? _lastResendTime;

  // ========== GETTERS ==========
  bool get isSendingOtp => _isSendingOtp;
  bool get isVerifyingOtp => _isVerifyingOtp;
  bool get isResendingOtp => _isResendingOtp;
  bool get isUpdatingPassword => _isUpdatingPassword;
  String? get errorMessage => _errorMessage;
  String? get otpKey => _otpKey;
  String? get identifier => _identifier;
  String? get otpType => _otpType;
  ForgotPasswordChannel? get channel => _channel;
  String? get fpToken => _fpToken;
  int? get resendCount => _resendCount;
  DateTime? get lastResendTime => _lastResendTime;

  // ========== SET OTP DATA (Called after GENERATE or RESEND) ==========
  void setOtpData({
    required String otpKey,
    required String identifier,
    required String otpType,
    required ForgotPasswordChannel channel,
  }) {
    _otpKey = otpKey;
    _identifier = identifier;
    _otpType = otpType;
    _channel = channel;
    _resendCount = 0;
    _lastResendTime = DateTime.now();
    notifyListeners();
  }

  // ========== SET FP TOKEN (Called after VERIFY OTP) ==========
  void setFpToken(String token) {
    _fpToken = token;
    notifyListeners();
  }

  // ========== LOADING STATE SETTERS ==========
  void setSendingOtp(bool value) {
    _isSendingOtp = value;
    notifyListeners();
  }

  void setVerifyingOtp(bool value) {
    _isVerifyingOtp = value;
    notifyListeners();
  }

  void setResendingOtp(bool value) {
    _isResendingOtp = value;
    notifyListeners();
  }

  void setUpdatingPassword(bool value) {
    _isUpdatingPassword = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== RESEND TRACKING ==========
  void incrementResendCount() {
    _resendCount = (_resendCount ?? 0) + 1;
    _lastResendTime = DateTime.now();
    notifyListeners();
  }

  bool canResend() {
    if (_resendCount == null) return true;
    if (_resendCount! >= 5) return false;
    if (_lastResendTime == null) return true;
    final elapsed = DateTime.now().difference(_lastResendTime!);
    return elapsed.inSeconds >= 30;
  }

  int getRemainingCooldownSeconds() {
    if (_lastResendTime == null) return 0;
    final elapsed = DateTime.now().difference(_lastResendTime!);
    final remaining = 30 - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  int getRemainingResendAttempts() {
    if (_resendCount == null) return 5;
    return 5 - _resendCount!;
  }

  // ========== RESET (Called when entering Forgot Password flow) ==========
  void reset() {
    _isSendingOtp = false;
    _isVerifyingOtp = false;
    _isResendingOtp = false;
    _isUpdatingPassword = false;
    _errorMessage = null;
    _otpKey = null;
    _identifier = null;
    _otpType = null;
    _channel = null;
    _fpToken = null;
    _resendCount = null;
    _lastResendTime = null;
    notifyListeners();
  }

  // ========== COMPATIBILITY METHODS ==========
  // These methods exist for backward compatibility with existing code.
  // The actual API calls are now made directly in the screens using
  // ForgotPasswordService, but these methods manage the loading states.

  Future<bool> sendOtp({
    required String identifier,
    required ForgotPasswordChannel channel,
  }) async {
    setSendingOtp(true);
    clearError();
    // API call is handled in the screen
    return true;
  }

  Future<bool> resendOtp() async {
    setResendingOtp(true);
    clearError();
    // API call is handled in the screen
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    setVerifyingOtp(true);
    clearError();
    // API call is handled in the screen
    return true;
  }

  Future<bool> updatePassword(String newPassword) async {
    setUpdatingPassword(true);
    clearError();
    // API call is handled in the screen
    return true;
  }
}
