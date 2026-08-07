import '../../../core/network/api_response.dart';
import '../models/quick_action_section_model.dart';
import 'quick_actions_service_base.dart';

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
