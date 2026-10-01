/// Body of `POST /country-codes/user-registration/verify-otp`.
///
/// Exactly `{userId, otp, identifier}` — the backend rejects any other
/// property.
class UserRegistrationVerifyOtpRequest {
  const UserRegistrationVerifyOtpRequest({
    required this.userId,
    required this.otp,
    required this.identifier,
  });

  /// The `registrationToken` from registration / registration-check.
  final String userId;
  final String otp;

  /// `"M"` for mobile, `"E"` for email.
  final String identifier;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'otp': otp,
    'identifier': identifier,
  };
}
