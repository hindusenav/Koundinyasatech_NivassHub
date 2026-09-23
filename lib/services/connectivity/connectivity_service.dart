import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps [Connectivity] to expose a simple `bool` connectivity signal
/// instead of the raw platform result list — feature code shouldn't need
/// to know about [ConnectivityResult] at all.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  /// Emits `true`/`false` whenever connectivity changes.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Performs a genuine internet-reachability probe (a DNS lookup), rather
  /// than trusting adapter/radio status alone — a device can be connected to
  /// Wi-Fi/mobile data (so [isConnected] reports `true`) while still having
  /// no real internet access (e.g. a captive portal or a dead router).
  Future<bool> hasInternetAccess({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final result =
          await InternetAddress.lookup('google.com').timeout(timeout);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
