import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';

class SectionEmpty extends StatelessWidget {
  const SectionEmpty({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            // No explicit color here — it inherits from the ambient
            // Theme's text style, which is already brightness-aware.
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}