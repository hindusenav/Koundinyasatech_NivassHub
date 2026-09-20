import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';

/// An immutable snapshot of the seven cascade choices, handed from
/// `LocationProvider` to `CreateUserRequest`.
///
/// Keeping this separate from the provider means the request body never
/// reaches into mutable provider state, and a future "add another flat"
/// screen can build one the same way.
class LocationSelection {
  const LocationSelection({
    this.country,
    this.state,
    this.city,
    this.society,
    this.tower,
    this.floor,
    this.flat,
  });

  final LocationNode? country;
  final LocationNode? state;
  final LocationNode? city;
  final LocationNode? society;
  final LocationNode? tower;
  final LocationNode? floor;
  final LocationNode? flat;

  /// Builds from the provider's level→node map.
  factory LocationSelection.fromMap(Map<LocationLevel, LocationNode?> map) {
    return LocationSelection(
      country: map[LocationLevel.country],
      state: map[LocationLevel.state],
      city: map[LocationLevel.city],
      society: map[LocationLevel.society],
      tower: map[LocationLevel.tower],
      floor: map[LocationLevel.floor],
      flat: map[LocationLevel.flat],
    );
  }

  LocationNode? operator [](LocationLevel level) => switch (level) {
    LocationLevel.country => country,
    LocationLevel.state => state,
    LocationLevel.city => city,
    LocationLevel.society => society,
    LocationLevel.tower => tower,
    LocationLevel.floor => floor,
    LocationLevel.flat => flat,
  };

  /// Every level chosen — the Submit gate on the User Details screen.
  bool get isComplete =>
      LocationLevel.values.every((level) => this[level] != null);

  /// The first level still missing, so the form can scroll to and flag it.
  LocationLevel? get firstMissingLevel {
    for (final level in LocationLevel.values) {
      if (this[level] == null) return level;
    }
    return null;
  }

  /// Human-readable address line, e.g. `A-502, Tower A, NivassHub Residency`.
  String get addressLabel =>
      [flat?.name, tower?.name, society?.name].whereType<String>().join(', ');

  Map<String, dynamic> toJson() => {
    for (final level in LocationLevel.values)
      '${level.wireValue}Id': this[level]?.id,
    for (final level in LocationLevel.values)
      '${level.wireValue}Name': this[level]?.name,
  };

  /// Stored inside `AuthFlowContext` so a resumed flow can show the chosen
  /// home without re-walking the cascade.
  Map<String, dynamic> toStoredJson() => {
    for (final level in LocationLevel.values)
      level.wireValue: this[level]?.toJson(),
  };

  factory LocationSelection.fromStoredJson(Map<String, dynamic> json) {
    LocationNode? read(LocationLevel level) {
      final raw = json[level.wireValue];
      if (raw is! Map) return null;
      return LocationNode.fromStoredJson(Map<String, dynamic>.from(raw));
    }

    return LocationSelection(
      country: read(LocationLevel.country),
      state: read(LocationLevel.state),
      city: read(LocationLevel.city),
      society: read(LocationLevel.society),
      tower: read(LocationLevel.tower),
      floor: read(LocationLevel.floor),
      flat: read(LocationLevel.flat),
    );
  }
}
