import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/connectivity/connectivity_provider.dart';
import 'package:flutter_nivasshub/screens/connectivity/no_internet_screen.dart';

/// Wraps [MaterialApp]'s `builder` `child` (the real `Navigator`/current
/// route) and draws [NoInternetScreen] on top of it whenever
/// [ConnectivityProvider.shouldShowNoInternetScreen] is `true` — i.e. the
/// device is offline and the splash screen's own animation has already
/// finished. The underlying screen is never popped or rebuilt — it's just
/// hidden under the overlay for as long as the device is offline, so
/// restoring connectivity reveals it exactly as it was.
class NoInternetOverlay extends StatelessWidget {
  const NoInternetOverlay({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final shouldShow =
        context.watch<ConnectivityProvider>().shouldShowNoInternetScreen;

    return Stack(
      children: [
        child ?? const SizedBox.shrink(),
        if (shouldShow) const Positioned.fill(child: NoInternetScreen()),
      ],
    );
  }
}
