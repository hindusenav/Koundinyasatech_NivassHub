/// Parsed `data` payload of `POST
/// /country-codes/user-registration/verify-otp` (HTTP 200 `OTP_VERIFIED`).
class UserRegistrationVerifyOtpResponseData {
  const UserRegistrationVerifyOtpResponseData({
    required this.verified,
    this.mobileVerified = false,
    this.emailVerified = false,
    this.accountActivated = false,
    this.sessionToken,
    this.nextStep,
  });

  /// The channel just submitted is verified. A 200 is itself the proof, so
  /// this defaults to `true` when the body carries no explicit flag.
  final bool verified;
  final bool mobileVerified;
  final bool emailVerified;
  final bool accountActivated;

  /// Fresh token issued by the backend; replaces the one held before. Never
  /// generated or decoded client-side.
  final String? sessionToken;

  /// `UVO` — the other channel still needs verifying; `UKYC` — go to KYC.
  final String? nextStep;

  bool get goToKyc => nextStep == 'UKYC';

  factory UserRegistrationVerifyOtpResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserRegistrationVerifyOtpResponseData(
      verified: json['verified'] as bool? ?? true,
      mobileVerified: json['mobileVerified'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      accountActivated: json['accountActivated'] as bool? ?? false,
      sessionToken: json['sessionToken'] as String?,
      nextStep: json['nextStep'] as String?,
    );
  }
}
