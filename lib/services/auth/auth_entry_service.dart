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
      final resume = _resumeOutcome(e);
      if (resume != null) {
        return ApiResponse.success(
          CheckUserExistsResponseData(
            // Registered, just not finished: not a fresh sign-up.
            userExists: true,
            identifier: identifier,
            statusMessage: e.message,
            kycPending: resume == RegistrationCheckOutcome.verifiedGoToKyc,
            userId: _registrationToken(e),
            registrationToken: _registrationToken(e),
            outcome: resume,
          ),
        );
      }
      if (e.type == ApiExceptionType.conflict ||
          e.type == ApiExceptionType.validation) {
        // HTTP 409 USER_ALREADY_REGISTERED, or HTTP 422 for the same
        // "already registered" case when KYC is what's outstanding — an
        // existing account either way, not a request failure. The two
        // codes are keyed off the same message/data shape rather than
        // strictly split by status, since the backend has been observed
        // sending the KYC-pending case as both.
        final userData = e.data?['data'];
        final pending = _isKycPending(e.message);
        return ApiResponse.success(
          CheckUserExistsResponseData(
            userExists: true,
            identifier: identifier,
            statusMessage: e.message,
            kycPending: pending,
            userId: pending && userData is Map
                ? userData['userId'] as String?
                : null,
            outcome: pending
                ? RegistrationCheckOutcome.verifiedGoToKyc
                : RegistrationCheckOutcome.alreadyRegistered,
          ),
        );
      }
      return ApiResponse.failure(e);
    }
  }

  /// Maps the resume / blocked registration-check responses to an outcome,
  /// keyed on the `code` first and the HTTP status second. `null` for
  /// everything else (409 already-registered, real failures).
  static RegistrationCheckOutcome? _resumeOutcome(ApiException e) {
    switch (e.code) {
      case 'MOBILE_NOT_VERIFIED':
        return RegistrationCheckOutcome.mobileNotVerified;
      case 'EMAIL_NOT_VERIFIED':
        return RegistrationCheckOutcome.emailNotVerified;
      case 'MOBILE_EMAIL_NOT_VERIFIED':
        return RegistrationCheckOutcome.mobileEmailNotVerified;
      case 'MOBILE_EMAIL_VERIFIED':
        return RegistrationCheckOutcome.verifiedGoToKyc;
      case 'KYC_IN_PROGRESS':
        return RegistrationCheckOutcome.kycInProgress;
    }
    return switch (e.statusCode) {
      403 => RegistrationCheckOutcome.mobileNotVerified,
      428 => RegistrationCheckOutcome.emailNotVerified,
      412 => RegistrationCheckOutcome.mobileEmailNotVerified,
      424 => RegistrationCheckOutcome.verifiedGoToKyc,
      423 => RegistrationCheckOutcome.kycInProgress,
      _ => null,
    };
  }

  /// The returned `registrationToken`, wherever the body nests it.
  static String? _registrationToken(ApiException e) {
    final body = e.data;
    final inner = body?['data'];
    final candidates = [
      if (inner is Map) inner['registrationToken'],
      body?['registrationToken'],
      if (inner is Map) inner['userId'],
    ];
    for (final c in candidates) {
      if (c is String && c.isNotEmpty) return c;
    }
    return null;
  }

  /// The backend has no dedicated status/field for this — it's carried
  /// entirely in the human-readable `message` (e.g. "User is already
  /// registered and verified. KYC completion is pending."), so that's
  /// what's matched on rather than the HTTP status code.
  static bool _isKycPending(String message) {
    final lower = message.toLowerCase();
    return lower.contains('kyc') && lower.contains('pending');
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
