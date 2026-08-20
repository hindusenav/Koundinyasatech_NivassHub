import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/section_empty.dart';
import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final actions = provider.home?.data.quickActions ?? [];

    if (actions.isEmpty) {
      return const SectionEmpty(
        icon: Icons.grid_view_outlined,
        title: 'No Quick Actions',
        message: 'Quick actions will appear here when available.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: const [
            Expanded(
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Icon(
              Icons.settings_outlined,
              size: 14,
              color: Color(0xFF0284C7),
            ),
            SizedBox(width: 4),
            Text(
              "Customize",
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0284C7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            mainAxisExtent: 96,
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
        Navigator.pushNamed(context, AppRoutes.quickActions);
        break;
    }
  }
}
