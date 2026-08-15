import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// CORE
// ============================================================

import '../core/network/api_client.dart';
import '../core/network/connectivity_service.dart';
import '../core/storage/local_storage_service.dart';
import '../core/storage/secure_storage_service.dart';

// ============================================================
// AUTH
// ============================================================

import '../features/auth/provider/auth_provider.dart';
import '../features/auth/repository/auth_service_base.dart';

// ============================================================
// DASHBOARD
// ============================================================

import '../features/dashboard/data/repository/dashboard_repository.dart';
import '../features/dashboard/presentation/provider/dashboard_navigation_provider.dart';
import '../features/dashboard/presentation/provider/dashboard_provider.dart';

// ============================================================
// PROFILE
// ============================================================

import '../features/profile/provider/profile_provider.dart';
import '../features/profile/repository/profile_repository.dart';

// ============================================================
// QUICK ACTIONS
// ============================================================

import '../features/quick_actions/provider/quick_actions_provider.dart';
import '../features/quick_actions/repository/quick_actions_repository.dart';

// ============================================================
// SEARCH
// ============================================================

import '../features/search/provider/search_provider.dart';
import '../features/search/repository/search_service_base.dart';

// ============================================================
// SETTINGS
// ============================================================

import '../features/settings/provider/settings_provider.dart';
import '../features/settings/repository/settings_repository.dart';

// ============================================================
// APP
// ============================================================

import 'app_routes.dart';
import 'app_theme.dart';
import 'navigation_service.dart';
import 'route_generator.dart';
import 'theme_mode_provider.dart';

class NivasHubApp extends StatelessWidget {
  const NivasHubApp({
    super.key,
    required this.localStorageService,
    required this.secureStorageService,
    required this.connectivityService,
    required this.apiClient,
    required this.authService,
    required this.dashboardRepository,
    required this.quickActionsRepository,
    required this.searchService,
    required this.settingsRepository,
    required this.profileRepository,
  });

  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;

  final AuthServiceBase authService;

  final DashboardRepository dashboardRepository;

  final QuickActionsRepository quickActionsRepository;

  final SearchServiceBase searchService;

  final SettingsRepository settingsRepository;

  final ProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ========================================================
        // CORE SERVICES
        // ========================================================

        Provider<LocalStorageService>.value(
          value: localStorageService,
        ),

        Provider<SecureStorageService>.value(
          value: secureStorageService,
        ),

        Provider<ConnectivityService>.value(
          value: connectivityService,
        ),

        Provider<ApiClient>.value(
          value: apiClient,
        ),

        Provider<AuthServiceBase>.value(
          value: authService,
        ),

        // ========================================================
        // AUTH
        // ========================================================

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authService: authService,
          ),
        ),

        // ========================================================
        // DASHBOARD
        // ========================================================

        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(
            dashboardRepository,
          )..loadDashboard(),
        ),

        ChangeNotifierProvider<DashboardNavigationProvider>(
          create: (_) => DashboardNavigationProvider(),
        ),

        // ========================================================
        // QUICK ACTIONS
        // ========================================================

        ChangeNotifierProvider<QuickActionsProvider>(
          create: (_) => QuickActionsProvider(
            quickActionsRepository,
          ),
        ),

        // ========================================================
        // SEARCH
        // ========================================================

        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(
            searchService,
          ),
        ),

        // ========================================================
        // SETTINGS
        // ========================================================
ChangeNotifierProvider<SettingsProvider>(
  create: (_) => SettingsProvider(
    settingsRepository: settingsRepository,
  ),
),

        // ========================================================
        // PROFILE
        // ========================================================
ChangeNotifierProvider<ProfileProvider>(
  create: (_) => ProfileProvider(
    repository: profileRepository,
  ),
),

        // ========================================================
        // THEME
        // ========================================================

        ChangeNotifierProvider<ThemeModeProvider>(
          create: (_) => ThemeModeProvider(
            localStorageService,
          )..init(),
        ),
      ],

      // ==========================================================
      // MATERIAL APP
      // ==========================================================

      builder: (context, child) {
        final themeModeProvider =
            context.watch<ThemeModeProvider>();

        return MaterialApp(
          title: 'NivasHub',

          debugShowCheckedModeBanner: false,

          navigatorKey: NavigationService.navigatorKey,

          theme: AppTheme.light,

          darkTheme: AppTheme.dark,

          themeMode: themeModeProvider.themeMode,

          initialRoute: AppRoutes.splash,

          onGenerateRoute:
              RouteGenerator.generateRoute,
        );
      },
    );
  }
}