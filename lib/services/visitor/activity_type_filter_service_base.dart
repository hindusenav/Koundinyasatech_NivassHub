import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/models/visitor/activity_type_filter_option.dart';

/// The swappable data-source seam for the "Filter Activity by Type" bottom
/// sheet. Implemented by [MockActivityTypeFilterService] today, since this
/// screen/endpoint isn't in the NivasHub API contract yet — once a real
/// "activity type filters" endpoint is published, add an implementation
/// that calls it via `ApiClient` and construct that instead where
/// `MockActivityTypeFilterService` is constructed today; nothing above this
/// interface (repository/provider/UI) needs to change.
abstract class ActivityTypeFilterServiceBase {
  Future<ApiResponse<List<ActivityTypeFilterOption>>> getFilterOptions();
}
