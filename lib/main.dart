import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/app.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';

import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/services/connectivity/connectivity_service.dart';

import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

import 'package:flutter_nivasshub/constants/auth/auth_config.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_forgot_password_service.dart';

import 'package:flutter_nivasshub/constants/dashboard/dashboard_config.dart';
import 'package:flutter_nivasshub/repositories/dashboard/dashboard_repository.dart';
import 'package:flutter_nivasshub/services/dashboard/dashboard_service.dart';
import 'package:flutter_nivasshub/services/dashboard/home_api_service.dart';
import 'package:flutter_nivasshub/services/dashboard/home_api_service_base.dart';
import 'package:flutter_nivasshub/services/dashboard/mock_home_api_service.dart';

import 'package:flutter_nivasshub/services/quick_actions/mock_quick_actions_service.dart';
import 'package:flutter_nivasshub/repositories/quick_actions/quick_actions_repository.dart';

import 'package:flutter_nivasshub/services/search/mock_search_service.dart';
import 'package:flutter_nivasshub/services/search/search_service_base.dart';

import 'package:flutter_nivasshub/repositories/settings/settings_repository.dart';

// ============================================================
// PROFILE
// ============================================================

import 'package:flutter_nivasshub/repositories/profile/profile_repository.dart';

// ============================================================
// AUTH ENTRY / KYC
// ============================================================

import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_entry_service.dart';
import 'package:flutter_nivasshub/services/auth/partial_real_auth_entry_service.dart';
import 'package:flutter_nivasshub/services/country/country_service.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/document_service.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/mock_document_service.dart';
import 'package:flutter_nivasshub/services/kyc/mock_kyc_service.dart';
import 'package:flutter_nivasshub/services/location/location_service.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/services/location/mock_location_service.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/services/notifications/mock_notification_service.dart';
import 'package:flutter_nivasshub/services/notifications/notification_service_base.dart';
import 'package:flutter_nivasshub/services/registration/registration_service.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';
import 'package:flutter_nivasshub/services/society/society_service.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[App] Startup begin');

  // ============================================================
  // LOCAL STORAGE
  // ============================================================

  final localStorageService = LocalStorageService();

  await localStorageService.init();

  // ============================================================
  // SECURE STORAGE
  // ============================================================

  final secureStorageService = SecureStorageService();

  // ============================================================
  // CONNECTIVITY
  // ============================================================

  final connectivityService = ConnectivityService();

  // ============================================================
  // API CLIENT
  // ============================================================

  final apiClient = ApiClient(
    getAccessToken: secureStorageService.getAccessToken,
    onUnauthorized: () async {
      // A 401 means the persisted session is no longer valid — clear it so
      // a relaunch doesn't incorrectly auto-navigate to the Dashboard.
      debugPrint(
        '[Auth] 401 received - clearing session and redirecting to Login',
      );
      await secureStorageService.clearSession();
      await NavigationService.logoutAndRedirectToLogin();
    },
  );

  // ============================================================
  // FORGOT PASSWORD SERVICE
  // ============================================================

  final ForgotPasswordServiceBase forgotPasswordService = useMockApi
      ? MockForgotPasswordService()
      : ForgotPasswordService(apiClient);

  // ============================================================
  // DASHBOARD SERVICE
  // ============================================================

  final HomeApiServiceBase homeApiService = useMockHomeApi
      ? MockHomeApiService(const DashboardService())
      : HomeApiService(apiClient);

  // ============================================================
  // DASHBOARD REPOSITORY
  // ============================================================

  final dashboardRepository = DashboardRepository(
    const DashboardService(),
    homeApiService,
  );

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  final quickActionsRepository = QuickActionsRepository(
    MockQuickActionsService(),
  );

  // ============================================================
  // SEARCH
  // ============================================================

  final SearchServiceBase searchService = MockSearchService();

  // ============================================================
  // SETTINGS
  // ============================================================

  final settingsRepository = SettingsRepository(localStorageService);

  // ============================================================
  // PROFILE
  // ============================================================

  final profileRepository = ProfileRepository();

  // ============================================================
  // AUTH FLOW STATE
  //
  // Built here rather than in `app.dart` because `MockKycService` needs
  // to read the registered user's name and email when it sends a KYC
  // notification, and that state lives here.
  // ============================================================

  final authStateProvider = AuthStateProvider(
    localStorage: localStorageService,
    secureStorage: secureStorageService,
  );

  // ============================================================
  // AUTH ENTRY / COUNTRY / LOCATION
  //
  // `checkUserExists`/`loginUser` have a documented backend contract
  // (`POST /country-codes/registration-check`, `POST /auth/login`) and go
  // through the real `AuthEntryService` once `useMockApi` is false.
  // `createUser`/`generateAccessToken` do not — MISSING API CONTRACT —
  // and stay on `MockAuthEntryService` regardless of the flag, via
  // `PartialRealAuthEntryService`. See that class for details.
  // ============================================================

  final mockAuthEntryService = MockAuthEntryService();

  final AuthEntryServiceBase authEntryService = useMockApi
      ? mockAuthEntryService
      : PartialRealAuthEntryService(
          real: AuthEntryService(apiClient),
          mock: mockAuthEntryService,
        );

  // `GET /country-codes` is fully documented — always real, no mock twin.
  final CountryServiceBase countryService = CountryService(apiClient);

  // State/city/society/tower/floor/flat have no documented endpoint, so
  // this stays mocked regardless of `useMockApi`/`KycConfig.useMockKycApi`
  // beyond the country level, which `LocationProvider` sources from
  // `countryService` instead (see `LocationProvider`'s constructor).
  final LocationServiceBase locationService = KycConfig.useMockKycApi
      ? MockLocationService()
      : LocationService(apiClient);

  // `GET`/`POST /country-codes/user-registration` and
  // `GET /society/details` are both documented and confirmed against live
  // responses — always real, no mock twin. `RegistrationService` also
  // backs the User Details screen's Country picker (it implements
  // `CountryServiceBase`), sourcing from the registration master-data
  // response instead of the dial-code-only `/country-codes`.
  final RegistrationServiceBase registrationService = RegistrationService(
    apiClient,
  );
  final SocietyServiceBase societyService = SocietyService(apiClient);

  // `POST /country-codes/user-registration/verify-otp` and
  // `POST /otp/resend` — both documented and always real, same as the two
  // services above.
  final OtpVerificationServiceBase otpVerificationService = OtpVerificationService(
    apiClient,
  );

  // ============================================================
  // NOTIFICATIONS
  //
  // No mail transport is wired up, so this always logs to the console
  // and to the in-app inbox regardless of the mock flags.
  // ============================================================

  final NotificationServiceBase notificationService = MockNotificationService(
    localStorageService,
  );

  // ============================================================
  // KYC
  // ============================================================

  final DocumentServiceBase documentService = KycConfig.useMockKycApi
      ? MockDocumentService()
      : DocumentService(apiClient);

  final KycServiceBase kycService = KycConfig.useMockKycApi
      ? MockKycService(
          storage: localStorageService,
          notificationService: notificationService,
          // Resolved lazily: the service is built at startup, long before
          // the user has registered and these values exist.
          recipientResolver: () =>
              authStateProvider.context.notificationRecipient,
          nameResolver: () => authStateProvider.context.displayName,
        )
      : KycService(apiClient);

  final FilePickerServiceBase filePickerService = FilePickerService();

  // ============================================================
  // RUN APP
  // ============================================================

  runApp(
    NivasHubApp(
      localStorageService: localStorageService,

      secureStorageService: secureStorageService,

      connectivityService: connectivityService,

      apiClient: apiClient,

      forgotPasswordService: forgotPasswordService,

      dashboardRepository: dashboardRepository,

      quickActionsRepository: quickActionsRepository,

      searchService: searchService,

      settingsRepository: settingsRepository,

      // Profile repository
      profileRepository: profileRepository,

      // Auth entry / KYC
      authStateProvider: authStateProvider,

      authEntryService: authEntryService,

      countryService: countryService,

      locationService: locationService,

      registrationService: registrationService,

      societyService: societyService,

      otpVerificationService: otpVerificationService,

      documentService: documentService,

      kycService: kycService,

      filePickerService: filePickerService,

      notificationService: notificationService,
    ),
  );
}
