import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';

/// Per-document upload, kept separate from [KycServiceBase] because the
/// two have different shapes on the wire: this one is multipart and is
/// called once per card, while submission is a single JSON manifest.
///
/// One document at a time means a failure on the third never invalidates
/// the first two.
abstract class DocumentServiceBase {
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  );

  /// Called when the user removes or replaces an already-uploaded card, so
  /// abandoned files do not accumulate server-side.
  Future<ApiResponse<void>> deleteDocument({
    required String kycToken,
    required String documentId,
  });
}
