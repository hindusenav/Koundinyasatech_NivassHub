import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'quick_action_card.dart';
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
      message:
          'Quick actions will appear here when available.',
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .88,
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
        break;
    }
  }
}