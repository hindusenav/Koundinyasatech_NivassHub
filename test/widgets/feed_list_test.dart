import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/features/notices/models/advertisement_model.dart';
import 'package:flutter_nivasshub/features/notices/models/community_post_model.dart';
import 'package:flutter_nivasshub/features/notices/models/feed_item_model.dart';
import 'package:flutter_nivasshub/features/notices/models/notice_model.dart';

import 'package:flutter_nivasshub/features/notices/widgets/feed_list.dart';

void main() {
  final List<FeedItemModel> feedItems = [
    FeedItemModel.advertisement(
      const AdvertisementModel(
        bannerId: '1',
        title: 'Festival Offer',
        image: 'https://picsum.photos/600/250',
        redirectUrl: 'https://google.com',
      ),
    ),

    FeedItemModel.communityPost(
      const CommunityPostModel(
        id: '1',
        userName: 'John Doe',
        profileImage: 'https://picsum.photos/100',
        content: 'Welcome to NivassHub!',
        createdAt: '04 Aug 2026',
        likes: 20,
        comments: 5,
      ),
    ),

    FeedItemModel.notice(
      const NoticeModel(
        id: '1',
        title: 'Water Maintenance',
        description: 'Water supply unavailable tomorrow.',
        date: '04 Aug 2026',
        attachment: '',
      ),
    ),
  ];

  group('FeedList Widget Test', () {
    testWidgets('Should render FeedList', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.byType(FeedList), findsOneWidget);
    });

    testWidgets('Should build ListView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Should display advertisement', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.text('Festival Offer'), findsOneWidget);
    });

    testWidgets('Should display community post', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Should display notice', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.text('Water Maintenance'), findsOneWidget);
    });

    testWidgets('Should render all feed items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('FeedList builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Scroll FeedList', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedList(feedItems: feedItems)),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -300));

      await tester.pump();

      expect(find.byType(FeedList), findsOneWidget);
    });

    testWidgets('Empty FeedList', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FeedList(feedItems: [])),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
