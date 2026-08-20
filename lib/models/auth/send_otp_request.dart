/// Request body for `POST /auth/send-otp`.
class SendOtpRequest {
  const SendOtpRequest({required this.mobileNumber, this.countryCode = '+91'});

  final String mobileNumber;
  final String countryCode;

  Map<String, dynamic> toJson() => {
        'countryCode': countryCode,
        'mobileNumber': mobileNumber,
      };
}
