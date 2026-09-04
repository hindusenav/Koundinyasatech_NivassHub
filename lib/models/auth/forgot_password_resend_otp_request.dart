/// Request body for POST /auth/forgot-password (action=RESEND).
///
/// Same shape as [ForgotPasswordSendOtpRequest] but `action` is fixed to
/// `'RESEND'` internally so callers can't accidentally send a RESEND with a
/// GENERATE action or vice versa. RESEND requires a pending, unexpired,
/// unused OTP already issued for this [identifier] — the backend rejects it
/// with 404 otherwise.
class ForgotPasswordResendOtpRequest {
  const ForgotPasswordResendOtpRequest({
    required this.identifier,
    this.countryCode,
  });

  final String identifier;
  final String? countryCode;

  Map<String, dynamic> toJson() => {
        'umail': identifier,
        if (countryCode != null) 'cont_code': countryCode,
        'action': 'RESEND',
      };
}
