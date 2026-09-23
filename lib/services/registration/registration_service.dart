import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_response_data.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';

/// Dio-backed implementation of `GET`/`POST
/// /country-codes/user-registration`, both confirmed real and documented.
///
/// Also implements [CountryServiceBase] so `LocationProvider`'s Country
/// picker can be handed this service directly, sourcing from the
/// registration master data instead of the dial-code-only `/country-codes`.
class RegistrationService extends ApiService implements RegistrationServiceBase {
  const RegistrationService(super.client);

  @override
  Future<ApiResponse<RegistrationMasterData>> getMasterData() async {
    try {
      final response = await client.get(ApiEndpoints.userRegistration);
      final data = _parseMasterData(response.data);
      debugPrint(
        '[RegistrationService] parsed ${data.countries.length} countries, '
        '${data.societies.length} societies, ${data.roles.length} roles',
      );
      return ApiResponse.success(data);
    } on ApiException catch (e) {
      if (e.type == ApiExceptionType.notFound) {
        return ApiResponse.success(RegistrationMasterData.empty);
      }
      debugPrint('[RegistrationService] getMasterData failed: ${e.message}');
      return ApiResponse.failure(e);
    }
  }

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    final response = await getMasterData();
    if (!response.isSuccess || response.data == null) {
      return ApiResponse.failure(
        response.error ??
            const ApiException(
              message: 'Could not load countries.',
              type: ApiExceptionType.unknown,
            ),
      );
    }

    final nodes = response.data!.countries
        .map(
          (c) => LocationNode(
            id: c.countryCode,
            name: c.name,
            level: LocationLevel.country,
            dialCode: c.callingCode,
          ),
        )
        .where((n) => n.id.isNotEmpty && n.name.isNotEmpty)
        .toList(growable: false);

    return ApiResponse.success(nodes);
  }

  @override
  Future<ApiResponse<UserRegistrationResponseData>> submitRegistration(
    UserRegistrationRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.userRegistration, data: request.toJson()),
      (json) => UserRegistrationResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  static RegistrationMasterData _parseMasterData(dynamic body) {
    // Some backend/proxy configurations send an already JSON-encoded
    // string body with a non-JSON content-type, which Dio then leaves
    // undecoded — decode it ourselves rather than crashing on cast.
    final json = body is String ? jsonDecode(body) : body;

    if (json is! Map) {
      debugPrint(
        '[RegistrationService] unexpected response shape: ${json.runtimeType}',
      );
      return RegistrationMasterData.empty;
    }

    return RegistrationMasterData.fromJson(Map<String, dynamic>.from(json));
  }
}
