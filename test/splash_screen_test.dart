import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/screens/splash/splash_screen.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/in_memory_secure_storage.dart';

class _FakeAuthState extends AuthStateProvider {
  _FakeAuthState({required super.localStorage, required super.secureStorage});

  int resolveCalls = 0;

  @override
  Future<AuthStartDestination> resolveStartDestination() async {
    resolveCalls++;
    return const AuthStartDestination('/next');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plays once for 3600ms then navigates exactly once', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final localStorage = LocalStorageService();
    await localStorage.init();
    final auth = _FakeAuthState(
      localStorage: localStorage,
      secureStorage: SecureStorageService(storage: InMemorySecureStorage()),
    );

    var nextBuilds = 0;
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthStateProvider>.value(
        value: auth,
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          home: const SplashScreen(),
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) {
              nextBuilds++;
              return const Scaffold(body: Text('next'));
            },
          ),
        ),
      ),
    );

    // Destination resolves in parallel with the animation.
    expect(auth.resolveCalls, 1);

    // Let the SVG warm-up finish and the controller start.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();

    double opacity() =>
        tester.widget<Opacity>(find.byType(Opacity).first).opacity;

    Color? bg() =>
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor;

    await tester.pump(const Duration(milliseconds: 50));
    expect(bg(), AppColors.splashBackgroundNavy);
    expect(opacity(), 0.0);

    await tester.pump(const Duration(milliseconds: 950));
    expect(opacity(), inExclusiveRange(0.0, 1.0));
    expect(bg(), isNot(AppColors.splashBackgroundNavy));

    await tester.pump(const Duration(milliseconds: 500));
    expect(opacity(), 1.0);
    expect(find.text('next'), findsNothing);

    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();

    expect(find.text('next'), findsOneWidget);
    expect(nextBuilds, 1);
    expect(auth.resolveCalls, 1);
  });
}
