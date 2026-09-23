import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/access_token_response_data.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/create_user_response_data.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/models/auth/login_user_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';

/// One seeded account in the mock user table.
class _MockUser {
  const _MockUser({
    required this.id,
    required this.name,
    required this.password,
    required this.role,
    required this.identifiers,
  });

  final String id;
  final String name;
  final String password;
  final String role;

  /// Every identifier that resolves to this account — a mobile in both
  /// national and `+91`-prefixed form, plus an email.
  final List<String> identifiers;
}

/// In-memory stand-in for the authentication backend.
///
/// Test credentials (spec §22) live here and nowhere else, so swapping in
/// [AuthEntryService] removes them from the build entirely:
///
/// - `9876543210` / password `1234` — existing user, logs straight in.
/// - `9876543211` — unknown, routes to registration + KYC.
/// - any other identifier — treated as new.
class MockAuthEntryService implements AuthEntryServiceBase {
  MockAuthEntryService();

  static const List<_MockUser> _users = [
    _MockUser(
      id: 'USR001',
      name: 'Test User',
      password: '1234',
      role: 'Owner',
      identifiers: ['9876543210', '+919876543210', 'user@gmail.com'],
    ),
  ];

  /// Accounts registered during this run, so a brand-new user who finishes
  /// registration is recognised if they come back to the entry screen.
  final Set<String> _registeredIdentifiers = <String>{};

  int _userSequence = 1000;

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) async {
    await Future<void>.delayed(KycConfig.mockDelay);

    final identifier = request.identifier;
    final normalized = identifier.normalized;

    if (normalized.isEmpty) {
      return _invalid(KycStrings.identifierRequired);
    }

    final match = _findUser(identifier);
    final exists = match != null || _registeredIdentifiers.contains(normalized);

    return ApiResponse.success(
      CheckUserExistsResponseData(
        userExists: exists,
        identifier: normalized,
        maskedIdentifier: identifier.masked,
        registeredChannel: exists ? identifier.channel : null,
      ),
    );
  }

  @override
  Future<ApiResponse<LoginUserResponseData>> loginUser(
    LoginUserRequest request,
  ) async {
    await Future<void>.delayed(KycConfig.mockDelay);

    final user = _findUser(request.identifier);
    if (user == null) {
      // Reached only if the account vanished between the two calls;
      // surfaced as the same inline message so no enumeration oracle is
      // handed to a caller poking at the endpoint.
      return ApiResponse.failure(
        const ApiException(
          message: KycStrings.invalidPassword,
          type: ApiExceptionType.unauthorized,
        ),
      );
    }

    if (request.password != user.password) {
      return ApiResponse.failure(
        const ApiException(
          message: KycStrings.invalidPassword,
          type: ApiExceptionType.unauthorized,
        ),
      );
    }

    return ApiResponse.success(
      LoginUserResponseData(
        authenticated: true,
        userId: user.id,
        fullName: user.name,
        accessToken: 'mock_access_token_12345',
        refreshToken: 'mock_refresh_token_12345',
        role: user.role,
        kycApproved: true,
      ),
    );
  }

  @override
  Future<ApiResponse<CreateUserResponseData>> createUser(
    CreateUserRequest request,
  ) async {
    await Future<void>.delayed(KycConfig.mockDelay);

    if (request.fullName.trim().isEmpty) {
      return _invalid('Please enter your full name.');
    }
    if (!request.location.isComplete) {
      return _invalid('Please complete every property field.');
    }

    _userSequence++;
    final userId = 'USR$_userSequence';

    _registeredIdentifiers
      ..add(request.email.trim().toLowerCase())
      ..add('${request.countryCode}${request.mobileNumber}')
      ..add(request.mobileNumber);

    debugPrint('[MockAuth] createUser -> $userId (${request.role.label})');

    return ApiResponse.success(
      CreateUserResponseData.fromJson({
        'userId': userId,
        'kycRequired': true,
        'kycToken': 'mock_kyc_token_$_userSequence',
      }),
    );
  }

  @override
  Future<ApiResponse<AccessTokenResponseData>> generateAccessToken({
    required String userId,
    required String kycId,
  }) async {
    await Future<void>.delayed(KycConfig.mockDelay);

    if (userId.isEmpty || kycId.isEmpty) {
      return _invalid(KycStrings.genericError);
    }

    debugPrint('[MockAuth] access token minted for $userId against $kycId');

    return ApiResponse.success(
      AccessTokenResponseData.fromJson({
        'status': 'APPROVED',
        'token': 'mock_access_token_${kycId.toLowerCase()}',
        'refreshToken': 'mock_refresh_token_${kycId.toLowerCase()}',
        'userAccess': true,
      }),
    );
  }

  /// Matches on the normalized identifier and, for mobiles, also on the
  /// bare national digits — so `9876543210` and `+919876543210` are the
  /// same account whichever country code the user happened to pick.
  _MockUser? _findUser(AuthIdentifier identifier) {
    final candidates = <String>{
      identifier.normalized,
      if (identifier.channel == AuthChannel.mobile) identifier.nationalNumber,
    };

    for (final user in _users) {
      if (user.identifiers.any(candidates.contains)) return user;
    }
    return null;
  }

  static ApiResponse<T> _invalid<T>(String message) {
    return ApiResponse.failure(
      ApiException(message: message, type: ApiExceptionType.validation),
    );
  }
}
