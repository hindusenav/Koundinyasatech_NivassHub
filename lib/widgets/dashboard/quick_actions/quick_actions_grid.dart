import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/section_empty.dart';
import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          children: [
            Expanded(
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700, // Thicker
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Icon(
              Icons.settings_outlined,
              size: 14,
              color: Color(0xFF000000),
              weight: 600, // Thicker icon
            ),
            const SizedBox(width: 4),
            Text(
              "Customize",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700, // Thicker
                color: Color(0xFF000000),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 8,
            mainAxisExtent: 94,
          ),
          itemBuilder: (context, index) {
            return QuickActionCard(
              action: actions[index],
              onTap: () {
                _handleAction(context, actions[index].name);
              },
            );
          },
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'Pre-Approve':
        // case 'Pre-Approve':

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
