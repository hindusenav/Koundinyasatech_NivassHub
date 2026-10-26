import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Body of `POST /country-codes/registration-check` — the single call the
/// authentication entry screen makes to decide between password login and
/// registration.
///
/// Mobile: `{ "umail": "9876543210", "cont_code": "+91" }`.
/// Email: `{ "umail": "user@example.com" }` — `cont_code` is omitted
/// entirely, never sent as `null`.
///
/// The documented field name is `mobile_cont_code`, but the live backend
/// rejects that with HTTP 400 and only accepts `cont_code` (confirmed via
/// DevTools against a real request) — another doc-vs-live drift, same
/// pattern as `/country-codes` and `/auth/login`.
class CheckUserExistsRequest {
  const CheckUserExistsRequest({required this.identifier});

  final AuthIdentifier identifier;

  Map<String, dynamic> toJson() => {
    'umail': identifier.channel == AuthChannel.mobile
        ? identifier.nationalNumber
        : identifier.normalized,
    if (identifier.channel == AuthChannel.mobile &&
        identifier.countryCode != null)
      'cont_code': identifier.countryCode,
  };
}
