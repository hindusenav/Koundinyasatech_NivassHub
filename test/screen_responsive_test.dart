import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/auth_router.dart';
import 'package:flutter_nivasshub/screens/auth/enter_password_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_mobile_email_verification_screen.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_entry_service.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/services/country/mock_country_service.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/file/mock_file_picker_service.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/mock_kyc_service.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/services/location/mock_location_service.dart';
import 'package:flutter_nivasshub/services/notifications/mock_notification_service.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_nivasshub/widgets/shared/common/responsive_shell.dart';

import 'support/fake_document_service.dart';
import 'support/fake_otp_verification_service.dart';
import 'support/fake_registration_service.dart';
import 'support/fake_society_service.dart';
import 'support/in_memory_secure_storage.dart';

/// Logical sizes of real devices, smallest to largest.
const _devices = <String, Size>{
  'iPhone SE (1st)': Size(320, 568),
  'Small Android': Size(360, 640),
  'iPhone 13 mini': Size(375, 812),
  'iPhone 15': Size(393, 852),
  'Pixel 7': Size(412, 915),
  'iPhone Pro Max': Size(430, 932),
  'Foldable unfolded': Size(673, 841),
  'iPad': Size(820, 1180),
};

/// Mounts the real auth screens (real router, real providers, mock
/// services) inside [ResponsiveShell] at every device size and with large
/// system text, and fails on any layout overflow or build exception.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService localStorage;
  late SecureStorageService secureStorage;
  late AuthStateProvider authState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localStorage = LocalStorageService();
    await localStorage.init();
    secureStorage = SecureStorageService(storage: InMemorySecureStorage());
    authState = AuthStateProvider(
      localStorage: localStorage,
      secureStorage: secureStorage,
    );
  });

  Future<void> pumpRoute(
    WidgetTester tester,
    String route, {
    Object? arguments,
    double textScale = 1,
  }) async {
    final notificationService = MockNotificationService(localStorage);
    final kycService = MockKycService(
      storage: localStorage,
      notificationService: notificationService,
      recipientResolver: () => 'resident@example.com',
      nameResolver: () => 'Test Resident',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorageService>.value(value: localStorage),
          Provider<SecureStorageService>.value(value: secureStorage),
          Provider<AuthEntryServiceBase>.value(value: MockAuthEntryService()),
          Provider<CountryServiceBase>.value(value: const MockCountryService()),
          Provider<LocationServiceBase>.value(value: MockLocationService()),
          Provider<RegistrationServiceBase>.value(
            value: const FakeRegistrationService(),
          ),
          Provider<SocietyServiceBase>.value(value: const FakeSocietyService()),
          Provider<OtpVerificationServiceBase>.value(
            value: const FakeOtpVerificationService(),
          ),
          Provider<DocumentServiceBase>.value(value: FakeDocumentService()),
          Provider<KycServiceBase>.value(value: kycService),
          Provider<FilePickerServiceBase>.value(value: MockFilePickerService()),
          ChangeNotifierProvider<AuthStateProvider>.value(value: authState),
          ChangeNotifierProvider<KycProvider>(
            create: (context) => KycProvider(
              documentService: context.read<DocumentServiceBase>(),
              kycService: context.read<KycServiceBase>(),
              filePickerService: context.read<FilePickerServiceBase>(),
              authState: authState,
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: route,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: ResponsiveShell(child: child!),
          ),
          onGenerateRoute: (settings) => AuthRouter.generateRoute(
            RouteSettings(name: settings.name, arguments: arguments),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  }

  const identifier = AuthIdentifier(
    raw: '9876543211',
    channel: AuthChannel.mobile,
    countryCode: '+91',
  );

  final screens = <String, ({String route, Object? args})>{
    'welcome': (route: AppRoutes.authEntry, args: null),
    'password': (
      route: AppRoutes.enterPassword,
      args: const EnterPasswordScreenArgs(
        identifier: identifier,
        maskedIdentifier: '98*****211',
      ),
    ),
    'user details': (
      route: AppRoutes.userDetails,
      args: const UserDetailsScreenArgs(identifier: identifier),
    ),
    'otp verification': (
      route: AppRoutes.otpMobileEmailVerification,
      args: const OtpMobileEmailVerificationScreenArgs(
        userId: 'encrypted-user-id',
        email: 'charan@example.com',
        mobileNumber: '9876543212',
        role: UserRole.owner,
      ),
    ),
  };

  for (final screen in screens.entries) {
    for (final device in _devices.entries) {
      for (final textScale in [1.0, 1.3]) {
        testWidgets(
          '${screen.key} fits ${device.key} @ text ${textScale}x',
          (tester) async {
            tester.view.physicalSize = device.value * 2;
            tester.view.devicePixelRatio = 2;
            addTearDown(tester.view.reset);

            await pumpRoute(
              tester,
              screen.value.route,
              arguments: screen.value.args,
              textScale: textScale,
            );

            expect(tester.takeException(), isNull);

            // Unmount so screen-owned periodic timers are cancelled.
            await tester.pumpWidget(const SizedBox.shrink());
          },
        );
      }
    }
  }
}
