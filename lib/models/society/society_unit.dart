/// One unit (flat) row inside a [SocietyFloor], from
/// `GET /society/details?socid=`.
class SocietyUnit {
  const SocietyUnit({
    required this.unitId,
    required this.unitNumber,
    required this.unitTypeBhk,
    required this.carpetArea,
    required this.superArea,
  });

  /// The unit's numeric id (`Units_ID`) — what `POST
  /// /country-codes/user-registration` expects for `unitnumber`, distinct
  /// from the human-facing [unitNumber] label shown in the picker.
  final String unitId;

  /// The unit's human-facing label (e.g. `"TE201"`) — display only.
  final String unitNumber;
  final String unitTypeBhk;
  final num carpetArea;
  final num superArea;

  factory SocietyUnit.fromJson(Map<String, dynamic> json) {
    return SocietyUnit(
      unitId: json['Units_ID']?.toString() ?? '',
      unitNumber: json['unitNumber']?.toString() ?? '',
      unitTypeBhk: json['unitTypeBhk']?.toString() ?? '',
      carpetArea: (json['carpetArea'] as num?) ?? 0,
      superArea: (json['superArea'] as num?) ?? 0,
    );
  }
}
