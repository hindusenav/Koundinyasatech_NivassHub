import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/emergency_sos_request.dart';
import 'home_api_service_base.dart';

/// Real implementation of [HomeApiServiceBase] — calls the NivasHub Home
/// Screen API contract endpoints via [ApiClient]. Returns the raw decoded
/// response body so callers unwrap it exactly like the mock implementation.
class HomeApiService implements HomeApiServiceBase {
  const HomeApiService(this._client);

  final ApiClient _client;

  @override
  Future<Map<String, dynamic>> getHome() async {
    final response = await _client.get(ApiEndpoints.home);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getAddresses() async {
    final response = await _client.get(ApiEndpoints.userAddresses);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getPendingVisitors() async {
    final response = await _client.get(ApiEndpoints.visitorsPending);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getBanners() async {
    final response = await _client.get(ApiEndpoints.banners);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> triggerSos({
    required double latitude,
    required double longitude,
  }) async {
    final request = EmergencySosRequest(
      latitude: latitude,
      longitude: longitude,
    );
    final response = await _client.post(
      ApiEndpoints.emergencySos,
      data: request.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }
}
