import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
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
    testWidgets('renders without overflow at ${e.key}', (tester) async {
      tester.view.physicalSize = e.value;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('To NivaasHub'), findsOneWidget);
    });
  }

  testWidgets('Get Started pushes onboarding step two', (tester) async {
    String? pushed;
    await tester.pumpWidget(MaterialApp(
      home: const WelcomeScreen(),
      onGenerateRoute: (s) {
        pushed = s.name;
        return MaterialPageRoute<void>(builder: (_) => const SizedBox());
      },
    ));
    await tester.tap(find.text('Get Started'));
    await tester.pump();
    expect(pushed, AppRoutes.onboardingStepTwo);
  });
}
