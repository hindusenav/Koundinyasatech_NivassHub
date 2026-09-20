import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/utils/json_asset_loader.dart';

/// Serves the cascade from a bundled JSON asset, filtering by `parentId`
/// exactly as `GET /locations?level=&parentId=` will.
///
/// The asset is parsed once and cached: walking the full cascade is seven
/// calls, and seven `rootBundle.loadString` + `jsonDecode` round trips
/// would make the deliberate 800 ms delay feel far worse than it is.
class MockLocationService implements LocationServiceBase {
  MockLocationService();

  static const String _assetPath = 'assets/json/location/location_tree.json';

  /// A society whose records "are still syncing" — selecting it makes the
  /// tower lookup fail, so the cascade's Error state is reachable without
  /// unplugging the network.
  static const String _failingParentId = 'SOC-ERROR';

  Map<String, dynamic>? _cache;

  @override
  Future<ApiResponse<List<LocationNode>>> getLocations({
    required LocationLevel level,
    String? parentId,
  }) async {
    await Future<void>.delayed(KycConfig.mockDelay);

    // Invalid Input: the contract says country takes no parent and every
    // other level requires one. A missing parent is a caller bug, not an
    // empty result, so it must not be reported as one.
    final isCountry = level == LocationLevel.country;
    if (isCountry != (parentId == null)) {
      return _failure(
        'Cannot load ${level.label.toLowerCase()} options for that selection.',
        ApiExceptionType.validation,
      );
    }

    if (parentId == _failingParentId) {
      return _failure(KycStrings.locationLoadFailed, ApiExceptionType.network);
    }

    try {
      final tree = await _tree();
      final raw = tree[level.jsonKey];
      if (raw is! List) return ApiResponse.success(const []);

      final nodes = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) => isCountry || e['parentId'] == parentId)
          .map((e) => LocationNode.fromJson(e, level))
          .toList(growable: false);

      // Empty is a success, not a failure — the picker shows its empty
      // state and the user backs up a level.
      return ApiResponse.success(nodes);
    } catch (e, stack) {
      // Unlike the real service, no `ApiService.handleRequest` wraps this,
      // so a malformed asset would otherwise vanish behind a friendly
      // message with no way to diagnose it.
      debugPrint(
        '[MockLocation] getLocations($level, $parentId) failed: $e\n$stack',
      );
      return _failure(KycStrings.locationLoadFailed, ApiExceptionType.unknown);
    }
  }

  @override
  Future<ApiResponse<List<String>>> getSubBranches() async {
    await Future<void>.delayed(KycConfig.mockDelay);
    try {
      final tree = await _tree();
      final raw = tree['subBranches'];
      if (raw is! List) return ApiResponse.success(const []);
      return ApiResponse.success(
        raw.whereType<String>().toList(growable: false),
      );
    } catch (e, stack) {
      debugPrint('[MockLocation] getSubBranches failed: $e\n$stack');
      return _failure(KycStrings.locationLoadFailed, ApiExceptionType.unknown);
    }
  }

  @override
  Future<ApiResponse<List<LocationNode>>> getCountryDialCodes() =>
      getLocations(level: LocationLevel.country);

  Future<Map<String, dynamic>> _tree() async {
    return _cache ??= await JsonAssetLoader.loadMap(_assetPath);
  }

  static ApiResponse<T> _failure<T>(String message, ApiExceptionType type) {
    return ApiResponse.failure(ApiException(message: message, type: type));
  }
}
