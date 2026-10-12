import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_response_data.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';

/// Real KYC backend.
///
/// There is no separate submit call: the upload that returns `202` (see
/// `DocumentService`) is what moves the KYC to review. Status is read from
/// `GET /kyc/documents?user_token=<session-token>` — the same endpoint that
/// lists the role's documents — whose `uploadedDocuments` array is the
/// record of what the user has submitted. The session token doubles as the
/// `kycId` throughout the app.
class KycService extends ApiService implements KycServiceBase {
  const KycService(super.client);

  /// Nothing to send — the final upload already submitted the KYC. Returns
  /// the current session token as the `kycId` so the status screen can poll.
  @override
  Future<ApiResponse<KycSubmitResponseData>> submitKyc(
    KycSubmitRequest request,
  ) async {
    return ApiResponse.success(
      KycSubmitResponseData(
        kycId: request.userId,
        status: KycVerificationStatus.underReview,
      ),
    );
  }

  @override
  Future<ApiResponse<KycStatusResponseData>> getKycStatus({
    required String kycId,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.kycDocuments,
        queryParameters: {'user_token': kycId},
      ),
      (json) => _statusFrom(kycId, json),
    );
  }

  /// Nothing is persisted client-side against a real backend — the server
  /// is the record — so there is nothing to drop.
  @override
  Future<void> reset() async {}

  /// Derives the review status from `uploadedDocuments`. A per-document
  /// `status` is read when the backend sends one (any of the common
  /// spellings); otherwise uploaded documents are simply "under review".
  static KycStatusResponseData _statusFrom(String kycId, dynamic json) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    final uploaded = map['uploadedDocuments'];
    final docs = uploaded is List
        ? uploaded.whereType<Map>().toList()
        : const <Map>[];

    final statuses = [
      for (final d in docs)
        '${d['status'] ?? d['document_status'] ?? d['kyc_status'] ?? d['review_status'] ?? ''}'
            .toLowerCase(),
    ];

    final KycVerificationStatus status;
    if (docs.isEmpty) {
      status = KycVerificationStatus.submitted;
    } else if (statuses.any((s) => s.contains('reject'))) {
      status = KycVerificationStatus.rejected;
    } else if (statuses.isNotEmpty &&
        statuses.every((s) => s.contains('approv') || s.contains('verified'))) {
      status = KycVerificationStatus.approved;
    } else {
      status = KycVerificationStatus.underReview;
    }

    return KycStatusResponseData(
      kycId: kycId,
      status: status,
      stage: KycReviewStage.fromStatus(status),
      reason: status == KycVerificationStatus.rejected
          ? map['message'] as String?
          : null,
    );
  }
}
