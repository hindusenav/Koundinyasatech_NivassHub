import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_notification_model.dart';

/// `APPROVE`/`REJECT` — mirrors the exact string values the real
/// `POST /api/v1/visitors/{visitorId}/action` endpoint expects (NivasHub
/// API Contract §6.3), so `apiValue` below is what a real implementation
/// sends verbatim in the request body.
enum VisitorAction { approve, reject }

extension VisitorActionApiValue on VisitorAction {
  String get apiValue => this == VisitorAction.approve ? 'APPROVE' : 'REJECT';
}

/// The swappable data-source seam for the Home screen's visitor-arrival
/// banner. Implemented by [MockVisitorNotificationService] today, since
/// there's no dedicated "pending gate notification" endpoint yet — once one
/// exists (or the Home dashboard response's `notifications.visitorAlert`
/// field, per API Contract §6.1, is wired up instead), add a real
/// implementation and construct that where `MockVisitorNotificationService`
/// is constructed today; nothing above this interface (repository/
/// provider/UI) needs to change. [respondToVisitor] already matches the
/// real, already-published `POST /api/v1/visitors/{visitorId}/action`
/// contract shape, so that half needs no request-shape changes at all.
abstract class VisitorNotificationServiceBase {
  /// The single most-relevant pending visitor/delivery waiting at the gate,
  /// or `null` data when nobody is waiting (the banner simply never shows).
  Future<ApiResponse<VisitorNotificationModel?>> getPendingNotification();

  Future<ApiResponse<void>> respondToVisitor({
    required String visitorId,
    required VisitorAction action,
    String? gate,
  });
}
