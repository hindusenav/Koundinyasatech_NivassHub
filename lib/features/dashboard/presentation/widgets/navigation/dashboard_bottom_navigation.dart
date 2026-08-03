import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_navigation_provider.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardNavigationProvider>();

    return NavigationBar(
      selectedIndex: provider.selectedIndex,
      height: 72,
      elevation: 8,
      labelBehavior:
          NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        provider.changeIndex(index);

        switch (index) {
          case 0:
            // Home
            break;

          case 1:
            // Community
            break;

          case 2:
            // Notifications
            break;

          case 3:
            // Profile
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups),
          label: 'Community',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}