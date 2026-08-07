import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

import 'features/dashboard/dashboard_config.dart';
import 'features/dashboard/data/repository/dashboard_repository.dart';
import 'features/dashboard/data/services/dashboard_service.dart';
import 'features/dashboard/data/services/home_api_service.dart';
import 'features/dashboard/data/services/home_api_service_base.dart';
import 'features/dashboard/data/services/mock_home_api_service.dart';

/// ✅ FIXED IMPORTS (VERY IMPORTANT)
import 'features/profile/provider/profile_provider.dart';
import 'features/profile/repository/profile_repository.dart';

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

  final AuthServiceBase authService =
      useMockApi ? MockAuthService() : AuthService(apiClient);

  final HomeApiServiceBase homeApiService = useMockHomeApi
      ? MockHomeApiService(const DashboardService())
      : HomeApiService(apiClient);

  final dashboardRepository = DashboardRepository(
    const DashboardService(),
    homeApiService,
  );

  /// ✅ CORRECT PROVIDER SETUP
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository()),
        ),
      ],
      child: NivasHubApp(
        localStorageService: localStorageService,
        secureStorageService: secureStorageService,
        connectivityService: connectivityService,
        apiClient: apiClient,
        authService: authService,
        dashboardRepository: dashboardRepository,
      ),
    ),
  );
}