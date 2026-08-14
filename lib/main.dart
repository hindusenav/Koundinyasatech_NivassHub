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

import 'features/quick_actions/repository/mock_quick_actions_service.dart';
import 'features/quick_actions/repository/quick_actions_repository.dart';

import 'features/search/repository/mock_search_service.dart';
import 'features/search/repository/search_service_base.dart';

import 'features/settings/repository/settings_repository.dart';

// ============================================================
// PROFILE
// ============================================================

import 'features/profile/repository/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // LOCAL STORAGE
  // ============================================================

  final localStorageService = LocalStorageService();

  await localStorageService.init();

  // ============================================================
  // SECURE STORAGE
  // ============================================================

  final secureStorageService =
      SecureStorageService();

  // ============================================================
  // CONNECTIVITY
  // ============================================================

  final connectivityService =
      ConnectivityService();

  // ============================================================
  // API CLIENT
  // ============================================================

  final apiClient = ApiClient(
    getAccessToken:
        secureStorageService.getAccessToken,
    onUnauthorized:
        NavigationService
            .logoutAndRedirectToLogin,
  );

  // ============================================================
  // AUTH SERVICE
  // ============================================================

  final AuthServiceBase authService =
      useMockApi
          ? MockAuthService()
          : AuthService(apiClient);

  // ============================================================
  // DASHBOARD SERVICE
  // ============================================================

  final HomeApiServiceBase homeApiService =
      useMockHomeApi
          ? MockHomeApiService(
              const DashboardService(),
            )
          : HomeApiService(apiClient);

  // ============================================================
  // DASHBOARD REPOSITORY
  // ============================================================

  final dashboardRepository =
      DashboardRepository(
    const DashboardService(),
    homeApiService,
  );

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  final quickActionsRepository =
      QuickActionsRepository(
    MockQuickActionsService(),
  );

  // ============================================================
  // SEARCH
  // ============================================================

  final SearchServiceBase searchService =
      MockSearchService();

  // ============================================================
  // SETTINGS
  // ============================================================

  final settingsRepository =
      SettingsRepository(
    localStorageService,
  );

  // ============================================================
  // PROFILE
  // ============================================================

  final profileRepository =
      ProfileRepository();

  // ============================================================
  // RUN APP
  // ============================================================

  runApp(
    NivasHubApp(
      localStorageService:
          localStorageService,

      secureStorageService:
          secureStorageService,

      connectivityService:
          connectivityService,

      apiClient:
          apiClient,

      authService:
          authService,

      dashboardRepository:
          dashboardRepository,

      quickActionsRepository:
          quickActionsRepository,

      searchService:
          searchService,

      settingsRepository:
          settingsRepository,

      // Profile repository
      profileRepository:
          profileRepository,
    ),
  );
}