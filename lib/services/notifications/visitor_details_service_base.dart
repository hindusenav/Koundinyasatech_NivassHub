import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_details_model.dart';

/// The swappable data-source seam for the "Delivery Details" screen.
/// Implemented by [MockVisitorDetailsService] today, following the exact
/// same mock-first convention as `VisitorNotificationServiceBase` — a real
/// implementation is dropped in later wherever `MockVisitorDetailsService`
/// is constructed today (`DeliveryDetailsScreen.build`); nothing above this
/// interface (repository/provider/UI) changes.
abstract class VisitorDetailsServiceBase {
  /// Full details for one visitor/delivery, keyed by the same `id` the
  /// gate-arrival notification card uses (`VisitorNotificationModel.id`).
  /// No contract endpoint exists yet — a real implementation would likely
  /// call `ApiEndpoints.visitorById(id)` (already defined, currently
  /// unused) or a dedicated `/visitors/{id}/details` endpoint once one is
  /// published.
  Future<ApiResponse<VisitorDetailsModel>> getVisitorDetails(String visitorId);

  /// "Leave at Gate" — unlike Approve/Reject (which already match the
  /// published NivasHub API Contract §6.3), no contract endpoint exists for
  /// this action at all yet. Mock-only/TODO until one is designed.
  Future<ApiResponse<void>> leaveAtGate(String visitorId);
}
