import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';

/// Master data behind the Country → State → City → Society → Tower →
/// Floor → Flat cascade.
abstract class LocationServiceBase {
  /// One call serves every level — `getLocations(level: city, parentId:
  /// 'IN-KA')`.
  ///
  /// Deliberately not seven `getStates`/`getCities`/… methods: the
  /// provider walks the cascade by `LocationLevel.index`, so seven methods
  /// would force a seven-way switch at the one place the generic
  /// downstream reset lives, and defeat it.
  ///
  /// [parentId] must be `null` for [LocationLevel.country] and non-null
  /// for every other level; violating that is a validation failure, not an
  /// empty result.
  Future<ApiResponse<List<LocationNode>>> getLocations({
    required LocationLevel level,
    String? parentId,
  });

  /// Sub-branch options for the registration form. Flat rather than
  /// cascading — it qualifies the resident, not the property.
  Future<ApiResponse<List<String>>> getSubBranches();

  /// Dial codes for the authentication entry screen's country picker.
  /// Served from the same country records as the cascade so the two can
  /// never disagree about which countries exist.
  Future<ApiResponse<List<LocationNode>>> getCountryDialCodes();
}
