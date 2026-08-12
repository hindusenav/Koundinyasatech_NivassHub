import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class DashboardWelcomeHeader extends StatelessWidget {
  const DashboardWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PROFILE ICON
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint('PROFILE ICON CLICKED');

            Navigator.pushNamed(
              context,
              AppRoutes.profile,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: AppDimensions.avatarSm / 2,
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.12),
              child: Icon(
                AppIcons.profile,
                color: AppColors.primary,
                size: AppDimensions.iconSm,
              ),
            ),
          ),
        ),

        AppSpacing.gapWMd,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              Text(
                'NivasHub',
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}