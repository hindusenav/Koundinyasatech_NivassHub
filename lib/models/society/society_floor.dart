import 'package:flutter_nivasshub/models/society/society_unit.dart';

/// One floor row inside a [SocietyTower]. `units` is legitimately `[]`
/// for a floor with nothing occupied yet — that's an empty state for the
/// Unit picker, not an error.
class SocietyFloor {
  const SocietyFloor({
    required this.floorId,
    required this.floorNumber,
    required this.floorName,
    required this.units,
  });

  final String floorId;
  final int floorNumber;
  final String floorName;
  final List<SocietyUnit> units;

  factory SocietyFloor.fromJson(Map<String, dynamic> json) {
    final rawUnits = json['units'];
    return SocietyFloor(
      floorId: json['floorId']?.toString() ?? '',
      floorNumber: (json['floorNumber'] as num?)?.toInt() ?? 0,
      floorName: json['floorName']?.toString() ?? '',
      units: rawUnits is List
          ? rawUnits
                .whereType<Map>()
                .map((u) => SocietyUnit.fromJson(Map<String, dynamic>.from(u)))
                .toList(growable: false)
          : const [],
    );
  }
}
