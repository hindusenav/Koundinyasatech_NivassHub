import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/access_token_response_data.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/create_user_response_data.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/models/auth/login_user_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_entry_service.dart';

/// The [AuthEntryServiceBase] actually wired in `main.dart` once
/// `AuthConfig.useMockApi` is `false`.
///
/// Only `checkUserExists` (`POST /country-codes/registration-check`) and
/// `loginUser` (`POST /auth/login`) have a documented backend contract —
/// those two are delegated to the real, Dio-backed [AuthEntryService].
/// `createUser` (registration submit) and `generateAccessToken` (the
/// KYC-approval token) do not: MISSING API CONTRACT. Both stay on
/// [MockAuthEntryService] so the registration → KYC UI keeps working
/// end-to-end until the backend publishes those two endpoints — at which
/// point only this file needs to change, not any screen or provider.
class PartialRealAuthEntryService implements AuthEntryServiceBase {
  PartialRealAuthEntryService({
    required AuthEntryServiceBase real,
    required MockAuthEntryService mock,
  }) : _real = real,
       _mock = mock;

  final AuthEntryServiceBase _real;
  final MockAuthEntryService _mock;

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) => _real.checkUserExists(request);

  @override
  Future<ApiResponse<LoginUserResponseData>> loginUser(
    LoginUserRequest request,
  ) => _real.loginUser(request);

  @override
  Future<ApiResponse<CreateUserResponseData>> createUser(
    CreateUserRequest request,
  ) => _mock.createUser(request); // MISSING API CONTRACT

  @override
  Future<ApiResponse<AccessTokenResponseData>> generateAccessToken({
    required String userId,
    required String kycId,
  }) => _mock.generateAccessToken(userId: userId, kycId: kycId); // MISSING API CONTRACT
}
