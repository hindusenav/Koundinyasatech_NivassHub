import 'package:flutter_nivasshub/services/core/api_exception.dart';
import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/utils/json_asset_loader.dart';
import 'package:flutter_nivasshub/models/quick_actions/quick_action_section_model.dart';
import 'package:flutter_nivasshub/services/quick_actions/quick_actions_service_base.dart';

/// Simulates the not-yet-built Quick Actions catalog endpoint by reading a
/// bundled JSON fixture. No `ApiClient`/Dio dependency — swap the
/// `QuickActionsServiceBase` implementation constructed in `main.dart` for a
/// real one once the backend exists; nothing else needs to change.
class MockQuickActionsService implements QuickActionsServiceBase {
  static const String _assetPath = 'assets/json/quick_actions.json';

  @override
  Future<ApiResponse<List<QuickActionSectionModel>>> getQuickActions() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final map = await JsonAssetLoader.loadMap(_assetPath);
      final rawSections = map['sections'] as List<dynamic>? ?? [];
      final sections = rawSections
          .map((e) => QuickActionSectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(sections);
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load Quick Actions right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }
}
