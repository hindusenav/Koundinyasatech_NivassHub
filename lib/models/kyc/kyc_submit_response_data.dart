import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';

/// `data` payload of `POST /kyc/submit`.
///
/// ```json
/// {
///   "success": true, "kycId": "KYC10001",
///   "status": "UNDER_REVIEW", "message": "KYC submitted successfully"
/// }
/// ```
class KycSubmitResponseData {
  const KycSubmitResponseData({
    required this.kycId,
    required this.status,
    this.submittedAt,
    this.message,
  });

  final String kycId;
  final KycVerificationStatus status;
  final DateTime? submittedAt;
  final String? message;

  factory KycSubmitResponseData.fromJson(Map<String, dynamic> json) {
    final rawSubmittedAt = json['submittedAt'];
    return KycSubmitResponseData(
      kycId: json['kycId'] as String? ?? '',
      status: KycVerificationStatus.fromJson(json['status']),
      submittedAt: rawSubmittedAt is String
          ? DateTime.tryParse(rawSubmittedAt)
          : null,
      message: json['message'] as String?,
    );
  }
}
