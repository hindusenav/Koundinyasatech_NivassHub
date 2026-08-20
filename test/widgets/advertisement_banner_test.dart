import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/models/notices/advertisement_model.dart';
import 'package:flutter_nivasshub/widgets/notices/advertisement_banner.dart';

void main() {
  group('AdvertisementBanner Widget Test', () {
    const AdvertisementModel banner = AdvertisementModel(
      bannerId: '1',
      title: 'Festival Offer',
      image: 'https://picsum.photos/600/250',
      redirectUrl: 'https://google.com',
    );

    testWidgets('Should render AdvertisementBanner', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      expect(find.byType(AdvertisementBanner), findsOneWidget);
    });

    testWidgets('Should display banner title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      expect(find.text('Festival Offer'), findsOneWidget);
    });

    testWidgets('Should contain image widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Should contain InkWell', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('Tap banner', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(find.byType(AdvertisementBanner), findsOneWidget);
    });

    testWidgets('Widget tree builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AdvertisementBanner(advertisement: banner)),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
