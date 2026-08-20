/// `data` payload for `POST /auth/verify-otp`.
class VerifyOtpResponseData {
  const VerifyOtpResponseData({required this.userExists, this.registrationToken});

  final bool userExists;

  /// Present only when [userExists] is `false`.
  final String? registrationToken;

  factory VerifyOtpResponseData.fromJson(Map<String, dynamic> json) => VerifyOtpResponseData(
        userExists: json['userExists'] as bool? ?? false,
        registrationToken: json['registrationToken'] as String?,
      );
}
