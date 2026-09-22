import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';

/// The active-country list behind every country/dial-code picker in the
/// app (`GET /country-codes`).
///
/// Deliberately separate from `LocationServiceBase`: that interface's
/// `getLocations`/`getCountryDialCodes` are shaped around the *mocked*
/// generic `{id, name, parentId, ...}` cascade, while this endpoint's
/// real, documented response (`{StatusCode, StatusMessage,
/// TotalCountries, ActiveCountries: [{country_name, country_short_Code,
/// country_calling_Code}]}`) is nothing like it.
abstract class CountryServiceBase {
  Future<ApiResponse<List<LocationNode>>> getCountries();
}
