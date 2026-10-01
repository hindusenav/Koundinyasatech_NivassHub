import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';

/// Dio-backed KYC document list + upload.
///
/// `POST /kyc/upload` takes the file itself as Base64 in `doc_url`, one
/// document per request. A 200/201 response carries a fresh
/// `data.sessionToken` that replaces the caller's token.
class DocumentService extends ApiService implements DocumentServiceBase {
  const DocumentService(super.client);

  @override
  Future<ApiResponse<List<KycApplicableDocument>>> getApplicableDocuments({
    required String userToken,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.kycDocuments,
        queryParameters: {'user_token': userToken},
      ),
      (json) => KycApplicableDocument.listFromJson(_unwrapList(json)),
    );
  }

  @override
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  ) async {
    try {
      // The contract takes the file itself, Base64-encoded, in `doc_url`.
      final bytes = await File(request.file.path).readAsBytes();
      final encoded = base64Encode(bytes);

      final response = await client.post(
        ApiEndpoints.kycUpload,
        data: {
          'user_id': request.userId,
          // The API wants a string: document_name_id as text (e.g. "13").
          'doc_id': '${request.documentId}',
          'doc_url': encoded,
        },
      );

      final data = _unwrapMap(response.data);
      // The upload endpoint confirms the document by name, not by id —
      // the id is only ever what this request sent, so it is carried
      // forward rather than re-parsed from the response.
      final parsed = DocumentUploadResponseData.fromJson(data);
      return ApiResponse.success(
        DocumentUploadResponseData(
          documentId: request.documentId,
          documentName: parsed.documentName.isNotEmpty
              ? parsed.documentName
              : request.documentName,
          fileName: request.file.fileName,
          fileType: request.file.extension,
          version: parsed.version,
          actionPerformed: parsed.actionPerformed,
          sizeBytes: request.file.sizeBytes,
          uploadedAt: DateTime.now(),
          localPath: request.file.path,
          // 201 and 200 both return a fresh token that replaces the old.
          sessionToken: data['sessionToken'] as String?,
        ),
      );
    } on ApiException catch (e) {
      debugPrint(
        '[KycUpload] failed status=${e.statusCode} code=${e.code} '
        'correlationId=${e.correlationId}',
      );
      return ApiResponse.failure(_friendlyUploadError(e));
    } on FileSystemException {
      return ApiResponse.failure(
        const ApiException(
          message: 'Could not read the selected file. Please choose it again.',
          type: ApiExceptionType.unknown,
        ),
      );
    } catch (e) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  /// Replaces the raw server text with a user-facing message for each
  /// documented `POST /kyc/upload` failure.
  static ApiException _friendlyUploadError(ApiException e) {
    final server = e.message.toLowerCase();
    final message = switch (e.statusCode) {
      400 => 'This upload could not be processed. Please check the file and try again.',
      403 => 'Your account is not active, so documents cannot be uploaded.',
      404 => 'We could not find this document request. Please refresh and try again.',
      409 when server.contains('reject') =>
        'This document was rejected. Please upload a new one.',
      409 =>
        'This document is already pending review. Please wait for the admin.',
      final int s when s >= 500 => 'Server error. Please try again.',
      _ => null,
    };
    if (message == null) return e;
    return ApiException(
      message: message,
      type: e.type,
      statusCode: e.statusCode,
      fieldErrors: e.fieldErrors,
      data: e.data,
      code: e.code,
    );
  }

  @override
  Future<ApiResponse<void>> deleteDocument({
    required String userId,
    required int documentId,
  }) {
    return handleRequest<void>(
      () => client.delete(
        ApiEndpoints.kycDocumentById('$documentId'),
        data: {'user_id': userId},
      ),
      (_) {},
    );
  }

  static Map<String, dynamic> _unwrapMap(dynamic json) {
    final map = json as Map<String, dynamic>;
    final data = map['data'];
    return data is Map<String, dynamic> ? data : map;
  }

  static dynamic _unwrapList(dynamic json) {
    if (json is Map<String, dynamic>) return json['data'];
    return json;
  }
}
