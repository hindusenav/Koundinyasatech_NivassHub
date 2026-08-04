import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/navigation_service.dart';
import 'core/network/api_client.dart';
import 'core/network/connectivity_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/auth_config.dart';
import 'features/auth/repository/auth_service.dart';
import 'features/auth/repository/auth_service_base.dart';
import 'features/auth/repository/mock_auth_service.dart';
import 'features/dashboard/repository/dashboard_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorageService = LocalStorageService();
  await localStorageService.init();

  final secureStorageService = SecureStorageService();
  final connectivityService = ConnectivityService();

  final apiClient = ApiClient(
    getAccessToken: secureStorageService.getAccessToken,
    onUnauthorized: NavigationService.logoutAndRedirectToLogin,
  );

  final dashboardService = DashboardService(apiClient);
  final AuthServiceBase authService =
      useMockApi ? MockAuthService() : AuthService(apiClient);

  runApp(
    NivasHubApp(
      localStorageService: localStorageService,
      secureStorageService: secureStorageService,
      connectivityService: connectivityService,
      apiClient: apiClient,
      dashboardService: dashboardService,
      authService: authService,
    ),
  );
}
