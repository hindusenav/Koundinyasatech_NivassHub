import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/app.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/services/core/connectivity_service.dart';

import 'package:flutter_nivasshub/services/core/local_storage_service.dart';
import 'package:flutter_nivasshub/services/core/secure_storage_service.dart';

import 'package:flutter_nivasshub/constants/auth/auth_config.dart';
import 'package:flutter_nivasshub/services/auth/auth_service.dart';
import 'package:flutter_nivasshub/services/auth/auth_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_service.dart';

import 'package:flutter_nivasshub/constants/dashboard/dashboard_config.dart';
import 'package:flutter_nivasshub/services/dashboard/dashboard_repository.dart';
import 'package:flutter_nivasshub/services/dashboard/dashboard_service.dart';
import 'package:flutter_nivasshub/services/dashboard/home_api_service.dart';
import 'package:flutter_nivasshub/services/dashboard/home_api_service_base.dart';
import 'package:flutter_nivasshub/services/dashboard/mock_home_api_service.dart';

import 'package:flutter_nivasshub/services/quick_actions/mock_quick_actions_service.dart';
import 'package:flutter_nivasshub/services/quick_actions/quick_actions_repository.dart';

import 'package:flutter_nivasshub/services/search/mock_search_service.dart';
import 'package:flutter_nivasshub/services/search/search_service_base.dart';

import 'package:flutter_nivasshub/services/settings/settings_repository.dart';

// ============================================================
// PROFILE
// ============================================================

import 'package:flutter_nivasshub/services/profile/profile_repository.dart';

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
    onUnauthorized: () async {
      // A 401 means the persisted session is no longer valid — clear it so
      // a relaunch doesn't incorrectly auto-navigate to the Dashboard.
      await secureStorageService.clearSession();
      await NavigationService.logoutAndRedirectToLogin();
    },
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