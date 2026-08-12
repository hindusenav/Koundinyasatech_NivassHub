import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/json_asset_loader.dart';
import '../models/approval_activity_model.dart';
import 'visitor_activity_service_base.dart';

/// Simulates the not-yet-built `GET /api/v1/approvals` endpoint by reading a
/// bundled JSON fixture. No `ApiClient`/Dio dependency — mirrors
/// `MockQuickActionsService`'s pattern in this codebase.
class MockVisitorActivityService implements VisitorActivityServiceBase {
  static const String _assetPath = 'assets/json/activities.json';

  @override
  Future<ApiResponse<List<ApprovalActivityModel>>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final rawList = await JsonAssetLoader.loadList(_assetPath);
      final activities = rawList
          .map((e) => ApprovalActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(activities);
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load activities right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }
}
