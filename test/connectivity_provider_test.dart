import 'dart:async';

import 'package:flutter_nivasshub/providers/connectivity/connectivity_provider.dart';
import 'package:flutter_nivasshub/services/connectivity/connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConnectivityService extends ConnectivityService {
  _FakeConnectivityService(this.results);

  /// Answers handed out in order; the last one repeats.
  final List<bool> results;
  int calls = 0;
  final events = StreamController<bool>.broadcast();

  @override
  Stream<bool> get onConnectivityChanged => events.stream;

  @override
  Future<bool> hasInternetAccess({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final i = calls < results.length ? calls : results.length - 1;
    calls++;
    return results[i];
  }
}

void main() {
  ConnectivityProvider build(_FakeConnectivityService s) => ConnectivityProvider(
    connectivityService: s,
    failureRetryDelay: const Duration(milliseconds: 10),
    offlineRecheckInterval: const Duration(milliseconds: 40),
  );

  test('a single failed probe does not flip offline', () async {
    // initial check fails once, the confirming probe succeeds.
    final service = _FakeConnectivityService([false, true]);
    final provider = build(service);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(provider.isOffline, isFalse);
    provider.dispose();
  });

  test('two consecutive failures flip offline, then it recovers on its own',
      () async {
    final service = _FakeConnectivityService([false, false, true]);
    final provider = build(service);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(provider.isOffline, isTrue);

    // periodic re-check finds the network again and clears the flag.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(provider.isOffline, isFalse);
    provider.dispose();
  });

  test('a stale slow check cannot overwrite a newer result', () async {
    final service = _FakeConnectivityService([true]);
    final provider = build(service);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(provider.isOffline, isFalse);
    expect(await provider.checkConnection(), isTrue);
    expect(provider.isChecking, isFalse);
    provider.dispose();
  });
}
