import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';

/// Dio-backed cascade. Not wired up while `KycConfig.useMockKycApi` is
/// true — see `MockLocationService`.
class LocationService extends ApiService implements LocationServiceBase {
  const LocationService(super.client);

  @override
  Future<ApiResponse<List<LocationNode>>> getLocations({
    required LocationLevel level,
    String? parentId,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.locations,
        queryParameters: {'level': level.wireValue, 'parentId': ?parentId},
      ),
      (json) => _nodesFrom(json, level),
    );
  }

  @override
  Future<ApiResponse<List<String>>> getSubBranches() {
    return handleRequest(
      () => client.get('${ApiEndpoints.locations}/sub-branches'),
      (json) => _listFrom(json).whereType<String>().toList(growable: false),
    );
  }

  @override
  Future<ApiResponse<List<LocationNode>>> getCountryDialCodes() =>
      getLocations(level: LocationLevel.country);

  static List<LocationNode> _nodesFrom(dynamic json, LocationLevel level) {
    return _listFrom(json)
        .whereType<Map>()
        .map((e) => LocationNode.fromJson(Map<String, dynamic>.from(e), level))
        .toList(growable: false);
  }

  /// Accepts either a bare array or the `{success, data: [...]}` envelope
  /// the other endpoints use, so a contract revision either way is a
  /// no-op here.
  static List<dynamic> _listFrom(dynamic json) {
    if (json is List) return json;
    if (json is Map<String, dynamic>) {
      final data = json['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        return data['items'] as List;
      }
    }
    return const [];
  }
}
