import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_response_data.dart';

/// Submission and review status for a KYC application.
abstract class KycServiceBase {
  /// Sends the document manifest. A resubmission carries the previous
  /// `kycId` and an incremented attempt number.
  Future<ApiResponse<KycSubmitResponseData>> submitKyc(
    KycSubmitRequest request,
  );

  /// Polled by the verification screen until the status is terminal.
  Future<ApiResponse<KycStatusResponseData>> getKycStatus({
    required String kycId,
  });

  /// Drops any persisted state for the current application. Called on
  /// logout and once an approval has been converted into an access token,
  /// so a second user on the same device never inherits the first's
  /// review history.
  Future<void> reset();
}
