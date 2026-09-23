import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

/// In-memory stand-in for [CountryService], used by widget tests so they
/// don't need a live `GET /country-codes` call. Not wired up in
/// `main.dart` — that endpoint is fully documented and always real.
class MockCountryService implements CountryServiceBase {
  const MockCountryService();

  static const _countries = [
    LocationNode(
      id: 'IN',
      name: 'India',
      level: LocationLevel.country,
      dialCode: '+91',
    ),
    LocationNode(
      id: 'US',
      name: 'United States',
      level: LocationLevel.country,
      dialCode: '+1',
    ),
  ];

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    return ApiResponse.success(_countries);
  }
}
