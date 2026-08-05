import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import '../empty/section_empty.dart';
import 'quick_action_card.dart';

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
        const Row(
          children: [
            Expanded(
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1F2937),
                ),
              ),
            ),
            Icon(
              Icons.settings_outlined,
              size: 15,
              color: Color(0xff64748B),
            ),
            SizedBox(width: 4),
            Text(
              "Customize",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xff64748B),
              ),
            ),
          ],
        ),

        SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 96,
          ),
          itemBuilder: (context, index) {
            return QuickActionCard(
              action: actions[index],
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}