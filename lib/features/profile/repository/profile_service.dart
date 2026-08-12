import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../models/active_society_model.dart';
import '../models/user_profile_model.dart';
import 'profile_service_base.dart';

class ProfileService extends ApiService implements ProfileServiceBase {
  const ProfileService(super.client);

  @override
  Future<ApiResponse<UserProfileModel>> getProfile() {
    return handleRequest(
      () => client.get(ApiEndpoints.userProfile),
      (json) => UserProfileModel.fromJson(_unwrapData(json)),
    );
  }

  @override
  Future<ApiResponse<ActiveSocietyModel>> getActiveSociety() {
    return handleRequest(
      () => client.get(ApiEndpoints.activeSociety),
      (json) => ActiveSocietyModel.fromJson(_unwrapData(json)),
    );
  }

  /// These endpoints wrap their payload in `{status: "success"|"error",
  /// data}` (API contract §2.2/§2.3) — a **string** `status` field, unlike
  /// the `/auth/*` endpoints' **boolean** `success` field
  /// (`AuthService._unwrapData`). Do not copy that helper here verbatim.
  static Map<String, dynamic> _unwrapData(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['status'] != 'success') {
      throw ApiException(
        message: map['message'] as String? ?? 'Request failed. Please try again.',
        type: ApiExceptionType.badRequest,
      );
    }
    return map['data'] as Map<String, dynamic>? ?? {};
  }
}
