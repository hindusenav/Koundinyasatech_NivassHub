import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';

/// `data` payload of `GET /kyc/{kycId}/status` — polled by the
/// verification screen until [status] is terminal.
///
/// ```json
/// { "kycId": "KYC10001", "status": "REJECTED",
///   "reason": "Address proof is unclear." }
/// ```
class KycStatusResponseData {
  const KycStatusResponseData({
    required this.kycId,
    required this.status,
    required this.stage,
    this.reason,
    this.invalidDocuments = const [],
    this.reviewedAt,
    this.canResubmit = false,
  });

  final String kycId;
  final KycVerificationStatus status;

  /// Which step of the progress indicator to light up.
  final KycReviewStage stage;

  /// Overall explanation for a rejection or correction request.
  final String? reason;

  /// Per-document objections — what lets the resubmit screen clear only
  /// the offending cards.
  final List<KycDocumentIssue> invalidDocuments;

  final DateTime? reviewedAt;

  /// Whether "Correct & Re-submit" should be offered. Server-driven so a
  /// hard rejection can close the loop without a client-side rule.
  final bool canResubmit;

  List<KycDocumentType> get invalidDocumentTypes =>
      invalidDocuments.map((i) => i.documentType).toList(growable: false);

  factory KycStatusResponseData.fromJson(Map<String, dynamic> json) {
    final status = KycVerificationStatus.fromJson(json['status']);
    final rawReviewedAt = json['reviewedAt'];

    return KycStatusResponseData(
      kycId: json['kycId'] as String? ?? '',
      status: status,
      // Fall back to deriving the stage from the status when the server
      // omits it, so the stepper is never blank.
      stage: json['stage'] == null
          ? KycReviewStage.fromStatus(status)
          : KycReviewStage.fromJson(json['stage']),
      reason: json['reason'] as String?,
      invalidDocuments: KycDocumentIssue.listFromJson(json['invalidDocuments']),
      reviewedAt: rawReviewedAt is String
          ? DateTime.tryParse(rawReviewedAt)
          : null,
      canResubmit: json['canResubmit'] as bool? ?? status.needsResubmission,
    );
  }

  Map<String, dynamic> toJson() => {
    'kycId': kycId,
    'status': status.wireValue,
    'stage': stage.wireValue,
    'reason': reason,
    'invalidDocuments': invalidDocuments.map((i) => i.toJson()).toList(),
    'reviewedAt': reviewedAt?.toIso8601String(),
    'canResubmit': canResubmit,
  };
}
