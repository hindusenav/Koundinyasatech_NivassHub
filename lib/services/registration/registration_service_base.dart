import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_response_data.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

/// `GET`/`POST /country-codes/user-registration` — registration master
/// data (countries with nested states, societies, roles) and the
/// registration submit itself.
///
/// Extends [CountryServiceBase] so a `RegistrationServiceBase` can be
/// handed anywhere a `CountryServiceBase` is expected (e.g.
/// `LocationProvider`'s Country picker) without a second provider
/// registration.
abstract class RegistrationServiceBase implements CountryServiceBase {
  Future<ApiResponse<RegistrationMasterData>> getMasterData();

  Future<ApiResponse<UserRegistrationResponseData>> submitRegistration(
    UserRegistrationRequest request,
  );
}
