import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

/// In-memory stand-in for [CountryService], used by widget tests so they
/// don't need a live `GET /country-codes` call. Not wired up in
/// `main.dart` — that endpoint is fully documented and always real.
class MockCountryService implements CountryServiceBase {
  const MockCountryService();

  static const defaultCountry = LocationNode(
    id: 'IN',
    name: 'India',
    level: LocationLevel.country,
    dialCode: '+91',
    flagEmoji: '🇮🇳',
  );

  static const defaultCountries = [
    defaultCountry,
    LocationNode(
      id: 'US',
      name: 'United States',
      level: LocationLevel.country,
      dialCode: '+1',
      flagEmoji: '🇺🇸',
    ),
    LocationNode(
      id: 'GB',
      name: 'United Kingdom',
      level: LocationLevel.country,
      dialCode: '+44',
      flagEmoji: '🇬🇧',
    ),
    LocationNode(
      id: 'AE',
      name: 'United Arab Emirates',
      level: LocationLevel.country,
      dialCode: '+971',
      flagEmoji: '🇦🇪',
    ),
    LocationNode(
      id: 'SG',
      name: 'Singapore',
      level: LocationLevel.country,
      dialCode: '+65',
      flagEmoji: '🇸🇬',
    ),
    LocationNode(
      id: 'CA',
      name: 'Canada',
      level: LocationLevel.country,
      dialCode: '+1',
      flagEmoji: '🇨🇦',
    ),
    LocationNode(
      id: 'AU',
      name: 'Australia',
      level: LocationLevel.country,
      dialCode: '+61',
      flagEmoji: '🇦🇺',
    ),
    LocationNode(
      id: 'SA',
      name: 'Saudi Arabia',
      level: LocationLevel.country,
      dialCode: '+966',
      flagEmoji: '🇸🇦',
    ),
    LocationNode(
      id: 'QA',
      name: 'Qatar',
      level: LocationLevel.country,
      dialCode: '+974',
      flagEmoji: '🇶🇦',
    ),
    LocationNode(
      id: 'KW',
      name: 'Kuwait',
      level: LocationLevel.country,
      dialCode: '+965',
      flagEmoji: '🇰🇼',
    ),
    LocationNode(
      id: 'OM',
      name: 'Oman',
      level: LocationLevel.country,
      dialCode: '+968',
      flagEmoji: '🇴🇲',
    ),
    LocationNode(
      id: 'BH',
      name: 'Bahrain',
      level: LocationLevel.country,
      dialCode: '+973',
      flagEmoji: '🇧🇭',
    ),
    LocationNode(
      id: 'MY',
      name: 'Malaysia',
      level: LocationLevel.country,
      dialCode: '+60',
      flagEmoji: '🇲🇾',
    ),
    LocationNode(
      id: 'DE',
      name: 'Germany',
      level: LocationLevel.country,
      dialCode: '+49',
      flagEmoji: '🇩🇪',
    ),
    LocationNode(
      id: 'FR',
      name: 'France',
      level: LocationLevel.country,
      dialCode: '+33',
      flagEmoji: '🇫🇷',
    ),
    LocationNode(
      id: 'NZ',
      name: 'New Zealand',
      level: LocationLevel.country,
      dialCode: '+64',
      flagEmoji: '🇳🇿',
    ),
  ];

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    return ApiResponse.success(defaultCountries);
  }
}
