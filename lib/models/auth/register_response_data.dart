/// `data` payload for `POST /auth/register`.
class RegisterResponseData {
  const RegisterResponseData({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  final String userId;
  final String accessToken;
  final String refreshToken;

  factory RegisterResponseData.fromJson(Map<String, dynamic> json) => RegisterResponseData(
        userId: json['userId'] as String? ?? '',
        accessToken: json['accessToken'] as String? ?? '',
        refreshToken: json['refreshToken'] as String? ?? '',
      );
}
