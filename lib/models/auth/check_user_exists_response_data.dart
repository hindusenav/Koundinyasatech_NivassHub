import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Outcome of `POST /country-codes/registration-check`.
///
/// This endpoint signals its result via HTTP status rather than a body
/// flag: HTTP 200 means the identifier is free to register
/// ([userExists] `false`); HTTP 409 with `code: "USER_ALREADY_REGISTERED"`
/// means it's already registered ([userExists] `true`). `AuthEntryService`
/// constructs this directly from that status instead of parsing it from a
/// JSON field — there is no `fromJson` here on purpose.
class CheckUserExistsResponseData {
  const CheckUserExistsResponseData({
    required this.userExists,
    required this.identifier,
    this.maskedIdentifier,
    this.registeredChannel,
    this.statusMessage,
  });

  final bool userExists;

  /// Echoed back by the server, normalized.
  final String identifier;

  /// Partially hidden form for the password screen's "logging in as…" line.
  /// Not returned by the real backend — always a client-side mask.
  final String? maskedIdentifier;

  /// Which channel the account was originally registered with. Not
  /// returned by the real backend today.
  final AuthChannel? registeredChannel;

  /// The backend's exact message when [userExists] is `true` — the 409
  /// response's `message` field (e.g. "User is already registered with
  /// Skyline Meadows, Kondapur, Hyderabad."). Shown verbatim rather than a
  /// hardcoded string, per the documented contract.
  final String? statusMessage;
}
