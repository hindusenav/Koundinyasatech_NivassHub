import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'quick_action_card.dart';
import 'quick_actions_screen.dart'; // 1. Imported your QuickActionsScreen
import '../empty/section_empty.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final actions = provider.home?.data.quickActions ?? [];

    if (actions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SectionEmpty(
          icon: Icons.grid_view_outlined,
          title: 'No Quick Actions',
          message: 'Quick actions will appear here when available.',
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 900
        ? 6
        : width > 600
            ? 4
            : 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Added Header Row with "View All >" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => _navigateToQuickActionsScreen(context),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'View All >',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0061C3),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .78,
            ),
            itemBuilder: (context, index) {
              return QuickActionCard(
                action: actions[index],
                onTap: () {
                  _handleAction(
                    context,
                    actions[index].name,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 3. Updated handler to open QuickActionsScreen when "View More" is clicked
  void _handleAction(
    BuildContext context,
    String action,
  ) {
    switch (action) {
      case 'Pre-Approve':
        break;

      case 'Payments':
        break;

      case 'Posts':
        break;

      case 'Security':
        break;

      case 'Book Now':
        break;

      case 'Directory':
        break;

      case 'Free Trial':
        break;

      case 'View More':
      case 'View All':
        _navigateToQuickActionsScreen(context);
        break;
    }
  }

  // Helper method for navigation
  void _navigateToQuickActionsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuickActionsScreen(),
      ),
    );
  }
}