import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
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
            // Visitors
            break;

          case 2:
            // Community
            break;

          case 3:
            // Payments
            break;

          case 4:
            // More — opens the full Quick Actions catalog directly.
            Navigator.pushNamed(context, AppRoutes.quickActions);
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