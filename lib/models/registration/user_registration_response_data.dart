/// Parsed response of `POST /country-codes/user-registration`.
///
/// Shape is doc-text-only (no live sample was seen, unlike the two GET
/// endpoints) — parsed defensively via a case-insensitive multi-key
/// lookup, same as `CountryService`, so a field-name mismatch degrades to
/// blank fields instead of a crash.
class UserRegistrationResponseData {
  const UserRegistrationResponseData({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.userId,
    required this.isNewUser,
    required this.email,
    required this.mobileNumber,
    required this.mobileCountryCode,
    required this.emailVerificationRequired,
    required this.mobileVerificationRequired,
  });

  final int statusCode;
  final bool success;
  final String message;
  final String userId;
  final bool isNewUser;
  final String email;
  final String mobileNumber;
  final String mobileCountryCode;
  final bool emailVerificationRequired;
  final bool mobileVerificationRequired;

  /// `200` (existing user) or `201` (newly registered) both count as a
  /// usable result — only `400`/`409`/`500` are failures.
  bool get isOk => statusCode == 200 || statusCode == 201;

  factory UserRegistrationResponseData.fromJson(Map<String, dynamic> json) {
    final lookup = _CaseInsensitiveLookup(json);
    final rawData = lookup.raw(['data']);
    final data = rawData is Map
        ? _CaseInsensitiveLookup(Map<String, dynamic>.from(rawData))
        : lookup;

    return UserRegistrationResponseData(
      statusCode: lookup.intValue(['statusCode']) ?? 0,
      success: lookup.boolValue(['success']) ?? false,
      message: lookup.string(['message']) ?? '',
      userId: data.string(['userId']) ?? '',
      isNewUser: data.boolValue(['isNewUser']) ?? false,
      email: data.string(['email']) ?? '',
      mobileNumber: data.string(['mobileNumber']) ?? '',
      mobileCountryCode: data.string(['mobileCountryCode']) ?? '',
      emailVerificationRequired:
          data.boolValue(['emailVerificationRequired']) ?? false,
      mobileVerificationRequired:
          data.boolValue(['mobileVerificationRequired']) ?? false,
    );
  }
}

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

  String? string(List<String> candidateKeys) => raw(candidateKeys)?.toString();

  bool? boolValue(List<String> candidateKeys) {
    final value = raw(candidateKeys);
    if (value is bool) return value;
    return null;
  }

  int? intValue(List<String> candidateKeys) {
    final value = raw(candidateKeys);
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
