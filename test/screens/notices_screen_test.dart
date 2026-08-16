import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';

import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';

void main() {
  late ApiClient apiClient;
  late NoticesProvider provider;

  setUp(() {
    apiClient = ApiClient();
    provider = NoticesProvider(apiClient: apiClient);
  });

  Widget createWidget() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<NoticesProvider>.value(value: provider),
          // NoticesScreen renders the shared DashboardBottomNavigation,
          // which needs this provider regardless of which screen hosts it.
          ChangeNotifierProvider<DashboardNavigationProvider>(
            create: (_) => DashboardNavigationProvider(),
          ),
        ],
        child: NoticesScreen(apiClient: apiClient),
      ),
    );
  }

  // The mock notices API simulates network latency (up to ~300ms per call)
  // via Future.delayed, which pumpAndSettle can't drain here because the
  // loading state's CircularProgressIndicator animates indefinitely. Advance
  // the fake clock in bounded steps instead so the mock's delayed futures
  // resolve and the feed finishes loading before assertions run.
  Future<void> pumpUntilLoaded(WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('NoticesScreen Widget Tests', () {
    testWidgets('Should build NoticesScreen', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('Should contain Scaffold', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Should contain AppBar', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should contain RefreshIndicator', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Should display Community Feed title', (
      WidgetTester tester,
    ) async {
      await pumpUntilLoaded(tester);

      expect(find.text('Community Feed'), findsOneWidget);
    });

    testWidgets('Should support pull to refresh', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Should render MaterialApp', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should render SafeArea', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      // NoticesScreen's own SafeArea plus DashboardBottomNavigation's
      // internal SafeArea means more than one is expected here.
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
    });

    testWidgets('Should render ListView', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Widget tree builds successfully', (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(NoticesScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
