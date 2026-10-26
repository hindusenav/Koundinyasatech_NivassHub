import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/vehicle/add_vehicle.dart';
import 'package:flutter_nivasshub/models/vehicle/vehicle_brand.dart';

/// Vehicle master data and registration.
abstract class VehicleServiceBase {
  /// `GET /vehicle-brands` — brands grouped under 2W and 4W.
  Future<ApiResponse<VehicleBrandsData>> getVehicleBrands();

  /// `POST /vehicle/add` — registers a vehicle and returns its parking slot.
  Future<ApiResponse<AddVehicleResult>> addVehicle(AddVehicleRequest request);
}
