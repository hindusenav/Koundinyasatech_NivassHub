import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// CORE
// ============================================================

import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/services/connectivity/connectivity_service.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/providers/connectivity/connectivity_provider.dart';
import 'package:flutter_nivasshub/widgets/shared/connectivity/no_internet_overlay.dart';

// ============================================================
// AUTH
// ============================================================

import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_service_base.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';

// ============================================================
// DASHBOARD
// ============================================================

import 'package:flutter_nivasshub/repositories/dashboard/dashboard_repository.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';

// ============================================================
// PROFILE
// ============================================================

import 'package:flutter_nivasshub/providers/profile/profile_provider.dart';
import 'package:flutter_nivasshub/repositories/profile/profile_repository.dart';

// ============================================================
// QUICK ACTIONS
// ============================================================

import 'package:flutter_nivasshub/providers/quick_actions/quick_actions_provider.dart';
import 'package:flutter_nivasshub/repositories/quick_actions/quick_actions_repository.dart';

// ============================================================
// SEARCH
// ============================================================

import 'package:flutter_nivasshub/providers/search/search_provider.dart';
import 'package:flutter_nivasshub/services/search/search_service_base.dart';

// ============================================================
// SETTINGS
// ============================================================

import 'package:flutter_nivasshub/providers/settings/settings_provider.dart';
import 'package:flutter_nivasshub/repositories/settings/settings_repository.dart';

// ============================================================
// APP
// ============================================================

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_theme.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/routes/auth_router.dart';
import 'package:flutter_nivasshub/routes/app_router.dart';
import 'package:flutter_nivasshub/providers/theme/theme_mode_provider.dart';

class NivasHubApp extends StatelessWidget {
  const NivasHubApp({
    super.key,
    required this.localStorageService,
    required this.secureStorageService,
    required this.connectivityService,
    required this.apiClient,
    required this.authService,
    required this.forgotPasswordService,
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
  final ForgotPasswordServiceBase forgotPasswordService;

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

        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(
            connectivityService: connectivityService,
          ),
        ),

        Provider<ApiClient>.value(
          value: apiClient,
        ),

        Provider<AuthServiceBase>.value(
          value: authService,
        ),

        Provider<ForgotPasswordServiceBase>.value(
          value: forgotPasswordService,
        ),

        // ========================================================
        // AUTH
        // ========================================================

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authService: authService,
          ),
        ),

        ChangeNotifierProvider<ForgotPasswordProvider>(
          create: (_) => ForgotPasswordProvider(
            forgotPasswordService: forgotPasswordService,
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

          navigatorObservers: [
            DashboardNavObserver(
              context.read<DashboardNavigationProvider>(),
            ),
            ConnectivityRouteObserver(
              context.read<ConnectivityProvider>(),
            ),
          ],

          theme: AppTheme.light,

          darkTheme: AppTheme.dark,

          themeMode: themeModeProvider.themeMode,

          initialRoute: AppRoutes.splash,

          onGenerateRoute: (settings) =>
              AuthRouter.generateRoute(settings) ??
              AppRouter.generateRoute(settings),

          builder: (context, child) => NoInternetOverlay(child: child),
        );
      },
    );
  }
}