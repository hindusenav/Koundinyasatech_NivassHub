/// Which kind of credential the user typed on the authentication entry
/// screen. The whole entry flow branches on this rather than re-sniffing
/// the string at each layer.
enum AuthChannel {
  mobile,
  email;

  /// Wire value sent to (and parsed from) the API.
  String get wireValue => name;

  static AuthChannel fromJson(dynamic value) {
    return AuthChannel.values.firstWhere(
      (c) => c.wireValue == value,
      orElse: () => AuthChannel.mobile,
    );
  }
}

/// A mobile number or email address plus the country code it was entered
/// with, normalized once so every downstream layer compares and sends the
/// same string.
///
/// Deliberately not a JSON model: it is assembled from UI state and then
/// *spread* across request bodies, which each name its fields differently.
class AuthIdentifier {
  const AuthIdentifier({
    required this.raw,
    required this.channel,
    this.countryCode,
  });

  /// Exactly as the user typed it — kept so a screen can echo it back.
  final String raw;

  final AuthChannel channel;

  /// Dial code such as `+91`. Always present for [AuthChannel.mobile];
  /// `null` for email, which has no country.
  final String? countryCode;

  /// The canonical form: `+919876543210` for a mobile, a trimmed
  /// lower-cased address for an email. This is what is sent and what is
  /// compared against stored users.
  String get normalized {
    if (channel == AuthChannel.email) return raw.trim().toLowerCase();
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return '${countryCode ?? ''}$digits';
  }

  /// Digits only, no dial code — what `FormValidators.mobileNumber` and
  /// the mock user table match on.
  String get nationalNumber => raw.replaceAll(RegExp(r'\D'), '');

  /// Display form for the "we sent this to…" line on the password screen:
  /// `98*****210` or `us••••@gmail.com`.
  String get masked {
    if (channel == AuthChannel.email) {
      final at = raw.indexOf('@');
      if (at <= 2) return raw;
      return '${raw.substring(0, 2)}${'•' * (at - 2)}${raw.substring(at)}';
    }
    final digits = nationalNumber;
    if (digits.length <= 4) return digits;
    return '${digits.substring(0, 2)}${'*' * (digits.length - 5)}'
        '${digits.substring(digits.length - 3)}';
  }

  AuthIdentifier copyWith({
    String? raw,
    AuthChannel? channel,
    String? countryCode,
  }) {
    return AuthIdentifier(
      raw: raw ?? this.raw,
      channel: channel ?? this.channel,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  Map<String, dynamic> toJson() => {
    'raw': raw,
    'channel': channel.wireValue,
    'countryCode': countryCode,
  };

  factory AuthIdentifier.fromJson(Map<String, dynamic> json) {
    return AuthIdentifier(
      raw: json['raw'] as String? ?? '',
      channel: AuthChannel.fromJson(json['channel']),
      countryCode: json['countryCode'] as String?,
    );
  }

  @override
  String toString() => normalized;
}
