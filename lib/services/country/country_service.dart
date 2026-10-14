import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/services/country/mock_country_service.dart';
import 'package:flutter_nivasshub/utils/flag_emoji.dart';

/// Dio-backed implementation of `GET /country-codes` (dbo.USP_Get_User_Country_List).
///
/// If network is offline, unreachable, or returns an error, gracefully falls back
/// to [MockCountryService.defaultCountries] so authentication is never blocked.
class CountryService extends ApiService implements CountryServiceBase {
  const CountryService(super.client);

  @override
  Future<ApiResponse<List<LocationNode>>> getCountries() async {
    try {
      final response = await client.get(ApiEndpoints.countryCodes);
      final nodes = _parse(response.data);
      debugPrint('[CountryService] parsed ${nodes.length} countries');
      if (nodes.isNotEmpty) {
        return ApiResponse.success(nodes);
      }
      debugPrint('[CountryService] 0 parsed countries, falling back to default list');
      return ApiResponse.success(MockCountryService.defaultCountries);
    } on ApiException catch (e) {
      debugPrint('[CountryService] getCountries ApiException: ${e.message}, falling back to default list');
      return ApiResponse.success(MockCountryService.defaultCountries);
    } catch (e) {
      debugPrint('[CountryService] getCountries error: $e, falling back to default list');
      return ApiResponse.success(MockCountryService.defaultCountries);
    }
  }

  static List<LocationNode> _parse(dynamic body) {
    try {
      final json = body is String ? jsonDecode(body) : body;

      dynamic list;
      if (json is List) {
        list = json;
      } else if (json is Map) {
        final map = Map<String, dynamic>.from(json);
        if (map['StatusCode'] == 404) return const [];
        list = map['ActiveCountries'] ??
            map['activeCountries'] ??
            map['data'] ??
            map['countries'];
        if (list is Map) {
          list = list['ActiveCountries'] ??
              list['activeCountries'] ??
              list['data'] ??
              list['countries'];
        }
      }

      if (list is! List || list.isEmpty) {
        debugPrint('[CountryService] no ActiveCountries list in response');
        return const [];
      }

      final nodes = list.whereType<Map>().map((raw) {
        final country = _CaseInsensitiveLookup(Map<String, dynamic>.from(raw));
        final iso = country.string([
          'country_short_code',
          'country_short_Code',
          'shortCode',
          'short_code',
          'iso',
          'code',
        ]) ?? '';

        var dialCode = country.string([
          'country_calling_code',
          'country_calling_Code',
          'callingCode',
          'calling_code',
          'dial_code',
          'dialCode',
        ]);
        if (dialCode != null && dialCode.isNotEmpty && !dialCode.startsWith('+')) {
          dialCode = '+$dialCode';
        }

        final name = country.string([
          'country_name',
          'countryName',
          'name',
        ]) ?? '';

        return LocationNode(
          flagEmoji: flagEmojiFromIso(iso),
          id: iso.isNotEmpty
              ? iso
              : (country.string(['country_code', 'countryCode', 'id']) ?? name),
          name: name,
          level: LocationLevel.country,
          dialCode: dialCode,
        );
      }).where((n) => n.id.isNotEmpty && n.name.isNotEmpty && (n.dialCode ?? '').isNotEmpty).toList(growable: false);

      return nodes;
    } catch (e) {
      debugPrint('[CountryService] error in _parse: $e');
      return const [];
    }
  }
}

/// Looks a value up by any of several candidate keys, each tried by exact
/// match first and then case-insensitively — converts any primitive to String.
class _CaseInsensitiveLookup {
  _CaseInsensitiveLookup(this._map);

  final Map<String, dynamic> _map;

  String? string(List<String> candidateKeys) {
    for (final key in candidateKeys) {
      if (_map.containsKey(key)) {
        final val = _map[key];
        return val == null ? null : '$val';
      }
    }
    final lowerCandidates = candidateKeys.map((k) => k.toLowerCase()).toSet();
    for (final entry in _map.entries) {
      if (lowerCandidates.contains(entry.key.toLowerCase())) {
        final val = entry.value;
        return val == null ? null : '$val';
      }
    }
    return null;
  }
}
