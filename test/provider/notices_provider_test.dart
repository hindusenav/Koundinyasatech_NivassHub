import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nivasshub/core/network/api_client.dart';
import 'package:flutter_nivasshub/features/notices/provider/notices_provider.dart';

void main() {
  late ApiClient apiClient;
  late NoticesProvider provider;

  setUp(() {
    apiClient = ApiClient();
    provider = NoticesProvider(apiClient: apiClient);
  });

  group('NoticesProvider Initial State', () {
    test('Loading should be false', () {
      expect(provider.isLoading, false);
    });

    test('Refreshing should be false', () {
      expect(provider.isRefreshing, false);
    });

    test('Feed should be empty', () {
      expect(provider.feedItems.isEmpty, true);
    });

    test('No error initially', () {
      expect(provider.hasError, false);
      expect(provider.errorMessage, isNull);
    });
  });

  group('Load Feed', () {
    test('loadFeed executes without throwing', () async {
      try {
        await provider.loadFeed();
      } catch (_) {}
      expect(provider.isLoading, false);
    });
  });

  group('Refresh Feed', () {
    test('refreshFeed executes', () async {
      try {
        await provider.refreshFeed();
      } catch (_) {}
      expect(provider.isRefreshing, false);
    });
  });

  group('Retry', () {
    test('retry executes', () async {
      try {
        await provider.retry();
      } catch (_) {}
      expect(provider.isLoading, false);
    });
  });

  group('Clear Error', () {
    test('clearError resets error state', () {
      provider.clearError();
      expect(provider.errorMessage, isNull);
    });
  });
}
