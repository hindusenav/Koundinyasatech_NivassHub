import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/core/api/base_api.dart';

import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ApiClient apiClient;

  setUp(() {
    apiClient = ApiClient();
  });

  Widget createApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoticesProvider(apiClient: apiClient),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoticesScreen(apiClient: apiClient),
      ),
    );
  }

  group('Community Feed & Notices Integration Test', () {
    testWidgets('Launch application', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('Verify AppBar', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Verify RefreshIndicator', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Pull To Refresh', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 400));

      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Scroll Feed', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -700));

      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Verify FeedList', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Tap Screen', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(200, 300));

      await tester.pump();

      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('Landscape Mode', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);

      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('Application should not crash', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Complete User Flow', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -600));

      await tester.pump();

      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 400));

      await tester.pumpAndSettle();

      expect(find.byType(NoticesScreen), findsOneWidget);
    });
  });
}
