/// The two vehicle categories the API groups brands under.
enum VehicleType {
  twoWheeler('2W', 'Two Wheeler'),
  fourWheeler('4W', 'Four Wheeler');

  const VehicleType(this.code, this.label);

  final String code;
  final String label;
}

/// One entry of `data["2W"]` / `data["4W"]` in `GET /vehicle-brands`.
class VehicleBrand {
  const VehicleBrand({
    required this.brandId,
    required this.vehicleType,
    required this.vehicleTypeName,
    required this.vehicleBrand,
  });

  final int brandId;
  final String vehicleType;
  final String vehicleTypeName;
  final String vehicleBrand;

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    final id = json['brandId'];
    return VehicleBrand(
      brandId: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
      vehicleType: json['vehicleType']?.toString() ?? '',
      vehicleTypeName: json['vehicleTypeName']?.toString() ?? '',
      vehicleBrand: json['vehicleBrand']?.toString() ?? '',
    );
  }

  /// Brand ids are only unique within a type (e.g. "Honda" is 2 in 2W and 66
  /// in 4W), so equality uses both.
  @override
  bool operator ==(Object other) =>
      other is VehicleBrand &&
      other.brandId == brandId &&
      other.vehicleType == vehicleType;

  @override
  int get hashCode => Object.hash(brandId, vehicleType);
}

/// Parsed `data` + `meta` of `GET /vehicle-brands`.
class VehicleBrandsData {
  const VehicleBrandsData({
    required this.twoWheelers,
    required this.fourWheelers,
    this.parkingSlots = const [],
  });

  static const VehicleBrandsData empty = VehicleBrandsData(
    twoWheelers: [],
    fourWheelers: [],
  );

  final List<VehicleBrand> twoWheelers;
  final List<VehicleBrand> fourWheelers;

  /// Always empty in the current response; kept raw until a shape is known.
  final List<Object?> parkingSlots;

  int get totalCount => twoWheelers.length + fourWheelers.length;

  List<VehicleBrand> brandsOf(VehicleType type) =>
      type == VehicleType.twoWheeler ? twoWheelers : fourWheelers;

  /// [json] is the whole response body (`success`, `data`, `meta`, ...).
  factory VehicleBrandsData.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is Map ? Map<String, dynamic>.from(rawData) : const {};

    List<VehicleBrand> parse(String key) {
      final raw = data[key];
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => VehicleBrand.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false);
    }

    final slots = data['parkingSlots'];
    return VehicleBrandsData(
      twoWheelers: parse('2W'),
      fourWheelers: parse('4W'),
      parkingSlots: slots is List ? List<Object?>.from(slots) : const [],
    );
  }
}
