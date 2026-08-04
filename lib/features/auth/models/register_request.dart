/// Request body for `POST /auth/register` (the Create Profile screen's
/// submit action).
class RegisterRequest {
  const RegisterRequest({
    required this.mobileNumber,
    required this.fullName,
    this.email,
    required this.password,
    required this.confirmPassword,
    required this.address,
    required this.registrationToken,
  });

  final String mobileNumber;
  final String fullName;

  /// Optional — omitted from [toJson] entirely when null/blank.
  final String? email;

  final String password;
  final String confirmPassword;
  final String address;

  /// Not present in the documented `/auth/register` request sample, but
  /// sent anyway — carried over from the verify-otp response so the
  /// backend can tie this submission back to the OTP-verified session.
  final String registrationToken;

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'fullName': fullName,
        if (email != null && email!.trim().isNotEmpty) 'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'address': address,
        'registrationToken': registrationToken,
      };
}
