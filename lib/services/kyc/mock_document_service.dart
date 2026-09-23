import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';

/// Simulates the upload without a backend: validate, pause, hand back a
/// document id.
///
/// The returned `documentId` is the whole point — it is what a submission
/// (and a resubmission of a preserved document) sends, so the rest of the
/// flow behaves identically once a real upload endpoint replaces this.
class MockDocumentService implements DocumentServiceBase {
  MockDocumentService();

  int _sequence = 0;

  /// A filename containing this token fails the upload, so the card's
  /// failure + Retry path is reachable on demand. Mirrors the magic-value
  /// convention `MockAuthService` already uses for OTP codes.
  static const String _failToken = 'failupload';

  @override
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  ) async {
    final file = request.file;

    if (request.kycToken.isEmpty) {
      return _failure(KycStrings.genericError, ApiExceptionType.unauthorized);
    }

    // Re-validated server-side even though `FilePickerService` already
    // checked: that is the server's job, and the real service must behave
    // the same way. It is also how the "Invalid Input" state is reachable
    // for this endpoint.
    if (!KycConfig.allowedKycExtensions.contains(file.extension)) {
      return _failure(
        KycStrings.unsupportedFileType(KycConfig.allowedKycExtensions),
        ApiExceptionType.validation,
      );
    }
    if (file.sizeBytes > KycConfig.maxKycFileSizeBytes) {
      return _failure(
        KycStrings.fileTooLarge(KycConfig.maxKycFileSizeBytes),
        ApiExceptionType.validation,
      );
    }

    await Future<void>.delayed(KycConfig.mockDelay);

    if (file.fileName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z]'), '')
        .contains(_failToken)) {
      return _failure(KycStrings.uploadFailed, ApiExceptionType.server);
    }

    _sequence++;
    final documentId = 'DOC${_sequence.toString().padLeft(3, '0')}';
    debugPrint(
      '[MockDocument] uploaded ${file.fileName} '
      'as $documentId for ${request.documentType.wireValue}',
    );

    return ApiResponse.success(
      DocumentUploadResponseData(
        documentId: documentId,
        fileName: file.fileName,
        fileType: file.extension,
        status: 'uploaded',
        sizeBytes: file.sizeBytes,
        uploadedAt: DateTime.now(),
        localPath: file.path,
      ),
    );
  }

  @override
  Future<ApiResponse<void>> deleteDocument({
    required String kycToken,
    required String documentId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    debugPrint('[MockDocument] deleted $documentId');
    return ApiResponse.success(null);
  }

  static ApiResponse<T> _failure<T>(String message, ApiExceptionType type) {
    return ApiResponse.failure(ApiException(message: message, type: type));
  }
}
