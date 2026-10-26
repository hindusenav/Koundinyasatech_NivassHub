import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/onboarding/onboarding_screen_two.dart';
import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sizes = {
    '320x568': Size(320, 568),
    '360x640': Size(360, 640),
    '412x915': Size(412, 915),
    'tablet': Size(800, 1280),
  };

  for (final e in sizes.entries) {
    testWidgets('welcome renders without overflow at ${e.key}', (tester) async {
      tester.view.physicalSize = e.value;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('To Nivaas Hub'), findsOneWidget);
      expect(find.text('ONE COMMUNITY · ONE PLATFORM'), findsOneWidget);
      expect(find.text('Onboarding screen'), findsNothing);
      expect(find.text('Get Started'), findsNothing);

      // Let the auto-advance finish so no timer is left pending.
      await tester.pump(WelcomeScreen.displayDuration);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('onboarding two renders without overflow at ${e.key}',
        (tester) async {
      tester.view.physicalSize = e.value;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: OnboardingScreenTwo()));
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
  }

  testWidgets('welcome auto-advances to onboarding step two', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.pump(WelcomeScreen.displayDuration);
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(OnboardingScreenTwo), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsNothing);
    expect(AppRoutes.onboardingStepTwo, isNotEmpty);
  });
}
