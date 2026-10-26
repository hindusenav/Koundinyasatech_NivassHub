import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/access_token_response_data.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/create_user_response_data.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/models/auth/login_user_response_data.dart';

/// Contract behind the identifier-first authentication entry: one
/// identifier is checked, then the user either logs in with a password or
/// registers and goes through KYC.
///
/// Deliberately a separate interface from `AuthServiceBase` rather than
/// four more methods on it: the OTP contract it describes is still
/// implemented by `AuthService`/`MockAuthService` and still consumed by
/// the previous entry screens, and widening it would force both of those
/// to grow methods they have no business answering.
abstract class AuthEntryServiceBase {
  /// Decides the branch: existing user → password, new user → registration.
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  );

  Future<ApiResponse<LoginUserResponseData>> loginUser(
    LoginUserRequest request,
  );

  Future<ApiResponse<CreateUserResponseData>> createUser(
    CreateUserRequest request,
  );

  /// Mints the access token that finally grants Dashboard entry. Called
  /// only once KYC reaches APPROVED; [kycId] is the approval it is issued
  /// against.
  Future<ApiResponse<AccessTokenResponseData>> generateAccessToken({
    required String userId,
    required String kycId,
  });
}
