/// `data` payload of `POST /auth/users`.
///
/// ```json
/// {
///   "success": true, "userId": "USR1001",
///   "kycRequired": true, "kycToken": "mock_kyc_token_1001"
/// }
/// ```
class CreateUserResponseData {
  const CreateUserResponseData({
    required this.userId,
    required this.kycRequired,
    required this.kycToken,
  });

  final String userId;

  /// When `false` the account skips KYC entirely — a defensive branch the
  /// mock never produces today, but the real backend may.
  final bool kycRequired;

  /// Authorizes document upload and submission. Held in secure storage.
  final String kycToken;

  factory CreateUserResponseData.fromJson(Map<String, dynamic> json) {
    return CreateUserResponseData(
      userId: json['userId'] as String? ?? '',
      kycRequired: json['kycRequired'] as bool? ?? true,
      kycToken: json['kycToken'] as String? ?? '',
    );
  }
}
