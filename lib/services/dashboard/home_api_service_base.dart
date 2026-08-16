/// Contract `DashboardRepository` depends on for the Home Screen API
/// endpoints — lets the real Dio-backed [HomeApiServiceBase] implementation
/// and the mock implementation be swapped at the composition root
/// (`main.dart`) via the `useMockHomeApi` flag in `dashboard_config.dart`,
/// without the repository, provider, or any screen knowing which is in use.
///
/// Every method returns the full decoded response body (including the
/// contract's `success`/`message`/`data` wrapper) so the caller's existing
/// unwrap logic works identically for both the mock and real implementation.
abstract class HomeApiServiceBase {
  Future<Map<String, dynamic>> getHome();

  Future<Map<String, dynamic>> getAddresses();

  Future<Map<String, dynamic>> getPendingVisitors();

  Future<Map<String, dynamic>> getBanners();

  Future<Map<String, dynamic>> triggerSos({
    required double latitude,
    required double longitude,
  });
}
