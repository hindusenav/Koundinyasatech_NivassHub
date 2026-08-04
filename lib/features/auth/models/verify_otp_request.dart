/// Request body for `POST /auth/verify-otp`.
class VerifyOtpRequest {
  const VerifyOtpRequest({required this.mobileNumber, required this.otp});

  final String mobileNumber;
  final String otp;

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'otp': otp,
      };
}
