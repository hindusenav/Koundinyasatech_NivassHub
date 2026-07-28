import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/navigation_service.dart';
import 'core/routes/route_generator.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/dashboard/services/dashboard_service.dart';

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

  runApp(
    NivasHubApp(
      localStorageService: localStorageService,
      secureStorageService: secureStorageService,
      connectivityService: connectivityService,
      apiClient: apiClient,
      dashboardService: dashboardService,
    ),
  );
}

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
    required this.dashboardService,
  });

  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;
  final DashboardService dashboardService;

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
        Provider<DashboardService>.value(value: dashboardService),

        // Feature providers.
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(dashboardService: dashboardService),
        ),
      ],
      child: MaterialApp(
        title: 'NivasHub',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
