import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/vehicle/add_vehicle.dart';
import 'package:flutter_nivasshub/models/vehicle/vehicle_brand.dart';
import 'package:flutter_nivasshub/services/vehicle/vehicle_service_base.dart';

/// Dio-backed `GET /vehicle-brands` and `POST /vehicle/add`. The Bearer token
/// is added by the auth interceptor.
class VehicleService extends ApiService implements VehicleServiceBase {
  const VehicleService(super.client);

  @override
  Future<ApiResponse<VehicleBrandsData>> getVehicleBrands() {
    return handleRequest(() => client.get(ApiEndpoints.vehicleBrands), (json) {
      return VehicleBrandsData.fromJson(
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
      );
    });
  }

  @override
  Future<ApiResponse<AddVehicleResult>> addVehicle(AddVehicleRequest request) {
    return handleRequest(
      () => client.post(ApiEndpoints.addVehicle, data: request.toJson()),
      (json) => AddVehicleResult.fromJson(
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
      ),
    );
  }
}
