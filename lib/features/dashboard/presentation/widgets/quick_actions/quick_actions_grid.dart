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
        /// 🔥 HEADER
        Row(
          children: const [
            Expanded(
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1F2937),
                ),
              ),
            ),
            Icon(
              Icons.settings_outlined,
              size: 16,
              color: Color(0xff64748B),
            ),
            SizedBox(width: 4),
            Text(
              "Customize",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff64748B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// 🔥 GRID (IMPROVED)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,

            /// 🔥 BETTER SPACING
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,

            /// 🔥 MORE HEIGHT FOR BIGGER CARDS
            mainAxisExtent: 110,
          ),
          itemBuilder: (context, index) {
            return QuickActionCard(
              action: actions[index],
              onTap: () {
                /// 👉 handle click here if needed
              },
            );
          },
        ),
      ],
    );
  }
}