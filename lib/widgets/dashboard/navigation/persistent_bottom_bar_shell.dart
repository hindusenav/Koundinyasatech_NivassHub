import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

/// Hosts the bottom navigation bar once, *above* the Navigator, so switching
/// tabs only swaps the page content: the bar is never rebuilt per route, never
/// slides with a page transition and so never "shakes".
///
/// The bar shows only while a main tab screen is on top
/// ([DashboardNavigationProvider.showBottomBar]) and while the keyboard is
/// closed. [child] stays at the same position in the tree in every state so
/// the Navigator keeps its state.
class PersistentBottomBarShell extends StatelessWidget {
  const PersistentBottomBarShell({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final showBar = context.select<DashboardNavigationProvider, bool>(
      (p) => p.showBottomBar,
    );
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final visible = showBar && !keyboardOpen;

    return Column(
      children: [
        Expanded(
          // The bar already owns the bottom safe area; stop screens from
          // reserving it a second time.
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: visible,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        if (visible)
          const Material(
            color: Colors.transparent,
            child: DashboardBottomNavigation(),
          ),
      ],
    );
  }
}
