import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/json_asset_loader.dart';
import '../models/activity_type_filter_option.dart';
import 'activity_type_filter_service_base.dart';

/// Simulates the not-yet-published "activity type filters" endpoint by
/// reading a bundled JSON fixture. No `ApiClient`/Dio dependency — mirrors
/// `MockQuickActionsService`/`MockVisitorActivityService`'s pattern in this
/// codebase.
class MockActivityTypeFilterService implements ActivityTypeFilterServiceBase {
  static const String _assetPath = 'assets/json/activity_type_filters.json';

  @override
  Future<ApiResponse<List<ActivityTypeFilterOption>>> getFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final rawList = await JsonAssetLoader.loadList(_assetPath);
      final options = rawList
          .map((e) => ActivityTypeFilterOption.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(options);
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load filter options right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }
}
