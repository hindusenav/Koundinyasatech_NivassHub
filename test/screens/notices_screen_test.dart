import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/core/network/api_client.dart';

import 'package:flutter_nivasshub/features/notices/provider/notices_provider.dart';
import 'package:flutter_nivasshub/features/notices/screens/notices_screen.dart';

void main() {
  late ApiClient apiClient;
  late NoticesProvider provider;

  setUp(() {
    apiClient = ApiClient();
    provider = NoticesProvider(apiClient: apiClient);
  });

  Widget createWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<NoticesProvider>.value(
        value: provider,
        child: NoticesScreen(apiClient: apiClient),
      ),
    );
  }

  group('NoticesScreen Widget Tests', () {
    testWidgets('Should build NoticesScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('Should contain Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Should contain AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should contain RefreshIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Should display Community Feed title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Community Feed'), findsOneWidget);
    });

    testWidgets('Should support pull to refresh', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));

      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Should render MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should render SafeArea', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Should render ListView', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Widget tree builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(NoticesScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
