import 'package:flutter_nivasshub/models/society/society_floor.dart';

/// One tower row from `GET /society/details?socid=`.
class SocietyTower {
  const SocietyTower({
    required this.towerId,
    required this.towerName,
    required this.towerCode,
    required this.totalFloors,
    required this.floors,
  });

  final String towerId;
  final String towerName;
  final String towerCode;
  final int totalFloors;
  final List<SocietyFloor> floors;

  factory SocietyTower.fromJson(Map<String, dynamic> json) {
    final rawFloors = json['floors'];
    return SocietyTower(
      towerId: json['towerId']?.toString() ?? '',
      towerName: json['towerName']?.toString() ?? '',
      towerCode: json['towerCode']?.toString() ?? '',
      totalFloors: (json['totalFloors'] as num?)?.toInt() ?? 0,
      floors: rawFloors is List
          ? rawFloors
                .whereType<Map>()
                .map((f) => SocietyFloor.fromJson(Map<String, dynamic>.from(f)))
                .toList(growable: false)
          : const [],
    );
  }
}
