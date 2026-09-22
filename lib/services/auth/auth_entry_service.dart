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

/// Dio-backed implementation of the two [AuthEntryServiceBase] methods
/// that have a documented backend contract.
///
/// `checkUserExists` calls `POST /country-codes/registration-check`;
/// `loginUser` calls `POST /auth/login`. Neither uses the shared
/// `{success, data}` envelope the rest of the API does — each has its own
/// documented shape, handled directly below.
///
/// `createUser` and `generateAccessToken` deliberately throw
/// [UnimplementedError] here: no documented endpoint exists for either
/// (registration submit / the KYC-approval access token) — MISSING API
/// CONTRACT. This class is never used on its own; `main.dart` wires
/// `PartialRealAuthEntryService`, which delegates those two methods to
/// `MockAuthEntryService` instead of calling them here.
class AuthEntryService extends ApiService implements AuthEntryServiceBase {
  const AuthEntryService(super.client);

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) async {
    final identifier = request.identifier.normalized;
    try {
      await client.post(ApiEndpoints.checkUserExists, data: request.toJson());
      // HTTP 200: the stored procedure allows registration to proceed —
      // the identifier is not yet registered.
      return ApiResponse.success(
        CheckUserExistsResponseData(userExists: false, identifier: identifier),
      );
    } on ApiException catch (e) {
      if (e.type == ApiExceptionType.conflict) {
        // HTTP 409 USER_ALREADY_REGISTERED — an existing account, not a
        // request failure. Surface the backend's own message verbatim.
        return ApiResponse.success(
          CheckUserExistsResponseData(
            userExists: true,
            identifier: identifier,
            statusMessage: e.message,
          ),
        );
      }
      return ApiResponse.failure(e);
    }
  }

  @override
  Future<ApiResponse<LoginUserResponseData>> loginUser(
    LoginUserRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.loginUser, data: request.toJson()),
      (json) => LoginUserResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<CreateUserResponseData>> createUser(
    CreateUserRequest request,
  ) {
    throw UnimplementedError(
      'MISSING API CONTRACT: no documented endpoint for registration '
      'submit. Do not call AuthEntryService.createUser directly — use '
      'PartialRealAuthEntryService, which delegates this to '
      'MockAuthEntryService.',
    );
  }

  @override
  Future<ApiResponse<AccessTokenResponseData>> generateAccessToken({
    required String userId,
    required String kycId,
  }) {
    throw UnimplementedError(
      'MISSING API CONTRACT: no documented endpoint for the KYC-approval '
      'access token. Do not call AuthEntryService.generateAccessToken '
      'directly — use PartialRealAuthEntryService, which delegates this '
      'to MockAuthEntryService.',
    );
  }
}
