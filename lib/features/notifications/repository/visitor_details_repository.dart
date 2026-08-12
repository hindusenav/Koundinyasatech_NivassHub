import '../../../core/network/api_response.dart';
import '../models/visitor_details_model.dart';
import 'visitor_details_service_base.dart';

/// Thin pass-through between `VisitorDetailsProvider` and its data source —
/// mirrors `VisitorNotificationRepository`'s pattern exactly.
class VisitorDetailsRepository {
  VisitorDetailsRepository(this._dataSource);

  final VisitorDetailsServiceBase _dataSource;

  Future<ApiResponse<VisitorDetailsModel>> getVisitorDetails(String visitorId) =>
      _dataSource.getVisitorDetails(visitorId);

  Future<ApiResponse<void>> leaveAtGate(String visitorId) => _dataSource.leaveAtGate(visitorId);
}
