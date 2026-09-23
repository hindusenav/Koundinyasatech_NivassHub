/// Body of `POST /country-codes/user-registration/verify-otp`.
class UserRegistrationVerifyOtpRequest {
  const UserRegistrationVerifyOtpRequest({
    required this.userId,
    required this.otp,
    required this.identifier,
    this.otpType = 'UR',
    this.maxAttempts = 5,
  });

  /// Encrypted user id returned by `POST /country-codes/user-registration`.
  final String userId;
  final String otp;

  /// `"M"` for mobile, `"E"` for email.
  final String identifier;
  final String otpType;
  final int maxAttempts;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'otp': otp,
    'identifier': identifier,
    'otpType': otpType,
    'maxAttempts': maxAttempts,
  };
}
