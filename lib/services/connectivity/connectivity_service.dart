import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_nivasshub/core/api/endpoints.dart';

/// Wraps [Connectivity] to expose a simple `bool` connectivity signal
/// instead of the raw platform result list — feature code shouldn't need
/// to know about [ConnectivityResult] at all.
class ConnectivityService {
  ConnectivityService({
    Connectivity? connectivity,
    Future<bool> Function(Duration timeout)? probe,
  }) : _connectivity = connectivity ?? Connectivity(),
       _probe = probe ?? _defaultProbe;

  final Connectivity _connectivity;
  final Future<bool> Function(Duration timeout) _probe;

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

  /// A genuine reachability probe rather than adapter/radio status alone — a
  /// device can be on Wi-Fi/mobile data while having no real internet access
  /// (captive portal, dead router).
  ///
  /// Succeeds as soon as *any* target answers: the app's own backend (TCP
  /// connect) or a public DNS name. A single blocked host (a network that
  /// filters Google, a LAN-only dev server) therefore never reads as offline.
  Future<bool> hasInternetAccess({
    Duration timeout = const Duration(seconds: 4),
  }) => _probe(timeout);

  static Future<bool> _defaultProbe(Duration timeout) {
    final backend = Uri.tryParse(ApiEndpoints.baseUrl);
    final probes = <Future<bool> Function()>[
      if (backend != null && backend.host.isNotEmpty)
        () => _canConnect(
          backend.host,
          backend.hasPort
              ? backend.port
              : (backend.scheme == 'https' ? 443 : 80),
          timeout,
        ),
      () => _canResolve('google.com', timeout),
      () => _canResolve('cloudflare.com', timeout),
    ];
    return _anySucceeds(probes);
  }

  /// Runs every probe concurrently; completes `true` on the first success,
  /// or `false` once all have failed.
  static Future<bool> _anySucceeds(List<Future<bool> Function()> probes) {
    final completer = Completer<bool>();
    var pending = probes.length;
    for (final run in probes) {
      run().then<void>((ok) {
        if (ok && !completer.isCompleted) completer.complete(true);
      }).whenComplete(() {
        pending--;
        if (pending == 0 && !completer.isCompleted) completer.complete(false);
      });
    }
    return completer.future;
  }

  static Future<bool> _canConnect(
    String host,
    int port,
    Duration timeout,
  ) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _canResolve(String host, Duration timeout) async {
    try {
      final result = await InternetAddress.lookup(host).timeout(timeout);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
