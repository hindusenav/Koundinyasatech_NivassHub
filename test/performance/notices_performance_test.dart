import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';

void main() {
  group('Performance Tests', () {
    late NoticesProvider provider;

    setUp(() {
      provider = NoticesProvider(apiClient: ApiClient());
    });

    test('loadFeed should complete within acceptable time', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await provider.loadFeed();
      } catch (_) {}

      stopwatch.stop();

      debugPrint('Load Feed Time: ${stopwatch.elapsedMilliseconds} ms');

      expect(stopwatch.elapsedMilliseconds < 5000, true);
    });

    test('refreshFeed should complete within acceptable time', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await provider.refreshFeed();
      } catch (_) {}

      stopwatch.stop();

      debugPrint('Refresh Time: ${stopwatch.elapsedMilliseconds} ms');

      expect(stopwatch.elapsedMilliseconds < 5000, true);
    });
  });
}
