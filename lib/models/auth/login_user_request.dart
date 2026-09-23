import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Body of `POST /auth/login` — the existing-user branch.
///
/// `{ "umail": "...", "pwd": "...", "cont_code": "+91" | null }` — email
/// login sends `cont_code: null`; mobile login sends the dial code.
class LoginUserRequest {
  const LoginUserRequest({required this.identifier, required this.password});

  final AuthIdentifier identifier;
  final String password;

  Map<String, dynamic> toJson() => {
    'umail': identifier.channel == AuthChannel.mobile
        ? identifier.nationalNumber
        : identifier.normalized,
    'pwd': password,
    'cont_code': identifier.channel == AuthChannel.mobile
        ? identifier.countryCode
        : null,
  };
}
