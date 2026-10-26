import 'package:flutter_nivasshub/models/auth/user_role.dart';

/// One state/province nested inside a [RegistrationCountry].
class RegistrationState {
  const RegistrationState({required this.provinceId, required this.provinceName});

  final String provinceId;
  final String provinceName;

  factory RegistrationState.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    return RegistrationState(
      provinceId: lookup.string(['province_id', 'provinceId']) ?? '',
      provinceName: lookup.string(['province_name', 'provinceName']) ?? '',
    );
  }
}

/// One country row from `GET /country-codes/user-registration`, with its
/// states nested inside — unlike `GET /country-codes`, this response has
/// no `country_short_Code`; `countryCode` is the numeric `country_code`.
class RegistrationCountry {
  const RegistrationCountry({
    required this.countryCode,
    required this.callingCode,
    required this.name,
    required this.states,
  });

  final String countryCode;
  final String callingCode;
  final String name;
  final List<RegistrationState> states;

  factory RegistrationCountry.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    final rawStates = lookup.raw(['States', 'states']);
    return RegistrationCountry(
      countryCode: lookup.string(['country_code', 'countryCode']) ?? '',
      callingCode:
          lookup.string(['country_calling_code', 'countryCallingCode']) ?? '',
      name: lookup.string(['country_name', 'countryName']) ?? '',
      states: rawStates is List
          ? rawStates
                .whereType<Map>()
                .map((s) => RegistrationState.fromJson(Map<String, dynamic>.from(s)))
                .toList(growable: false)
          : const [],
    );
  }
}

/// One society row — supplies the manual "Society ID" picker with real
/// options instead of free-text entry.
class RegistrationSociety {
  const RegistrationSociety({
    required this.socId,
    required this.societyName,
    required this.city,
    required this.state,
    required this.country,
  });

  final String socId;
  final String societyName;
  final String city;
  final String state;
  final String country;

  factory RegistrationSociety.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);

    // `/society/add-master-data` doesn't use the registration endpoint's
    // key names, so after the known spellings, fall back to scanning for a
    // key that looks like the society id / name.
    String? scan(bool Function(String key) match) {
      for (final entry in json.entries) {
        final value = entry.value;
        if (value == null || value is Map || value is List) continue;
        if (match(entry.key.toLowerCase().replaceAll('_', ''))) {
          return value.toString();
        }
      }
      return null;
    }

    final socId =
        lookup.string([
          'soc_id',
          'socId',
          'socid',
          'society_id',
          'societyId',
          'id',
        ]) ??
        scan((k) => k.contains('soc') && k.endsWith('id')) ??
        '';
    final name =
        lookup.string([
          'Society_Name',
          'society_name',
          'societyName',
          'socName',
          'soc_name',
          'name',
        ]) ??
        scan((k) => k.contains('soc') && k.contains('name')) ??
        '';

    return RegistrationSociety(
      socId: socId,
      societyName: name,
      city: lookup.string(['city', 'cityName', 'city_name']) ?? '',
      state: lookup.string(['state', 'stateName', 'state_name']) ?? '',
      country: lookup.string(['country', 'countryName', 'country_name']) ?? '',
    );
  }

  /// `"Hyderabad, Telangana"` — shown as the picker row's subtitle.
  String get subtitle => [city, state].where((s) => s.isNotEmpty).join(', ');
}

List<T> _parseNested<T>(
  _CaseInsensitiveLookup lookup,
  List<String> keys,
  T Function(Map<String, dynamic>) fromJson,
) {
  final raw = lookup.raw(keys);
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList(growable: false);
}

/// One `Categories[]` entry under a [RegistrationSubRole] (owner sub-roles
/// only), sent as `sub_role_cat`.
class RegistrationCategory {
  const RegistrationCategory({
    required this.categoryId,
    required this.name,
    required this.description,
  });

  final String categoryId;
  final String name;
  final String description;

  factory RegistrationCategory.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    final name = lookup.string(['name', 'categoryName', 'category_name']) ?? '';
    return RegistrationCategory(
      categoryId:
          lookup.string(['category_id', 'categoryId', 'id']) ??
          lookup.scan((k) => k.endsWith('id')) ??
          '',
      name: name,
      description: lookup.string(['description']) ?? name,
    );
  }
}

/// One `Sub_Role[]` entry under a [RegistrationRole], sent as `sub_role`.
/// [categories] is empty for sub-roles that don't need `sub_role_cat`.
class RegistrationSubRole {
  const RegistrationSubRole({
    required this.subRoleId,
    required this.name,
    required this.description,
    required this.categories,
  });

  final String subRoleId;
  final String name;
  final String description;
  final List<RegistrationCategory> categories;

  factory RegistrationSubRole.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    final name = lookup.string(['name', 'subRoleName', 'sub_role_name']) ?? '';
    return RegistrationSubRole(
      subRoleId:
          lookup.string(['sub_role_id', 'subRoleId', 'id']) ??
          lookup.scan((k) => k.endsWith('id')) ??
          '',
      name: name,
      description: lookup.string(['description']) ?? name,
      categories: _parseNested(lookup, [
        'Categories',
        'categories',
      ], RegistrationCategory.fromJson),
    );
  }
}

/// One `Roles[]` entry — `6` is User (owner side), `7` is Tenant. Its
/// [subRoles] (and their categories) drive the Sub-role/Category pickers.
class RegistrationRole {
  const RegistrationRole({
    required this.roleId,
    required this.name,
    required this.description,
    this.subRoles = const [],
  });

  final String roleId;
  final String name;
  final String description;
  final List<RegistrationSubRole> subRoles;

  /// The KYC-facing role this API role maps to: `6` → owner, `7` → tenant
  /// (`KycDocumentCatalog.forRole` depends on it).
  UserRole? get userRole => switch (roleId) {
    '6' => UserRole.owner,
    '7' => UserRole.tenant,
    _ => null,
  };

  factory RegistrationRole.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    final name = lookup.string(['name', 'roleName', 'role_name']) ?? '';
    // Sub-roles: known spellings first, else the first list-of-maps field.
    var subRoles = _parseNested(lookup, [
      'Sub_Role',
      'Sub_Roles',
      'subRoles',
      'subRole',
      'sub_roles',
      'sub_role',
    ], RegistrationSubRole.fromJson);
    if (subRoles.isEmpty) {
      for (final value in json.values) {
        if (value is List && value.isNotEmpty && value.first is Map) {
          subRoles = value
              .whereType<Map>()
              .map(
                (e) => RegistrationSubRole.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(growable: false);
          break;
        }
      }
    }
    return RegistrationRole(
      roleId:
          lookup.string(['role_id', 'roleId', 'id']) ??
          lookup.scan((k) => k.contains('role') && k.endsWith('id')) ??
          lookup.scan((k) => k.endsWith('id')) ??
          '',
      name: name,
      description: lookup.string(['description']) ?? name,
      subRoles: subRoles,
    );
  }
}

/// One `kycDocuments[]` entry from `GET /society/add-master-data`; [id] is
/// sent as `documentid` on `POST /society/add-user`. Keys are matched
/// loosely since the field names aren't documented.
class RegistrationKycDocument {
  const RegistrationKycDocument({required this.id, required this.name});

  final String id;
  final String name;

  factory RegistrationKycDocument.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    return RegistrationKycDocument(
      id:
          lookup.string([
            'documentId',
            'document_id',
            'documentNameId',
            'document_name_id',
            'docId',
            'doc_id',
            'id',
          ]) ??
          '',
      name:
          lookup.string([
            'documentName',
            'document_name',
            'name',
            'description',
          ]) ??
          '',
    );
  }
}

/// Parsed body of `GET /country-codes/user-registration` — countries
/// (with nested states), societies, and roles in one response.
class RegistrationMasterData {
  const RegistrationMasterData({
    required this.countries,
    required this.societies,
    required this.roles,
    this.kycDocuments = const [],
  });

  final List<RegistrationCountry> countries;
  final List<RegistrationSociety> societies;
  final List<RegistrationRole> roles;

  /// Only present on the add-society master data.
  final List<RegistrationKycDocument> kycDocuments;

  static const empty = RegistrationMasterData(
    countries: [],
    societies: [],
    roles: [],
  );

  factory RegistrationMasterData.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);

    List<T> parseList<T>(
      List<String> keys,
      T Function(Map<String, dynamic>) fromJson,
    ) {
      final raw = lookup.raw(keys);
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false);
    }

    return RegistrationMasterData(
      countries: parseList([
        'ActiveCountries',
        'countries',
      ], RegistrationCountry.fromJson),
      societies: parseList(['Societies'], RegistrationSociety.fromJson),
      roles: parseList(['Roles'], RegistrationRole.fromJson),
      kycDocuments: parseList([
        'kycDocuments',
        'KycDocuments',
      ], RegistrationKycDocument.fromJson),
    );
  }
}

/// Looks a value up by any of several candidate keys, tried by exact match
/// first and then case-insensitively — mirrors `CountryService`'s
/// `_CaseInsensitiveLookup`, duplicated here since that one is private to
/// its file and this endpoint's field names have already been seen to
/// drift from the documented contract once.
class _CaseInsensitiveLookup {
  _CaseInsensitiveLookup(this._map);

  final Map<String, dynamic> _map;

  dynamic raw(List<String> candidateKeys) {
    for (final key in candidateKeys) {
      if (_map.containsKey(key)) return _map[key];
    }
    final lowerCandidates = candidateKeys.map((k) => k.toLowerCase()).toSet();
    for (final entry in _map.entries) {
      if (lowerCandidates.contains(entry.key.toLowerCase())) return entry.value;
    }
    return null;
  }

  /// First scalar value whose key (lower-cased, underscores removed) passes
  /// [match] — a last resort for keys that aren't documented.
  String? scan(bool Function(String key) match) {
    for (final entry in _map.entries) {
      final value = entry.value;
      if (value == null || value is Map || value is List) continue;
      if (match(entry.key.toLowerCase().replaceAll('_', ''))) {
        return value.toString();
      }
    }
    return null;
  }

  String? string(List<String> candidateKeys) {
    final value = raw(candidateKeys);
    if (value == null) return null;
    return value.toString();
  }
}
