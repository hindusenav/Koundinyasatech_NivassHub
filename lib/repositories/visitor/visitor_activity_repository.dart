import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/visitor/approval_activity_model.dart';
import 'package:flutter_nivasshub/services/visitor/visitor_activity_service_base.dart';

/// The seam between the Activities provider and its data source, mirroring
/// `QuickActionsRepository`'s pattern in this codebase — a thin pass-through
/// that keeps the provider decoupled from the concrete
/// [VisitorActivityServiceBase] implementation it's given.
class VisitorActivityRepository {
  VisitorActivityRepository(this._dataSource);

  final VisitorActivityServiceBase _dataSource;

  Future<ApiResponse<List<ApprovalActivityModel>>> getActivities() =>
      _dataSource.getActivities();
}
