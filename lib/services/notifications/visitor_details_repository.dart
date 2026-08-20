import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_details_model.dart';
import 'package:flutter_nivasshub/services/notifications/visitor_details_service_base.dart';

/// Thin pass-through between `VisitorDetailsProvider` and its data source —
/// mirrors `VisitorNotificationRepository`'s pattern exactly.
class VisitorDetailsRepository {
  VisitorDetailsRepository(this._dataSource);

  final VisitorDetailsServiceBase _dataSource;

  Future<ApiResponse<VisitorDetailsModel>> getVisitorDetails(String visitorId) =>
      _dataSource.getVisitorDetails(visitorId);

  Future<ApiResponse<void>> leaveAtGate(String visitorId) => _dataSource.leaveAtGate(visitorId);
}
