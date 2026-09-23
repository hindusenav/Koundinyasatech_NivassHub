/// Request body for POST /auth/forgot-password (action=GENERATE).
///
/// [identifier] is either a 10-digit mobile number or an email address —
/// the backend tells them apart by [countryCode]'s presence, not by
/// inspecting [identifier] itself. [countryCode] must be omitted (left
/// `null`) for the email flow; the mobile flow always sends `'+91'`
/// (matching [CountryCodeBadge]/`FormValidators.mobileNumber`'s
/// India-only assumption elsewhere in the auth flow).
class ForgotPasswordSendOtpRequest {
  const ForgotPasswordSendOtpRequest({
    required this.identifier,
    this.countryCode,
  });

  final String identifier;
  final String? countryCode;

  Map<String, dynamic> toJson() => {
        'umail': identifier,
        if (countryCode != null) 'cont_code': countryCode,
        'action': 'GENERATE',
      };
}
