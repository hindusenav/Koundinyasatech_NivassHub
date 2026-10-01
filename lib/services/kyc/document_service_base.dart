import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';

/// Document-list lookup and per-document upload, kept separate from
/// [KycServiceBase][1] because the two have different shapes on the wire:
/// this one is `GET`-then-multipart and is driven entirely by the
/// backend's own document catalog, while submission is a single JSON
/// manifest built after every card is satisfied.
///
/// [1]: package:flutter_nivasshub/services/kyc/kyc_service_base.dart
///
/// One document at a time means a failure on the third never invalidates
/// the first two.
abstract class DocumentServiceBase {
  /// `GET /kyc/documents?user_token=<userToken>` — the applicable
  /// document list for the caller, entirely backend-configured. The
  /// frontend renders whatever this returns and nothing else.
  Future<ApiResponse<List<KycApplicableDocument>>> getApplicableDocuments({
    required String userToken,
  });

  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  );

  /// Called when the user removes or replaces an already-uploaded card, so
  /// abandoned files do not accumulate server-side.
  Future<ApiResponse<void>> deleteDocument({
    required String userId,
    required int documentId,
  });
}
