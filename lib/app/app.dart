import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/network/api_client.dart';
import '../core/network/connectivity_service.dart';
import '../core/storage/local_storage_service.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/provider/auth_provider.dart';
import '../features/auth/repository/auth_service_base.dart';
import '../features/dashboard/data/repository/dashboard_repository.dart';
import '../features/dashboard/presentation/provider/dashboard_navigation_provider.dart';
import '../features/dashboard/presentation/provider/dashboard_provider.dart';
import '../features/profile/provider/profile_provider.dart';
import '../features/profile/repository/profile_service_base.dart';
import '../features/quick_actions/provider/quick_actions_provider.dart';
import '../features/quick_actions/repository/quick_actions_repository.dart';
import '../features/search/provider/search_provider.dart';
import '../features/search/repository/search_service_base.dart';
import '../features/settings/provider/settings_provider.dart';
import '../features/settings/repository/settings_repository.dart';
import 'app_routes.dart';
import 'app_theme.dart';
import 'navigation_service.dart';
import 'route_generator.dart';
import 'theme_mode_provider.dart';

/// Root widget — registers every app-wide service/provider once here, then
/// hands off to [MaterialApp]. Feature-specific providers are added to the
/// `providers` list below as each feature is built.
class NivasHubApp extends StatelessWidget {
  const NivasHubApp({
    super.key,
    required this.localStorageService,
    required this.secureStorageService,
    required this.connectivityService,
    required this.apiClient,
    required this.authService,
    required this.dashboardRepository,
    required this.profileService,
    required this.quickActionsRepository,
    required this.searchService,
    required this.settingsRepository,
  });

  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;
  final AuthServiceBase authService;
  final DashboardRepository dashboardRepository;
  final ProfileServiceBase profileService;
  final QuickActionsRepository quickActionsRepository;
  final SearchServiceBase searchService;
  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App-wide singletons — feature services read these via
        // `context.read<ApiClient>()` etc. when building their own provider.
        Provider<LocalStorageService>.value(value: localStorageService),
        Provider<SecureStorageService>.value(value: secureStorageService),
        Provider<ConnectivityService>.value(value: connectivityService),
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthServiceBase>.value(value: authService),

        // Feature providers.
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(dashboardRepository)..loadDashboard(),
        ),
        ChangeNotifierProvider<DashboardNavigationProvider>(
          create: (_) => DashboardNavigationProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider<ThemeModeProvider>(
          create: (_) => ThemeModeProvider(localStorageService)..init(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(profileService)..loadProfile(),
        ),
        ChangeNotifierProvider<QuickActionsProvider>(
          create: (_) => QuickActionsProvider(quickActionsRepository),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(searchService),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(settingsRepository),
        ),
      ],
      // `builder:` (not `child:`) — `child:` sits outside the provider tree
      // and can't `watch` a provider registered above it, but `themeMode:`
      // needs to react live to `ThemeModeProvider`.
      builder: (context, _) {
        final themeModeProvider = context.watch<ThemeModeProvider>();
        return MaterialApp(
          title: 'NivasHub',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeModeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
