import '../../../core/network/api_response.dart';
import '../models/quick_action_section_model.dart';

/// Contract for fetching the Quick Actions catalog. The API contract notes
/// this endpoint doesn't exist yet — "will be shared once the screen designs
/// are finalized" — so [MockQuickActionsService] is the only implementation
/// today. Once a real endpoint ships, a `QuickActionsService extends
/// ApiService implements QuickActionsServiceBase` can be dropped in with no
/// changes to the provider, widgets, or screen.
abstract class QuickActionsServiceBase {
  Future<ApiResponse<List<QuickActionSectionModel>>> getQuickActions();
}
