import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/auth_router.dart';
import 'package:flutter_nivasshub/screens/auth/auth_entry_screen.dart';
import 'package:flutter_nivasshub/screens/auth/enter_password_screen.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_entry_service.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/file/mock_file_picker_service.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/mock_document_service.dart';
import 'package:flutter_nivasshub/services/kyc/mock_kyc_service.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/services/location/mock_location_service.dart';
import 'package:flutter_nivasshub/services/notifications/mock_notification_service.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/in_memory_secure_storage.dart';

/// Builds each new screen through the real router.
///
/// These exist because the unit tests exercise providers and services
/// directly and so never mount a widget — which let a provider that
/// notified listeners during `initState` (illegal once siblings are
/// already watching it in the same frame) reach a device before it was
/// caught. Pumping the route is the only thing that catches that class of
/// bug, so every new screen gets a build test.
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

  /// Mounts the app at [route] with the same global providers `app.dart`
  /// registers, and the same `AuthRouter` wiring, so the test exercises
  /// the real composition rather than a hand-built widget tree.
  Future<void> pumpRoute(
    WidgetTester tester,
    String route, {
    Object? arguments,
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
          Provider<LocationServiceBase>.value(value: MockLocationService()),
          Provider<DocumentServiceBase>.value(value: MockDocumentService()),
          Provider<KycServiceBase>.value(value: kycService),
          Provider<FilePickerServiceBase>.value(
            value: MockFilePickerService(),
          ),
          ChangeNotifierProvider<AuthStateProvider>.value(value: authState),
          ChangeNotifierProvider<KycProvider>(
            create: (context) => KycProvider(
              documentService: context.read<DocumentServiceBase>(),
              kycService: context.read<KycServiceBase>(),
              filePickerService: context.read<FilePickerServiceBase>(),
              localStorage: localStorage,
              authState: authState,
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: route,
          onGenerateRoute: (settings) => AuthRouter.generateRoute(
            RouteSettings(name: settings.name, arguments: arguments),
          ),
        ),
      ),
    );

    // Bounded pumps rather than `pumpAndSettle`: the mock latency is
    // 800 ms, and settling additionally requires every animation to stop,
    // which a blinking text cursor never does.
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  }

  /// The assertion that matters for these tests: building the route, and
  /// then letting its mock fetches resolve, must not throw.
  ///
  /// Deliberately not also asserting `hasScheduledFrame == false` — a
  /// scrollbar fading out or a text cursor blinking keeps frames
  /// scheduled quite legitimately, so that check fails on healthy
  /// screens.
  void expectSettled(WidgetTester tester) {
    expect(tester.takeException(), isNull);
  }

  const identifier = AuthIdentifier(
    raw: '9876543211',
    channel: AuthChannel.mobile,
    countryCode: '+91',
  );

  testWidgets('the authentication entry screen builds and loads dial codes',
      (tester) async {
    await pumpRoute(tester, AppRoutes.authEntry);

    expectSettled(tester);
    expect(find.byType(AuthEntryScreen), findsOneWidget);
    // The country picker is populated, so `loadCountryCodes` ran without
    // notifying during the build.
    expect(find.text('+91'), findsOneWidget);
  });

  testWidgets('the password screen builds with a masked identifier',
      (tester) async {
    await pumpRoute(
      tester,
      AppRoutes.enterPassword,
      arguments: const EnterPasswordScreenArgs(
        identifier: identifier,
        maskedIdentifier: '98*****211',
      ),
    );

    expectSettled(tester);
    expect(find.byType(EnterPasswordScreen), findsOneWidget);
    expect(find.text('98*****211'), findsOneWidget);
  });

  testWidgets('the user details screen builds with the whole cascade',
      (tester) async {
    await pumpRoute(
      tester,
      AppRoutes.userDetails,
      arguments: const UserDetailsScreenArgs(identifier: identifier),
    );

    // This is the regression: seven cascade fields watch LocationProvider
    // in the same frame the sub-branch field used to kick a fetch off
    // from `initState`, which marked them dirty mid-build.
    expectSettled(tester);
    expect(find.byType(UserDetailsScreen), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Flat Number'), findsOneWidget);
    expect(find.text('Sub-Branch'), findsOneWidget);
  });

  testWidgets('the KYC documents screen builds the owner document set',
      (tester) async {
    await pumpRoute(
      tester,
      AppRoutes.kycDocuments,
      arguments: const KycDocumentsScreenArgs(
        userId: 'USR1001',
        kycToken: 'mock_kyc_token',
        role: UserRole.owner,
      ),
    );

    expectSettled(tester);
    expect(find.byType(KycDocumentsScreen), findsOneWidget);
    expect(find.text('Address Proof — Document 1'), findsOneWidget);
    expect(find.text('Registration Proof'), findsOneWidget);
    expect(find.text('Rental Agreement'), findsNothing);
  });

  testWidgets('the KYC documents screen builds the tenant document set',
      (tester) async {
    await pumpRoute(
      tester,
      AppRoutes.kycDocuments,
      arguments: const KycDocumentsScreenArgs(
        userId: 'USR1001',
        kycToken: 'mock_kyc_token',
        role: UserRole.tenant,
      ),
    );

    expectSettled(tester);
    expect(find.text('Rental Agreement'), findsOneWidget);
    expect(find.text('Registration Proof'), findsNothing);
  });
}
