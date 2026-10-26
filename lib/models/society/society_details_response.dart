import 'package:flutter_nivasshub/models/society/society_tower.dart';

/// Parsed `data` payload of `GET /society/details?socid=` — confirmed
/// against a live response (`socid=33`).
class SocietyDetailsResponseData {
  const SocietyDetailsResponseData({
    required this.societyId,
    required this.towers,
  });

  final String societyId;
  final List<SocietyTower> towers;

  factory SocietyDetailsResponseData.fromJson(Map<String, dynamic> json) {
    final rawTowers = json['towers'];
    return SocietyDetailsResponseData(
      societyId: json['societyId']?.toString() ?? '',
      towers: rawTowers is List
          ? rawTowers
                .whereType<Map>()
                .map((t) => SocietyTower.fromJson(Map<String, dynamic>.from(t)))
                .toList(growable: false)
          : const [],
    );
  }
}
