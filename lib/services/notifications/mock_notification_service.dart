import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/notifications/mock_notification_model.dart';
import 'package:flutter_nivasshub/services/notifications/notification_service_base.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';

/// Renders the three KYC emails from spec §16, prints them to the console,
/// and keeps them in local storage so the in-app inbox survives a restart.
///
/// Nothing is actually sent — there is no mail transport wired up.
class MockNotificationService implements NotificationServiceBase {
  MockNotificationService(LocalStorageService storage) : _storage = storage;

  final LocalStorageService _storage;

  @override
  Future<ApiResponse<MockNotificationModel>> sendKycNotification({
    required MockNotificationType type,
    required String recipient,
    required String userFullName,
    String? reason,
    List<KycDocumentIssue> issues = const [],
  }) async {
    try {
      final resolvedReason = reason ?? _reasonFrom(issues);
      final body = switch (type) {
        MockNotificationType.kycApproved => KycStrings.emailApprovedBody(
          userFullName,
        ),
        MockNotificationType.kycRejected => KycStrings.emailRejectedBody(
          userFullName,
          resolvedReason,
        ),
        MockNotificationType.kycCorrectionRequired =>
          KycStrings.emailCorrectionBody(userFullName, resolvedReason),
      };

      final notification = MockNotificationModel(
        id: 'NTF${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        subject: type.subject,
        body: body,
        recipient: recipient,
        sentAt: DateTime.now(),
      );

      _log(notification);

      final all = _read()..insert(0, notification);
      await _write(all);

      return ApiResponse.success(notification);
    } catch (e, stack) {
      debugPrint('[MockNotification] send failed: $e\n$stack');
      return ApiResponse.failure(
        const ApiException(
          message: KycStrings.genericError,
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<List<MockNotificationModel>>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      // An empty log is a success with no rows, not a failure — the inbox
      // shows its empty state.
      return ApiResponse.success(_read());
    } catch (e, stack) {
      debugPrint('[MockNotification] read failed: $e\n$stack');
      return ApiResponse.failure(
        const ApiException(
          message: KycStrings.genericError,
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<void>> markAllRead() async {
    final updated = _read()
        .map((n) => n.copyWith(read: true))
        .toList(growable: false);
    await _write(updated);
    return ApiResponse.success(null);
  }

  @override
  Future<ApiResponse<void>> clearNotifications() async {
    await _storage.remove(StorageKeys.mockNotificationLog);
    return ApiResponse.success(null);
  }

  /// Printed as a block rather than one line so the subject and body read
  /// like the email they stand in for.
  void _log(MockNotificationModel n) {
    debugPrint(
      '\n┌─ [MockNotification] ─────────────────────────────\n'
      '│ To:      ${n.recipient}\n'
      '│ Subject: ${n.subject}\n'
      '├──────────────────────────────────────────────────\n'
      '${n.body.split('\n').map((l) => '│ $l').join('\n')}\n'
      '└──────────────────────────────────────────────────\n',
    );
  }

  List<MockNotificationModel> _read() {
    final raw = _storage.getJson(StorageKeys.mockNotificationLog);
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map(
          (e) => MockNotificationModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  Future<void> _write(List<MockNotificationModel> notifications) {
    return _storage.setJson(
      StorageKeys.mockNotificationLog,
      notifications.map((n) => n.toJson()).toList(),
    );
  }

  static String _reasonFrom(List<KycDocumentIssue> issues) {
    if (issues.isEmpty) return KycStrings.genericError;
    return issues
        .map(
          (i) =>
              '• ${KycDocumentCatalog.specFor(i.documentType).title}: '
              '${i.reason}',
        )
        .join('\n');
  }
}
