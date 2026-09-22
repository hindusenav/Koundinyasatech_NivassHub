/// Body of `POST /otp/resend`.
class OtpResendRequest {
  const OtpResendRequest({
    required this.uid,
    required this.identifier,
    this.otpType = 'UR',
  });

  /// Base64-encoded encrypted user id — the same value `POST
  /// /country-codes/user-registration` returned, sent as-is and never
  /// re-encrypted client-side.
  final String uid;

  /// The mobile number or email address the OTP record was created for.
  final String identifier;
  final String otpType;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'otpType': otpType,
    'identifier': identifier,
  };
}
