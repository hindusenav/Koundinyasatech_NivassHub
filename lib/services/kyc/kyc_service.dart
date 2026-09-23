import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_response_data.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';

/// Dio-backed submission + status polling. Not wired up while
/// `KycConfig.useMockKycApi` is true — see `MockKycService`.
class KycService extends ApiService implements KycServiceBase {
  const KycService(super.client);

  @override
  Future<ApiResponse<KycSubmitResponseData>> submitKyc(
    KycSubmitRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.kycSubmit, data: request.toJson()),
      (json) => KycSubmitResponseData.fromJson(_unwrap(json)),
    );
  }

  @override
  Future<ApiResponse<KycStatusResponseData>> getKycStatus({
    required String kycId,
  }) {
    return handleRequest(
      () => client.get(ApiEndpoints.kycStatus(kycId)),
      (json) => KycStatusResponseData.fromJson(_unwrap(json)),
    );
  }

  /// Nothing is persisted client-side against a real backend — the server
  /// is the record — so there is nothing to drop.
  @override
  Future<void> reset() async {}

  static Map<String, dynamic> _unwrap(dynamic json) {
    final map = json as Map<String, dynamic>;
    final data = map['data'];
    return data is Map<String, dynamic> ? data : map;
  }
}
