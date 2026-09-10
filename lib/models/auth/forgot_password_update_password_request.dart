/// Request body for POST /auth/forgot-password/update-password.
///
/// [fpToken] must be exactly the `FP_Token` returned by the Verify OTP API
/// — never generated client-side. The OTP itself is not sent again here.
class ForgotPasswordUpdatePasswordRequest {
  const ForgotPasswordUpdatePasswordRequest({
    required this.fpToken,
    required this.newPassword,
  });

  final String fpToken;
  final String newPassword;

  Map<String, dynamic> toJson() => {
        'FP_Token': fpToken,
        'new_pwd': newPassword,
      };
}
