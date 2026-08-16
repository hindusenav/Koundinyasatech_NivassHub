/// `data` payload for both `POST /auth/send-otp` and `POST /auth/resend-otp`
/// (identical shape).
class SendOtpResponseData {
  const SendOtpResponseData({required this.mobileNumber, required this.otpExpiry});

  final String mobileNumber;

  /// Seconds until the OTP expires.
  final int otpExpiry;

  factory SendOtpResponseData.fromJson(Map<String, dynamic> json) => SendOtpResponseData(
        mobileNumber: json['mobileNumber'] as String? ?? '',
        otpExpiry: json['otpExpiry'] as int? ?? 0,
      );
}
