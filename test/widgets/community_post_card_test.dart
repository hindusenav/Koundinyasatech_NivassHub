import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/features/notices/models/community_post_model.dart';
import 'package:flutter_nivasshub/features/notices/widgets/community_post_card.dart';

void main() {
  group('CommunityPostCard Widget Test', () {
    const CommunityPostModel post = CommunityPostModel(
      id: '1',
      userName: 'John Doe',
      profileImage: 'https://picsum.photos/100',
      content: 'Welcome to NivassHub Community!',
      createdAt: '2026-08-04',
      likes: 25,
      comments: 8,
    );

    testWidgets('Should render CommunityPostCard', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.byType(CommunityPostCard), findsOneWidget);
    });

    testWidgets('Should display username', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Should display content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.text('Welcome to NivassHub Community!'), findsOneWidget);
    });

    testWidgets('Should display likes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('Should display comments', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('Should contain CircleAvatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('Should contain Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Widget tree builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Tap card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommunityPostCard(post: post)),
        ),
      );

      await tester.tap(find.byType(CommunityPostCard));
      await tester.pump();

      expect(find.byType(CommunityPostCard), findsOneWidget);
    });
  });
}
