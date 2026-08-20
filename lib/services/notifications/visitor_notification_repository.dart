import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_notification_model.dart';
import 'package:flutter_nivasshub/services/notifications/visitor_notification_service_base.dart';

/// The seam between `VisitorNotificationProvider` and its data source —
/// mirrors `VisitorActivityRepository`/`QuickActionsRepository`'s pattern in
/// this codebase: a thin pass-through that keeps the provider decoupled
/// from the concrete [VisitorNotificationServiceBase] implementation it's
/// given.
class VisitorNotificationRepository {
  VisitorNotificationRepository(this._dataSource);

  final VisitorNotificationServiceBase _dataSource;

  Future<ApiResponse<VisitorNotificationModel?>> getPendingNotification() =>
      _dataSource.getPendingNotification();

  Future<ApiResponse<void>> respondToVisitor({
    required String visitorId,
    required VisitorAction action,
    String? gate,
  }) =>
      _dataSource.respondToVisitor(visitorId: visitorId, action: action, gate: gate);
}
