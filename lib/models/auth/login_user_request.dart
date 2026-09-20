import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Body of `POST /auth/login-password` — the existing-user branch.
class LoginUserRequest {
  const LoginUserRequest({required this.identifier, required this.password});

  final AuthIdentifier identifier;
  final String password;

  Map<String, dynamic> toJson() => {
    'identifier': identifier.normalized,
    'channel': identifier.channel.wireValue,
    if (identifier.countryCode != null) 'countryCode': identifier.countryCode,
    'password': password,
  };
}
