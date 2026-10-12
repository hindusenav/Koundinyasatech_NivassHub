import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_user_document.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';

/// Dio-backed KYC document list + upload.
///
/// Upload is one multipart `POST /kyc/upload` (`user_id`, `doc_id`, file).
/// 201 = inserted, 202 = last required document uploaded, 200 = re-uploaded.
/// `data.sessionToken` replaces the caller's token.
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
      (json) {
        final documents = KycApplicableDocument.listFromJson(_unwrapList(json));
        final uploaded = _uploadedStatuses(json);
        return [
          for (final d in documents)
            uploaded.containsKey(d.documentId)
                ? d.markUploaded(uploaded[d.documentId]!)
                : d,
        ];
      },
    );
  }

  /// Document id -> `Document_Status` for everything the backend already
  /// holds, from the root-level `uploadedDocuments` array.
  static Map<int, String> _uploadedStatuses(dynamic json) {
    if (json is! Map<String, dynamic>) return const {};
    final raw = json['uploadedDocuments'];
    if (raw is! List) return const {};
    final statuses = <int, String>{};
    for (final entry in raw.whereType<Map>()) {
      final id =
          entry['document_name_id'] ??
          entry['documentNameId'] ??
          entry['documentId'] ??
          entry['doc_id'];
      final parsed = id is int ? id : int.tryParse('$id');
      if (parsed == null) continue;
      statuses[parsed] =
          '${entry['Document_Status'] ?? entry['document_status'] ?? entry['status'] ?? ''}';
    }
    return statuses;
  }

  @override
  Future<ApiResponse<KycUserDocumentsResult>> getUserDocuments({
    required String userToken,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.kycUserDocuments,
        queryParameters: {'user_token': userToken},
      ),
      KycUserDocumentsResult.fromJson,
    );
  }

  @override
  Future<ApiResponse<DocumentUploadResponseData>> uploadDocument(
    DocumentUploadRequest request,
  ) async {
    try {
      // Single multipart call: `user_id`, `doc_id` and the file. The backend
      // decides insert vs. re-upload and the version.
      final endpoint = request.isReupload
          ? ApiEndpoints.kycReUpload
          : ApiEndpoints.kycUpload;
      if (kDebugMode) {
        debugPrint(
          '[KycUpload] POST $endpoint '
          'user_id=${_redact(request.userId)} doc_id=${request.documentId} '
          'file=${request.file.path}',
        );
      }
      final response = await client.uploadFile(
        endpoint,
        files: {'file': request.file.path},
        fields: {
          'user_id': request.userId,
          'doc_id': '${request.documentId}',
        },
      );
      if (kDebugMode) {
        debugPrint(
          '[KycUpload] status=${response.statusCode} body=${response.data}',
        );
      }

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
          // 202 = last required document uploaded.
          allDocumentsUploaded: response.statusCode == 202,
        ),
      );
    } on ApiException catch (e) {
      debugPrint(
        '[KycUpload] failed status=${e.statusCode} code=${e.code} '
        'correlationId=${e.correlationId}',
      );
      if (kDebugMode) {
        debugPrint(
          '[KycUpload] failed doc_id=${request.documentId} '
          'serverMessage="${e.message}" body=${e.data}',
        );
      }
      return ApiResponse.failure(_friendlyUploadError(e));
    } on FileSystemException {
      return ApiResponse.failure(
        const ApiException(
          message: 'Could not read the selected file. Please choose it again.',
          type: ApiExceptionType.unknown,
        ),
      );
    } catch (e, st) {
      debugPrint('[KycUpload] unexpected ${e.runtimeType}: $e\n$st');
      return ApiResponse.failure(
        const ApiException(
          message: 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  /// True when the error body carried a message of its own (as opposed to
  /// the client's generated fallback text).
  static bool _hasServerMessage(ApiException e) {
    final body = e.data;
    if (body == null) return false;
    final m = body['message'] ?? body['error'];
    return m is String && m.trim().isNotEmpty;
  }

  /// Token shown as its last 4 characters only, for debug logs.
  static String _redact(String value) =>
      value.length <= 4 ? '****' : '****${value.substring(value.length - 4)}';

  /// Replaces the raw server text with a user-facing message for each
  /// documented `POST /kyc/re-upload` failure. A 409 shows the server's own
  /// business message (pending / rejected).
  static ApiException _friendlyUploadError(ApiException e) {
    final message = switch (e.statusCode) {
      400 when _hasServerMessage(e) => e.message,
      400 => 'This upload could not be processed. Please check the file and try again.',
      403 => 'Your account is not active, so documents cannot be uploaded.',
      // The server's own 404 text names what it could not find, so it is
      // shown as-is; the generic wording is only a fallback for an empty body.
      404 when _hasServerMessage(e) => e.message,
      404 => 'We could not find this document request. Please refresh and try again.',
      409 when e.message.trim().isNotEmpty => e.message,
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
