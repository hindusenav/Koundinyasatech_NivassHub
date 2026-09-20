import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Body of `POST /auth/check-user` — the single call the authentication
/// entry screen makes to decide between password login and registration.
class CheckUserExistsRequest {
  const CheckUserExistsRequest({required this.identifier});

  final AuthIdentifier identifier;

  Map<String, dynamic> toJson() => {
    'identifier': identifier.normalized,
    'channel': identifier.channel.wireValue,
    if (identifier.countryCode != null) 'countryCode': identifier.countryCode,
  };
}
