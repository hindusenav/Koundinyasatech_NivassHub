/// Request body for POST /auth/forgot-password/verify-otp.
///
/// [otpToken] must be the `OtpKey` returned unchanged from the Forgot
/// Password (generate/resend) API — never decoded or modified.
class ForgotPasswordVerifyOtpRequest {
  const ForgotPasswordVerifyOtpRequest({
    required this.otpToken,
    required this.otp,
    required this.identifier,
    required this.otpType,
  });

  final String otpToken;
  final String otp;
  final String identifier;
  final String otpType;

  Map<String, dynamic> toJson() => {
        'otp_token': otpToken,
        'otp': otp,
        'identifier': identifier,
        'otp_type': otpType,
      };
}
