import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.buttonText,
    this.onPressed,
  });

  final IconData? icon;
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.padding24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_rounded,
                size: 55,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppDimensions.padding24),

            Text(
              title ?? AppStrings.noData,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppDimensions.padding12),

            Text(
              message ??
                  "There are no advertisements, notices or community posts available.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: AppDimensions.padding24),

              SizedBox(
                width: 180,
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.refresh),
                  label: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
