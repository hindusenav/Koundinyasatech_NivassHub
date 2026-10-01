import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';

/// A fixed, three-document catalog standing in for `GET /kyc/documents` —
/// same shape for owner and tenant here, since the real split is entirely
/// a backend configuration concern, not something a client-side fake
/// needs to model.
List<KycApplicableDocument> threeFakeDocuments() => const [
  KycApplicableDocument(documentId: 1, documentName: 'Address Proof 1'),
  KycApplicableDocument(documentId: 2, documentName: 'Address Proof 2'),
  KycApplicableDocument(documentId: 3, documentName: 'Ownership Proof'),
];

/// A minimal [DocumentServiceBase] for tests — the real `DocumentService`
/// talks to `GET /kyc/documents` / `POST /kyc/upload` over Dio, which
/// widget and unit tests have no server for.
class FakeDocumentService implements DocumentServiceBase {
  FakeDocumentService({List<KycApplicableDocument>? documents, this.rotateTokens = false})
    : documents = documents ?? threeFakeDocuments();

  final List<KycApplicableDocument> documents;

  /// When true, every upload answers with a fresh `sessionToken`.
  final bool rotateTokens;
  final uploadRequests = <DocumentUploadRequest>[];

  @override
  Future<ApiResponse<List<KycApplicableDocument>>> getApplicableDocuments({
    required String userToken,
  }) async {
    return ApiResponse.success(documents);
  }

  @override
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  ) async {
    uploadRequests.add(request);
    return ApiResponse.success(
      DocumentUploadResponseData(
        documentId: request.documentId,
        documentName: request.documentName,
        fileName: request.file.fileName,
        fileType: request.file.extension,
        sizeBytes: request.file.sizeBytes,
        uploadedAt: DateTime.now(),
        localPath: request.file.path,
        sessionToken: rotateTokens ? 'ROTATED_${uploadRequests.length}' : null,
      ),
    );
  }

  @override
  Future<ApiResponse<void>> deleteDocument({
    required String userId,
    required int documentId,
  }) async {
    return ApiResponse.success(null);
  }
}
