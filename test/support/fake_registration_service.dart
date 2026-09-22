import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_response_data.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';

/// In-memory stand-in for [RegistrationService], used by widget tests so
/// they don't need a live `GET`/`POST /country-codes/user-registration`
/// call. Mirrors the shape of a real response (nested states, one
/// society) so the Country → State → Society cascade has something to
/// show.
class FakeRegistrationService implements RegistrationServiceBase {
  const FakeRegistrationService();

  static const _data = RegistrationMasterData(
    countries: [
      RegistrationCountry(
        countryCode: '77',
        callingCode: '+91',
        name: 'India',
        states: [
          RegistrationState(provinceId: '4328', provinceName: 'Chhattisgarh'),
        ],
      ),
    ],
    societies: [
      RegistrationSociety(
        socId: '33',
        societyName: 'Green Valley Residency',
        city: 'Hyderabad',
        state: 'Telangana',
        country: 'India',
      ),
    ],
    roles: [
      RegistrationRole(roleId: '6', name: 'R', description: 'Resident'),
      RegistrationRole(roleId: '7', name: 'T', description: 'Tenant'),
    ],
  );

  @override
  Future<ApiResponse<RegistrationMasterData>> getMasterData() async {
    return ApiResponse.success(_data);
  }

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    final nodes = _data.countries
        .map(
          (c) => LocationNode(
            id: c.countryCode,
            name: c.name,
            level: LocationLevel.country,
            dialCode: c.callingCode,
          ),
        )
        .toList(growable: false);
    return ApiResponse.success(nodes);
  }

  @override
  Future<ApiResponse<UserRegistrationResponseData>> submitRegistration(
    UserRegistrationRequest request,
  ) async {
    return ApiResponse.success(
      const UserRegistrationResponseData(
        statusCode: 201,
        success: true,
        message: 'Registration successful',
        userId: 'USR1001',
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
