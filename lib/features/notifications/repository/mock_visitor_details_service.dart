import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/json_asset_loader.dart';
import '../models/visitor_details_model.dart';
import 'visitor_details_service_base.dart';

/// Simulates the not-yet-built "GET visitor details" endpoint by reading a
/// bundled JSON fixture — mirrors `MockVisitorNotificationService`'s pattern
/// exactly. No `ApiClient`/Dio dependency.
class MockVisitorDetailsService implements VisitorDetailsServiceBase {
  static const String _assetPath = 'assets/json/visitor_details.json';

  @override
  Future<ApiResponse<VisitorDetailsModel>> getVisitorDetails(String visitorId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final map = await JsonAssetLoader.loadMap(_assetPath);
      final succeeded = map['success'] as bool? ?? false;
      final raw = map['details'] as Map<String, dynamic>?;

      if (!succeeded || raw == null) {
        return ApiResponse.failure(
          const ApiException(
            message: 'Unable to load visitor details right now.',
            type: ApiExceptionType.unknown,
          ),
        );
      }
      return ApiResponse.success(VisitorDetailsModel.fromJson(raw));
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load visitor details right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<void>> leaveAtGate(String visitorId) async {
    // TODO(api): No contract endpoint exists for "Leave at Gate" yet. Once
    // one is published, POST to it here instead of simulating a delay.
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse.success(null);
  }
}
