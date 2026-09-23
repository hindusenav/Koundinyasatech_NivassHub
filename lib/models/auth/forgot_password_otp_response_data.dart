/// Success payload for POST /auth/forgot-password (both GENERATE and
/// RESEND actions share this shape).
///
/// Unlike the login-flow's OTP models, this does NOT go through
/// `AuthService`-style `{success, message, data}` unwrapping — the real
/// contract returns these fields directly at the top level, in PascalCase
/// (except `identifier`/`OTPType`). [ForgotPasswordService] parses this
/// straight off the raw response body; a `Success: false` body never
/// reaches [fromJson] (the service throws an `ApiException` from `Message`
/// first).
///
/// [otpKey] is `OtpKey` — an opaque encrypted reference to the OTP row.
/// It MUST be stored and passed unchanged (never decoded/modified) to the
/// Verify OTP API as `otp_token`.
class ForgotPasswordOtpResponseData {
  const ForgotPasswordOtpResponseData({
    required this.otpKey,
    required this.identifier,
    required this.otpType,
    this.otp,
  });

  final String otpKey;
  final String identifier;
  final String otpType;

  /// Present only in dev/mock responses — the real backend is not expected
  /// to echo the OTP itself back to the client in production.
  final String? otp;

  factory ForgotPasswordOtpResponseData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordOtpResponseData(
      otpKey: json['OtpKey'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      otpType: json['OTPType'] as String? ?? '',
      otp: json['OTP'] as String?,
    );
  }
}
