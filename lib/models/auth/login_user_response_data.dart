/// Outcome of `POST /auth/login`.
///
/// The documented contract is exactly `{ ErrorCode, ErrorMsg, RefreshToken
/// }` — no user id, display name or role. [userId]/[fullName]/[role] are
/// always blank after a real login: MISSING API CONTRACT for returning
/// the account's profile at login time; nothing downstream currently
/// requires them for an *existing* user (KYC only runs for new
/// registrations). [accessToken] and [refreshToken] both carry the same
/// `RefreshToken` value — the contract has exactly one token, used both
/// as the bearer token for authenticated requests and for session
/// persistence.
class LoginUserResponseData {
  const LoginUserResponseData({
    required this.authenticated,
    this.userId = '',
    this.fullName = '',
    required this.accessToken,
    this.refreshToken,
    this.role,
    this.kycApproved = true,
  });

  final bool authenticated;
  final String userId;
  final String fullName;
  final String accessToken;
  final String? refreshToken;

  /// Free-text on the wire (`"Owner"`), not the `UserRole` enum. Not
  /// returned by the real backend today.
  final String? role;

  /// Lets an account that logged in but never finished KYC be routed back
  /// into the flow instead of straight to the Dashboard. Not returned by
  /// the real backend today — defaults to `true` since login only
  /// succeeds for an active, existing account.
  final bool kycApproved;

  /// The documented contract is `{ErrorCode, ErrorMsg, RefreshToken}`, but
  /// the live backend actually returns `{success, statusCode, message,
  /// Login_Tokens}` — confirmed against a real 200 response. Both shapes
  /// are accepted so a backend fix (in either direction) doesn't silently
  /// break this again.
  factory LoginUserResponseData.fromJson(Map<String, dynamic> json) {
    final errorCode = json['ErrorCode'] as int? ?? json['statusCode'] as int?;
    final success = json['success'] as bool?;
    final token = (json['RefreshToken'] ?? json['Login_Tokens']) as String?;
    final authenticated =
        (errorCode == 200 || success == true) &&
        token != null &&
        token.isNotEmpty;

    return LoginUserResponseData(
      authenticated: authenticated,
      accessToken: token ?? '',
      refreshToken: token,
    );
  }
}
