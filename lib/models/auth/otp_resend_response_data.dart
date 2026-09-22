/// Parsed `data` payload of `POST /otp/resend`. The response also carries
/// a plain `otp` value, but that's for trusted backend/SMS-provider
/// handling only — the front end never reads or displays it.
class OtpResendResponseData {
  const OtpResendResponseData({required this.identifier, required this.expiresAt});

  final String identifier;
  final String expiresAt;

  factory OtpResendResponseData.fromJson(Map<String, dynamic> json) {
    return OtpResendResponseData(
      identifier: json['identifier']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
    );
  }
}
