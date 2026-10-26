import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';

/// Where `POST /country-codes/registration-check` says a identifier stands,
/// beyond the plain registered / not-registered split.
enum RegistrationCheckOutcome {
  /// 200 USER_NOT_REGISTERED.
  notRegistered,

  /// 409 USER_ALREADY_REGISTERED.
  alreadyRegistered,

  /// 403 MOBILE_NOT_VERIFIED — resume OTP, mobile only.
  mobileNotVerified,

  /// 428 EMAIL_NOT_VERIFIED — resume OTP, email only.
  emailNotVerified,

  /// 412 MOBILE_EMAIL_NOT_VERIFIED — resume OTP, both channels.
  mobileEmailNotVerified,

  /// 424 MOBILE_EMAIL_VERIFIED, or a registered account whose KYC is
  /// outstanding — straight to the KYC documents screen.
  verifiedGoToKyc,

  /// 423 KYC_IN_PROGRESS — blocked until the review finishes.
  kycInProgress,
}

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
    this.kycPending = false,
    this.userId,
    this.outcome,
    this.registrationToken,
  });

  /// The precise registration-check result. `null` only for the legacy
  /// mock service, which sets just [userExists]/[kycPending]; use
  /// [resolvedOutcome] to read it.
  final RegistrationCheckOutcome? outcome;

  /// Token the backend returns for the resume states (403/412/424/428),
  /// passed straight to OTP verify/resend or `GET /kyc/documents`. Never
  /// generated or decoded client-side.
  final String? registrationToken;

  RegistrationCheckOutcome get resolvedOutcome =>
      outcome ??
      (kycPending
          ? RegistrationCheckOutcome.verifiedGoToKyc
          : userExists
          ? RegistrationCheckOutcome.alreadyRegistered
          : RegistrationCheckOutcome.notRegistered);

  final bool userExists;

  /// Echoed back by the server, normalized.
  final String identifier;

  /// Partially hidden form for the password screen's "logging in as…" line.
  /// Not returned by the real backend — always a client-side mask.
  final String? maskedIdentifier;

  /// Which channel the account was originally registered with. Not
  /// returned by the real backend today.
  final AuthChannel? registeredChannel;

  /// The backend's exact message when [userExists] is `true` — the
  /// 409/422 response's `message` field (e.g. "User is already registered
  /// with Skyline Meadows, Kondapur, Hyderabad."). Shown verbatim rather
  /// than a hardcoded string, per the documented contract.
  final String? statusMessage;

  /// `true` when the account is registered but hasn't completed KYC yet
  /// (the backend's "User is already registered and verified. KYC
  /// completion is pending." case — seen on both 409 and 422 so far).
  /// When `true`, the entry screen skips the password step entirely and
  /// goes straight to the KYC documents screen.
  final bool kycPending;

  /// The encrypted user identifier from that same response's `data.userId`
  /// — only present when [kycPending] is `true`. This is the `user_token`
  /// `GET /kyc/documents` expects; never a plain id, never decrypted here.
  final String? userId;
}
