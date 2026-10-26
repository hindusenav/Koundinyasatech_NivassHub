import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_shadows.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

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
    final t = FigmaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (actions.isEmpty) {
      return const SectionEmpty(
        icon: Icons.grid_view_outlined,
        title: 'No Quick Actions',
        message: 'Quick actions will appear here when available.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.cardBorder),
        boxShadow: isDark ? null : AppShadows.card,
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: [
            Expanded(
              child: Text(
                "Quick actions",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: t.heading,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.quickActions),
              borderRadius: BorderRadius.circular(4),
              child: Text(
                "Customize",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.orange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 98,
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
      ),
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
