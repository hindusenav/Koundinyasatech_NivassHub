import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// `data` payload of `POST /auth/check-user`.
///
/// ```json
/// { "success": true, "userExists": false, "identifier": "9876543210" }
/// ```
class CheckUserExistsResponseData {
  const CheckUserExistsResponseData({
    required this.userExists,
    required this.identifier,
    this.maskedIdentifier,
    this.registeredChannel,
  });

  final bool userExists;

  /// Echoed back by the server, normalized.
  final String identifier;

  /// Partially hidden form for the password screen's "logging in as…" line.
  /// Falls back to a client-side mask when the server omits it.
  final String? maskedIdentifier;

  /// Which channel the account was originally registered with — may differ
  /// from the one just used, e.g. registered by email, now entering mobile.
  final AuthChannel? registeredChannel;

  factory CheckUserExistsResponseData.fromJson(Map<String, dynamic> json) {
    return CheckUserExistsResponseData(
      userExists: json['userExists'] as bool? ?? false,
      identifier: json['identifier'] as String? ?? '',
      maskedIdentifier: json['maskedIdentifier'] as String?,
      registeredChannel: json['registeredChannel'] == null
          ? null
          : AuthChannel.fromJson(json['registeredChannel']),
    );
  }
}
