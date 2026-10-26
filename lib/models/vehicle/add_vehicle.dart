/// Body of `POST /vehicle/add`. [vehicleType] is the `2W` / `4W` code and
/// [brandId] the chosen `VehicleBrand.brandId`.
class AddVehicleRequest {
  const AddVehicleRequest({
    required this.userToken,
    required this.vehicleType,
    required this.registrationNumber,
    required this.brandId,
    required this.model,
    required this.colour,
    required this.parkingZoneId,
  });

  final String userToken;
  final String vehicleType;
  final String registrationNumber;
  final int brandId;
  final String model;
  final String colour;
  final int parkingZoneId;

  Map<String, dynamic> toJson() => {
    'user_token': userToken,
    'vehicletype': vehicleType,
    'vehicleregistrationnumber': registrationNumber,
    'vehiclebrandid': brandId,
    'vehiclemodel': model,
    'vehicle_colour': colour,
    'parkingzoneid': parkingZoneId,
  };
}

/// `data` of a successful `POST /vehicle/add`, plus the server's message.
class AddVehicleResult {
  const AddVehicleResult({
    required this.message,
    required this.vehicleId,
    required this.zoneName,
    required this.registrationNumber,
    required this.slotNumber,
    required this.slotType,
    required this.parkingFloor,
  });

  final String message;
  final int vehicleId;
  final String zoneName;
  final String registrationNumber;
  final String slotNumber;
  final String slotType;
  final String parkingFloor;

  /// [json] is the whole response body (`success`, `message`, `data`, ...).
  factory AddVehicleResult.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : const {};
    final id = data['vehicleId'];
    return AddVehicleResult(
      message: json['message']?.toString() ?? 'Vehicle added successfully.',
      vehicleId: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
      zoneName: data['zoneName']?.toString() ?? '',
      registrationNumber: data['vehicleRegistrationNumber']?.toString() ?? '',
      slotNumber: data['slotNumber']?.toString() ?? '',
      slotType: data['slotType']?.toString() ?? '',
      parkingFloor: data['parkingFloor']?.toString() ?? '',
    );
  }
}
