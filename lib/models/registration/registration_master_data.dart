/// One state/province nested inside a [RegistrationCountry].
class RegistrationState {
  const RegistrationState({required this.provinceId, required this.provinceName});

  final String provinceId;
  final String provinceName;

  factory RegistrationState.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    return RegistrationState(
      provinceId: lookup.string(['province_id']) ?? '',
      provinceName: lookup.string(['province_name']) ?? '',
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
      countryCode: lookup.string(['country_code']) ?? '',
      callingCode: lookup.string(['country_calling_code']) ?? '',
      name: lookup.string(['country_name']) ?? '',
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
    return RegistrationSociety(
      socId: lookup.string(['soc_id']) ?? '',
      societyName: lookup.string(['Society_Name', 'society_name']) ?? '',
      city: lookup.string(['city']) ?? '',
      state: lookup.string(['state']) ?? '',
      country: lookup.string(['country']) ?? '',
    );
  }

  /// `"Hyderabad, Telangana"` — shown as the picker row's subtitle.
  String get subtitle => [city, state].where((s) => s.isNotEmpty).join(', ');
}

/// Parsed and kept for completeness. **Not surfaced in the UI** — the
/// registration screen keeps its existing Owner/Tenant picker, whose wire
/// value the KYC document catalog (`KycDocumentCatalog.forRole`) depends
/// on; this endpoint's `Resident`/`Tenant` labels don't map onto that
/// cleanly, so nothing currently reads this list.
class RegistrationRole {
  const RegistrationRole({
    required this.roleId,
    required this.name,
    required this.description,
  });

  final String roleId;
  final String name;
  final String description;

  factory RegistrationRole.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    return RegistrationRole(
      roleId: lookup.string(['role_id']) ?? '',
      name: lookup.string(['name']) ?? '',
      description: lookup.string(['description']) ?? '',
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
  });

  final List<RegistrationCountry> countries;
  final List<RegistrationSociety> societies;
  final List<RegistrationRole> roles;

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
      countries: parseList(['ActiveCountries'], RegistrationCountry.fromJson),
      societies: parseList(['Societies'], RegistrationSociety.fromJson),
      roles: parseList(['Roles'], RegistrationRole.fromJson),
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

  String? string(List<String> candidateKeys) {
    final value = raw(candidateKeys);
    if (value == null) return null;
    return value.toString();
  }
}
