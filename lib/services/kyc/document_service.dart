import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';

/// Dio-backed multipart upload. Not wired up while
/// `KycConfig.useMockKycApi` is true — see `MockDocumentService`.
class DocumentService extends ApiService implements DocumentServiceBase {
  const DocumentService(super.client);

  @override
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  ) {
    return handleRequest(
      () => client.uploadFile(
        ApiEndpoints.kycUpload,
        files: {'document': request.file.path},
        fields: {
          'kycToken': request.kycToken,
          'documentType': request.documentType.wireValue,
          'fileName': request.file.fileName,
        },
      ),
      (json) => DocumentUploadResponseData.fromJson(_unwrap(json)),
    );
  }

  @override
  Future<ApiResponse<void>> deleteDocument({
    required String kycToken,
    required String documentId,
  }) {
    return handleRequest<void>(
      () => client.delete(
        ApiEndpoints.kycDocumentById(documentId),
        data: {'kycToken': kycToken},
      ),
      (_) {},
    );
  }

  static Map<String, dynamic> _unwrap(dynamic json) {
    final map = json as Map<String, dynamic>;
    final data = map['data'];
    return data is Map<String, dynamic> ? data : map;
  }
}
