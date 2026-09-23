/// Success payload for POST /auth/forgot-password/verify-otp.
///
/// This endpoint's envelope is `{statusCode, success, FP_Token, message}` —
/// `FP_Token` is a top-level sibling of `success`, not nested under a
/// `data` key, and is mixed-case unlike the rest of this response. Do not
/// route this through `AuthService`-style `_unwrapData`; [fromJson] reads
/// the raw body directly.
///
/// [fpToken] must be stored and passed unchanged to the Update Password
/// API. Do not generate it client-side.
class ForgotPasswordVerifyOtpResponseData {
  const ForgotPasswordVerifyOtpResponseData({required this.fpToken});

  final String fpToken;

  factory ForgotPasswordVerifyOtpResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordVerifyOtpResponseData(
      fpToken: json['FP_Token'] as String? ?? '',
    );
  }
}
