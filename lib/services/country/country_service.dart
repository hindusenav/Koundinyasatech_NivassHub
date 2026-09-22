import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

/// Dio-backed implementation of `GET /country-codes` — fully documented,
/// so unlike the rest of the auth-entry/KYC stack this has no mock twin
/// and no `useMockApi`/`useMockKycApi` gate; it is always real.
class CountryService extends ApiService implements CountryServiceBase {
  const CountryService(super.client);

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    try {
      final response = await client.get(ApiEndpoints.countryCodes);
      final nodes = _parse(response.data);
      debugPrint('[CountryService] parsed ${nodes.length} countries');
      return ApiResponse.success(nodes);
    } on ApiException catch (e) {
      // The documented "no active countries" case may arrive as a real
      // HTTP 404 rather than a 200 with `StatusCode: 404` in the body
      // (the doc notes this depends on how the backend maps it) — either
      // way it's a valid empty state, not a failure.
      if (e.type == ApiExceptionType.notFound) {
        return ApiResponse.success(const <LocationNode>[]);
      }
      debugPrint('[CountryService] getCountries failed: ${e.message}');
      return ApiResponse.failure(e);
    }
  }

  static List<LocationNode> _parse(dynamic body) {
    // Normally Dio (with `ResponseType.json`) hands back an already
    // decoded Map. Some backend/proxy configurations still send the body
    // as a JSON-encoded string with a non-JSON content-type, which Dio
    // then leaves undecoded — decode it ourselves rather than silently
    // returning an empty list in that case.
    final json = body is String ? jsonDecode(body) : body;

    if (json is! Map) {
      debugPrint('[CountryService] unexpected response shape: ${json.runtimeType}');
      return const [];
    }
    final map = Map<String, dynamic>.from(json);
    if (map['StatusCode'] == 404) return const [];

    final countries = map['ActiveCountries'];
    if (countries is! List) {
      debugPrint('[CountryService] no ActiveCountries list in response: ${map.keys}');
      return const [];
    }
    if (countries.isEmpty) return const [];

    // Field names are matched case-insensitively as a defensive fallback
    // — the documented contract is `country_name`/`country_short_Code`/
    // `country_calling_Code`, but a backend under active development can
    // drift from its own docs without the frontend being told.
    final sample = countries.first;
    if (sample is Map && kDebugMode) {
      debugPrint('[CountryService] sample country keys: ${sample.keys.toList()}');
    }

    final nodes = countries.whereType<Map>().map((raw) {
      final country = _CaseInsensitiveLookup(Map<String, dynamic>.from(raw));
      return LocationNode(
        // The documented contract's snake_case keys
        // (`country_short_Code`/`country_name`/`country_calling_Code`)
        // and the live backend's actual camelCase keys
        // (`shortCode`/`countryName`/`callingCode`, confirmed against a
        // real device log) both work here — whichever the response uses.
        id: country.string(['country_short_Code', 'shortCode']) ?? '',
        name: country.string(['country_name', 'countryName']) ?? '',
        level: LocationLevel.country,
        dialCode: country.string(['country_calling_Code', 'callingCode']),
      );
    }).where((n) => n.id.isNotEmpty && n.name.isNotEmpty).toList(growable: false);

    if (nodes.isEmpty) {
      debugPrint(
        '[CountryService] ${countries.length} raw entries but 0 parsed — '
        'unrecognized field names. First raw entry: ${countries.first}',
      );
    }

    return nodes;
  }
}

/// Looks a value up by any of several candidate keys, each tried by exact
/// match first and then case-insensitively — so a response using
/// `shortCode` instead of the documented `country_short_Code` (or any
/// other casing variant) still gets read instead of silently dropping
/// every row.
class _CaseInsensitiveLookup {
  _CaseInsensitiveLookup(this._map);

  final Map<String, dynamic> _map;

  String? string(List<String> candidateKeys) {
    for (final key in candidateKeys) {
      if (_map.containsKey(key)) return _map[key] as String?;
    }
    final lowerCandidates = candidateKeys.map((k) => k.toLowerCase()).toSet();
    for (final entry in _map.entries) {
      if (lowerCandidates.contains(entry.key.toLowerCase())) {
        return entry.value as String?;
      }
    }
    return null;
  }
}
