import 'dart:async';

import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_response_data.dart';
import 'package:flutter_nivasshub/models/society/society_details_response.dart';
import 'package:flutter_nivasshub/providers/auth/user_details_provider.dart';
import 'package:flutter_nivasshub/providers/society/society_details_provider.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_society_service.dart';

class _CountingSocietyService implements SocietyServiceBase {
  int calls = 0;

  @override
  Future<ApiResponse<SocietyDetailsResponseData>> getSocietyDetails(
    String socId,
  ) {
    calls++;
    return const FakeSocietyService().getSocietyDetails(socId);
  }
}

class _SlowRegistrationService implements RegistrationServiceBase {
  int submits = 0;
  final gate = Completer<void>();

  @override
  Future<ApiResponse<RegistrationMasterData>> getMasterData() =>
      throw UnimplementedError();

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() =>
      throw UnimplementedError();

  @override
  Future<ApiResponse<UserRegistrationResponseData>> submitRegistration(
    UserRegistrationRequest request,
  ) async {
    submits++;
    await gate.future;
    return ApiResponse.success(
      const UserRegistrationResponseData(
        statusCode: 201,
        success: true,
        message: 'ok',
        userId: 'REG',
        isNewUser: true,
        email: '',
        mobileNumber: '',
        mobileCountryCode: '',
        emailVerificationRequired: true,
        mobileVerificationRequired: true,
      ),
    );
  }
}

void main() {
  test('society details are fetched once per socid', () async {
    final service = _CountingSocietyService();
    final provider = SocietyDetailsProvider(service);

    await provider.fetchSociety('33');
    await provider.fetchSociety('33');
    expect(service.calls, 1);
    expect(provider.towers, isNotEmpty);

    await provider.fetchSociety('44');
    expect(service.calls, 2);

    await provider.retry(); // explicit retry bypasses the cache
    expect(service.calls, 3);
  });

  test('registration is submitted once even if triggered twice', () async {
    final service = _SlowRegistrationService();
    final provider = UserDetailsProvider(registrationService: service)
      ..setRole(UserRole.owner);

    Future<UserRegistrationResponseData?> submit() => provider.submit(
      fullName: 'A',
      mobileNumber: '9999999999',
      mobileCountryCode: '+91',
      email: 'a@b.co',
      country: 'IN',
      state: '1',
      city: 'X',
      socId: '33',
      towerId: '1',
      floorId: '1',
      unitId: '1',
      roleId: '6',
      subRole: '1',
      unitBranch: null,
    );

    final first = submit();
    final second = await submit();
    service.gate.complete();
    await first;

    expect(second, isNull);
    expect(service.submits, 1);
  });
}
