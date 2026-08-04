import 'dashboard_service.dart';
import 'home_api_service_base.dart';

/// Mock implementation of [HomeApiServiceBase] — returns contract-shaped
/// data from local JSON assets instead of a real network call. Reuses the
/// existing [DashboardService] JSON-asset loader rather than duplicating it.
class MockHomeApiService implements HomeApiServiceBase {
  const MockHomeApiService(this._jsonLoader);

  final DashboardService _jsonLoader;

  @override
  Future<Map<String, dynamic>> getHome() =>
      _jsonLoader.loadJson('assets/json/home.json');

  @override
  Future<Map<String, dynamic>> getAddresses() =>
      _jsonLoader.loadJson('assets/json/addresses.json');

  @override
  Future<Map<String, dynamic>> getPendingVisitors() =>
      _jsonLoader.loadJson('assets/json/pending_visitors.json');

  @override
  Future<Map<String, dynamic>> getBanners() =>
      _jsonLoader.loadJson('assets/json/banners.json');

  @override
  Future<Map<String, dynamic>> triggerSos({
    required double latitude,
    required double longitude,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'message': 'SOS alert triggered successfully',
    };
  }
}
