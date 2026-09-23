import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/visitor/approval_activity_model.dart';

/// The swappable data-source seam for the Activities screen. Implemented by
/// [MockVisitorActivityService] today; once `GET /api/v1/approvals` (API
/// Contract §6.2) is live, add a `VisitorActivityService` that calls it via
/// `ApiClient` and construct that instead in `main.dart` — nothing above this
/// interface (repository/provider/UI) needs to change.
abstract class VisitorActivityServiceBase {
  Future<ApiResponse<List<ApprovalActivityModel>>> getActivities();
}
