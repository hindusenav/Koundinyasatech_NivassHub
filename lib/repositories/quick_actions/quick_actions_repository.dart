import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/quick_actions/quick_action_section_model.dart';
import 'package:flutter_nivasshub/services/quick_actions/quick_actions_service_base.dart';

/// The seam between the Quick Actions provider and its data source, mirroring
/// `DashboardRepository`'s pattern in this codebase — a concrete class (no
/// abstract repository interface, matching that existing precedent) that
/// takes a data source in its constructor and exposes the typed methods the
/// provider calls. Thin by design: unlike `DashboardRepository`, the data
/// source here (`QuickActionsServiceBase`) already returns typed models, so
/// there is no JSON parsing left for this layer to do — its only job is to
/// be the swappable seam between "data access" and "state" layers.
class QuickActionsRepository {
  QuickActionsRepository(this._dataSource);

  final QuickActionsServiceBase _dataSource;

  Future<ApiResponse<List<QuickActionSectionModel>>> getQuickActions() =>
      _dataSource.getQuickActions();
}
