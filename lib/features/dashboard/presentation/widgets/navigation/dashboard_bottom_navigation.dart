import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_navigation_provider.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardNavigationProvider? provider;
    try {
      provider = Provider.of<DashboardNavigationProvider>(
        context,
        listen: true,
      );
    } catch (_) {
      // Safely handled if opened outside Dashboard scope
    }

    final selectedIndex = provider?.selectedIndex ?? 2;

    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 72,
      elevation: 8,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        if (provider != null) {
          provider.changeIndex(index);
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.badge_outlined),
          selectedIcon: Icon(Icons.badge),
          label: 'Visitors',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups),
          label: 'Community',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments_outlined),
          selectedIcon: Icon(Icons.payments),
          label: 'Payments',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          selectedIcon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}
