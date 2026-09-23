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

import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
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
// AUTH ENTRY / KYC
// ============================================================

import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/notifications/mock_notification_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/services/notifications/notification_service_base.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';

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
    required this.forgotPasswordService,
    required this.dashboardRepository,
    required this.quickActionsRepository,
    required this.searchService,
    required this.settingsRepository,
    required this.profileRepository,
    required this.authStateProvider,
    required this.authEntryService,
    required this.countryService,
    required this.locationService,
    required this.registrationService,
    required this.societyService,
    required this.otpVerificationService,
    required this.documentService,
    required this.kycService,
    required this.filePickerService,
    required this.notificationService,
  });

  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;

  final ForgotPasswordServiceBase forgotPasswordService;

  final DashboardRepository dashboardRepository;

  final QuickActionsRepository quickActionsRepository;

  final SearchServiceBase searchService;

  final SettingsRepository settingsRepository;

  final ProfileRepository profileRepository;

  /// Built in `main.dart` rather than here, because `MockKycService`
  /// closes over it to address its notifications.
  final AuthStateProvider authStateProvider;

  final AuthEntryServiceBase authEntryService;
  final CountryServiceBase countryService;
  final LocationServiceBase locationService;
  final RegistrationServiceBase registrationService;
  final SocietyServiceBase societyService;
  final OtpVerificationServiceBase otpVerificationService;
  final DocumentServiceBase documentService;
  final KycServiceBase kycService;
  final FilePickerServiceBase filePickerService;
  final NotificationServiceBase notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ========================================================
        // CORE SERVICES
        // ========================================================
        Provider<LocalStorageService>.value(value: localStorageService),

        Provider<SecureStorageService>.value(value: secureStorageService),

        Provider<ConnectivityService>.value(value: connectivityService),

        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) =>
              ConnectivityProvider(connectivityService: connectivityService),
        ),

        Provider<ApiClient>.value(value: apiClient),

        Provider<ForgotPasswordServiceBase>.value(value: forgotPasswordService),

        // ========================================================
        // AUTH
        // ========================================================
        ChangeNotifierProvider<ForgotPasswordProvider>(
          create: (_) => ForgotPasswordProvider(
            forgotPasswordService: forgotPasswordService,
          ),
        ),

        // ========================================================
        // DASHBOARD
        // ========================================================
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) =>
              DashboardProvider(dashboardRepository)..loadDashboard(),
        ),

        ChangeNotifierProvider<DashboardNavigationProvider>(
          create: (_) => DashboardNavigationProvider(),
        ),

        // ========================================================
        // QUICK ACTIONS
        // ========================================================
        ChangeNotifierProvider<QuickActionsProvider>(
          create: (_) => QuickActionsProvider(quickActionsRepository),
        ),

        // ========================================================
        // SEARCH
        // ========================================================
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(searchService),
        ),

        // ========================================================
        // SETTINGS
        // ========================================================
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) =>
              SettingsProvider(settingsRepository: settingsRepository),
        ),

        // ========================================================
        // PROFILE
        // ========================================================
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(repository: profileRepository),
        ),

        // ========================================================
        // AUTH ENTRY / KYC
        //
        // The screen-scoped providers for these features (auth entry,
        // password, user details, location cascade, KYC status) are
        // created per-route in `AuthRouter`; only the three that must
        // outlive a single route are global.
        // ========================================================
        Provider<AuthEntryServiceBase>.value(value: authEntryService),

        Provider<CountryServiceBase>.value(value: countryService),

        Provider<LocationServiceBase>.value(value: locationService),

        Provider<RegistrationServiceBase>.value(value: registrationService),

        Provider<SocietyServiceBase>.value(value: societyService),

        Provider<OtpVerificationServiceBase>.value(value: otpVerificationService),

        Provider<DocumentServiceBase>.value(value: documentService),

        Provider<KycServiceBase>.value(value: kycService),

        Provider<FilePickerServiceBase>.value(value: filePickerService),

        Provider<NotificationServiceBase>.value(value: notificationService),

        ChangeNotifierProvider<AuthStateProvider>.value(
          value: authStateProvider,
        ),

        // Lazy (provider's default): never constructed for a user who is
        // already authenticated and never touches KYC.
        ChangeNotifierProvider<KycProvider>(
          create: (_) => KycProvider(
            documentService: documentService,
            kycService: kycService,
            filePickerService: filePickerService,
            localStorage: localStorageService,
            authState: authStateProvider,
          ),
        ),

        ChangeNotifierProvider<MockNotificationProvider>(
          create: (_) => MockNotificationProvider(notificationService),
        ),

        // ========================================================
        // THEME
        // ========================================================
        ChangeNotifierProvider<ThemeModeProvider>(
          create: (_) => ThemeModeProvider(localStorageService)..init(),
        ),
      ],

      // ==========================================================
      // MATERIAL APP
      // ==========================================================
      builder: (context, child) {
        final themeModeProvider = context.watch<ThemeModeProvider>();

        return MaterialApp(
          title: 'NivasHub',

          debugShowCheckedModeBanner: false,

          navigatorKey: NavigationService.navigatorKey,

          navigatorObservers: [
            DashboardNavObserver(context.read<DashboardNavigationProvider>()),
            ConnectivityRouteObserver(context.read<ConnectivityProvider>()),
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
