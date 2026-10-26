import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/notifications/mock_notification_model.dart';

/// Outbound KYC status emails (spec §16).
///
/// The email service is not connected, so [MockNotificationService] logs
/// to the console and to an in-app inbox instead of sending. Keeping this
/// behind an interface means switching to a real transactional-email
/// provider is a composition-root change, not a rewrite of the KYC flow.
abstract class NotificationServiceBase {
  Future<ApiResponse<MockNotificationModel>> sendKycNotification({
    required MockNotificationType type,
    required String recipient,
    required String userFullName,
    String? reason,
    List<KycDocumentIssue> issues = const [],
  });

  Future<ApiResponse<List<MockNotificationModel>>> getNotifications();

  Future<ApiResponse<void>> markAllRead();

  Future<ApiResponse<void>> clearNotifications();
}
