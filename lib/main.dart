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
import 'features/dashboard/dashboard_config.dart';
import 'features/dashboard/data/repository/dashboard_repository.dart';
import 'features/dashboard/data/services/dashboard_service.dart';
import 'features/dashboard/data/services/home_api_service.dart';
import 'features/dashboard/data/services/home_api_service_base.dart';
import 'features/dashboard/data/services/mock_home_api_service.dart';
import 'features/profile/profile_config.dart';
import 'features/profile/repository/mock_profile_service.dart';
import 'features/profile/repository/profile_service.dart';
import 'features/profile/repository/profile_service_base.dart';
import 'features/quick_actions/repository/mock_quick_actions_service.dart';
import 'features/quick_actions/repository/quick_actions_repository.dart';
import 'features/search/repository/mock_search_service.dart';
import 'features/search/repository/search_service_base.dart';
import 'features/settings/repository/settings_repository.dart';

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

  final ProfileServiceBase profileService =
      useMockProfileApi ? MockProfileService() : ProfileService(apiClient);

  // Quick Actions and Search have no published API yet (per the API
  // contract's cover note) — only a mock implementation exists today. Once
  // a real endpoint ships, construct the real service here instead; the
  // provider/UI on the other side of `QuickActionsServiceBase`/
  // `SearchServiceBase` needs no changes.
  final quickActionsRepository = QuickActionsRepository(MockQuickActionsService());
  final SearchServiceBase searchService = MockSearchService();

  final settingsRepository = SettingsRepository(localStorageService);

  runApp(
    NivasHubApp(
      localStorageService: localStorageService,
      secureStorageService: secureStorageService,
      connectivityService: connectivityService,
      apiClient: apiClient,
      authService: authService,
      dashboardRepository: dashboardRepository,
      profileService: profileService,
      quickActionsRepository: quickActionsRepository,
      searchService: searchService,
      settingsRepository: settingsRepository,
    ),
  );
}
