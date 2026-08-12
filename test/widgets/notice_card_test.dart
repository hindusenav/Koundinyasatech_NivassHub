import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/features/notices/models/feed_notice_model.dart';
import 'package:flutter_nivasshub/features/notices/widgets/notice_card.dart';

void main() {
  group('NoticeCard Widget Test', () {
    const FeedNoticeModel notice = FeedNoticeModel(
      id: '1',
      title: 'Water Supply Maintenance',
      description: 'Water supply will be unavailable from 10:00 AM to 2:00 PM.',
      date: '04 Aug 2026',
      attachment: '',
    );

    testWidgets('Should render NoticeCard', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.byType(NoticeCard), findsOneWidget);
    });

    testWidgets('Should display notice title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.text('Water Supply Maintenance'), findsOneWidget);
    });

    testWidgets('Should display description', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(
        find.text('Water supply will be unavailable from 10:00 AM to 2:00 PM.'),
        findsOneWidget,
      );
    });

    testWidgets('Should display date', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.text('04 Aug 2026'), findsOneWidget);
    });

    testWidgets('Should contain Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Should contain ListTile', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('Should contain Icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('Widget tree builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Tap NoticeCard', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NoticeCard(notice: notice)),
        ),
      );

      await tester.tap(find.byType(NoticeCard));
      await tester.pump();

      expect(find.byType(NoticeCard), findsOneWidget);
    });
  });
}
