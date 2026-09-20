/// `data` payload of a successful password login.
///
/// ```json
/// {
///   "success": true, "userExists": true, "authenticated": true,
///   "token": "mock_access_token_12345",
///   "user": { "id": "USR001", "name": "Test User", "role": "Owner" }
/// }
/// ```
class LoginUserResponseData {
  const LoginUserResponseData({
    required this.authenticated,
    required this.userId,
    required this.fullName,
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

  /// Free-text on the wire (`"Owner"`), not the `UserRole` enum — an
  /// existing account's role is display-only here and never drives the KYC
  /// document set, which only matters during registration.
  final String? role;

  /// Lets an account that logged in but never finished KYC be routed back
  /// into the flow instead of straight to the Dashboard.
  final bool kycApproved;

  factory LoginUserResponseData.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userMap = user is Map ? Map<String, dynamic>.from(user) : const {};

    return LoginUserResponseData(
      authenticated: json['authenticated'] as bool? ?? false,
      userId: userMap['id'] as String? ?? '',
      fullName: userMap['name'] as String? ?? '',
      accessToken:
          json['token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      role: userMap['role'] as String?,
      kycApproved: json['kycApproved'] as bool? ?? true,
    );
  }
}
