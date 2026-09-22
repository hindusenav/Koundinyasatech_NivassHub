/// Parsed `data` payload of `POST
/// /country-codes/user-registration/verify-otp`.
class UserRegistrationVerifyOtpResponseData {
  const UserRegistrationVerifyOtpResponseData({required this.verified});

  final bool verified;

  factory UserRegistrationVerifyOtpResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserRegistrationVerifyOtpResponseData(
      verified: json['verified'] as bool? ?? false,
    );
  }
}
