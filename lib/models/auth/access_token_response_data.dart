/// `data` payload of `POST /auth/access-token` — minted once KYC reaches
/// APPROVED, which is what finally grants Dashboard access.
///
/// ```json
/// {
///   "success": true, "status": "APPROVED",
///   "token": "mock_access_token_xyz", "userAccess": true
/// }
/// ```
class AccessTokenResponseData {
  const AccessTokenResponseData({
    required this.accessToken,
    required this.userAccess,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresInSeconds,
  });

  final String accessToken;

  /// The server's explicit "this user may now enter" flag. Checked
  /// alongside a non-empty token before the session is saved.
  final bool userAccess;

  final String? refreshToken;
  final String tokenType;
  final int? expiresInSeconds;

  factory AccessTokenResponseData.fromJson(Map<String, dynamic> json) {
    return AccessTokenResponseData(
      accessToken:
          json['token'] as String? ?? json['accessToken'] as String? ?? '',
      userAccess: json['userAccess'] as bool? ?? false,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresInSeconds: json['expiresIn'] as int?,
    );
  }
}
