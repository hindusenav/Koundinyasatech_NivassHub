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
}
