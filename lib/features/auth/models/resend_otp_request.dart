/// Request body for `POST /auth/resend-otp`.
class ResendOtpRequest {
  const ResendOtpRequest({required this.mobileNumber});

  final String mobileNumber;

  Map<String, dynamic> toJson() => {'mobileNumber': mobileNumber};
}
