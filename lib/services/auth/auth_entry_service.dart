import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/auth/access_token_response_data.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/create_user_response_data.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/models/auth/login_user_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';

/// Dio-backed implementation. Not wired up while
/// `AuthConfig`'s `useMockApi` is true — see `MockAuthEntryService`.
class AuthEntryService extends ApiService implements AuthEntryServiceBase {
  const AuthEntryService(super.client);

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.checkUserExists, data: request.toJson()),
      (json) => CheckUserExistsResponseData.fromJson(_unwrap(json)),
    );
  }

  @override
  Future<ApiResponse<LoginUserResponseData>> loginUser(
    LoginUserRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.loginUser, data: request.toJson()),
      (json) => LoginUserResponseData.fromJson(_unwrap(json)),
    );
  }

  @override
  Future<ApiResponse<CreateUserResponseData>> createUser(
    CreateUserRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.createUser, data: request.toJson()),
      (json) => CreateUserResponseData.fromJson(_unwrap(json)),
    );
  }

  @override
  Future<ApiResponse<AccessTokenResponseData>> generateAccessToken({
    required String userId,
    required String kycId,
  }) {
    return handleRequest(
      () => client.post(
        ApiEndpoints.accessToken,
        data: {'userId': userId, 'kycId': kycId},
      ),
      (json) => AccessTokenResponseData.fromJson(_unwrap(json)),
    );
  }

  /// These endpoints return their fields at the top level alongside
  /// `success` (`{success, userExists, identifier}`) rather than inside a
  /// `data` envelope like the OTP endpoints do — so the whole map is
  /// handed to `fromJson`, unwrapping `data` only if a future contract
  /// revision adds one.
  ///
  /// A `success: false` arriving with an HTTP 200 (which `ApiClient` would
  /// not turn into a `DioException`) is raised here; `handleRequest`'s
  /// existing catch converts it to `ApiResponse.failure`.
  static Map<String, dynamic> _unwrap(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['success'] == false) {
      throw ApiException(
        message:
            map['message'] as String? ?? 'Request failed. Please try again.',
        type: ApiExceptionType.badRequest,
      );
    }
    final data = map['data'];
    return data is Map<String, dynamic> ? data : map;
  }
}
