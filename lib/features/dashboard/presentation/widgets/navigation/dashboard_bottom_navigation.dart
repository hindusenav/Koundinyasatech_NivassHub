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

    final selectedIndex = provider?.selectedIndex ?? 0;

    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 68,
      backgroundColor: const Color(0xFFE0F2FE),
      elevation: 0,
      indicatorColor: const Color(0xFF2563EB),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        if (provider != null) {
          provider.changeIndex(index);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.black87),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.black87),
          selectedIcon: Icon(Icons.person, color: Colors.white),
          label: 'Visitors',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_outlined, color: Colors.black87),
          selectedIcon: Icon(Icons.groups, color: Colors.white),
          label: 'Community',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.black87),
          selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.white),
          label: 'Payments',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu, color: Colors.black87),
          selectedIcon: Icon(Icons.menu, color: Colors.white),
          label: 'More',
        ),
      ],
    );
  }
}
