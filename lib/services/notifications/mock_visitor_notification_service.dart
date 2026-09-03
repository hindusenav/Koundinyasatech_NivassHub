import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/utils/json_asset_loader.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_notification_model.dart';
import 'package:flutter_nivasshub/services/notifications/visitor_notification_service_base.dart';

/// Simulates the not-yet-built "pending gate notification" endpoint by
/// reading a bundled JSON fixture, and simulates
/// `POST /api/v1/visitors/{visitorId}/action` with a fixed delay instead of
/// a network call. No `ApiClient`/Dio dependency — mirrors
/// `MockVisitorActivityService`'s pattern in this codebase.
class MockVisitorNotificationService implements VisitorNotificationServiceBase {
  static const String _assetPath = 'assets/json/visitor_notification.json';

  @override
  Future<ApiResponse<VisitorNotificationModel?>> getPendingNotification() async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final map = await JsonAssetLoader.loadMap(_assetPath);
      final succeeded = map['success'] as bool? ?? false;
      final raw = map['notification'] as Map<String, dynamic>?;

      if (!succeeded || raw == null) return ApiResponse.success(null);
      return ApiResponse.success(VisitorNotificationModel.fromJson(raw));
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load the visitor notification right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<void>> respondToVisitor({
    required String visitorId,
    required VisitorAction action,
    String? gate,
  }) async {
    // Mirrors the "show loading for 1 second" requirement — a real
    // implementation POSTs {"action": action.apiValue, "gate": gate} to
    // `ApiEndpoints.visitorAction(visitorId)` here instead.
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse.success(null);
  }
}
