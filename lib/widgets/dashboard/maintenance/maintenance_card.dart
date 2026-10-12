import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = FigmaColors.of(context);
    final provider = context.watch<DashboardProvider>();

    final message = provider.home?.data.maintenanceMessage ??
        'Visitor maintenance scheduled at 11 AM.';

    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: t.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark ? t.body : FigmaColors.accentBlue,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? t.body : FigmaColors.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}