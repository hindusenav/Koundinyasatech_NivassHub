import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/visitor/activity_type_filter_option.dart';
import 'package:flutter_nivasshub/services/visitor/activity_type_filter_service_base.dart';

/// The seam between `ActivityTypeFilterProvider` and its data source —
/// mirrors `VisitorActivityRepository`/`QuickActionsRepository`'s pattern in
/// this codebase: a thin pass-through that keeps the provider decoupled
/// from the concrete [ActivityTypeFilterServiceBase] implementation it's
/// given.
class ActivityTypeFilterRepository {
  ActivityTypeFilterRepository(this._dataSource);

  final ActivityTypeFilterServiceBase _dataSource;

  Future<ApiResponse<List<ActivityTypeFilterOption>>> getFilterOptions() =>
      _dataSource.getFilterOptions();
}
