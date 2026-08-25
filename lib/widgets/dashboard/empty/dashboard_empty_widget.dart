import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';

class DashboardEmptyWidget extends StatelessWidget {
  const DashboardEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 200),

        Icon(
          Icons.inbox_outlined,
          size: 70,
          color: isDark ? AppColors.textSecondaryDark : Colors.grey,
        ),

        const SizedBox(height: 20),

        // No explicit text color here — it inherits from the ambient
        // Theme's text style, which is already brightness-aware.
        const Center(
          child: Text(
            'No Dashboard Data Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}