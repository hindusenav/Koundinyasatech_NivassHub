import 'package:flutter_nivasshub/models/location/location_level.dart';

/// One option at any level of the property cascade — a country, a state, a
/// tower, a flat.
///
/// Deliberately a single class for all seven levels rather than seven
/// near-identical models: the parse code is then written once, and the
/// provider and the picker widget stay level-agnostic, which is what makes
/// the generic cascade and its generic downstream reset possible.
class LocationNode {
  const LocationNode({
    required this.id,
    required this.name,
    required this.level,
    this.parentId,
    this.dialCode,
    this.flagEmoji,
    this.registrationNumber,
  });

  final String id;
  final String name;
  final LocationLevel level;

  /// `null` only for [LocationLevel.country], which has no parent.
  final String? parentId;

  /// Country only — e.g. `+91`. Feeds the auth-entry country-code picker.
  final String? dialCode;

  /// Country only — e.g. `🇮🇳`.
  final String? flagEmoji;

  /// Society only — shown as the subtitle so two similarly named societies
  /// can be told apart.
  final String? registrationNumber;

  /// Response-only: nothing in the app ever POSTs a full node, only its id
  /// (see `LocationSelection.toJson`).
  factory LocationNode.fromJson(
    Map<String, dynamic> json,
    LocationLevel level,
  ) {
    return LocationNode(
      id: json['id'] as String,
      name: json['name'] as String,
      level: level,
      parentId: json['parentId'] as String?,
      dialCode: json['dialCode'] as String?,
      flagEmoji: json['flagEmoji'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
    );
  }

  /// Persisted inside `AuthFlowContext` so a resumed registration can show
  /// the chosen flat without re-walking the cascade.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level.wireValue,
    'parentId': parentId,
    'dialCode': dialCode,
    'flagEmoji': flagEmoji,
    'registrationNumber': registrationNumber,
  };

  factory LocationNode.fromStoredJson(Map<String, dynamic> json) =>
      LocationNode.fromJson(json, LocationLevel.fromJson(json['level']));

  /// What the picker shows on the left of the row.
  String? get leadingText => flagEmoji;

  /// What the picker shows under the name, when there is anything to say.
  String? get subtitle => registrationNumber;

  @override
  bool operator ==(Object other) =>
      other is LocationNode && other.id == id && other.level == level;

  @override
  int get hashCode => Object.hash(id, level);

  @override
  String toString() => name;
}
