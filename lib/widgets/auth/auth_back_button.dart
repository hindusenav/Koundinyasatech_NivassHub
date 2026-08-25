import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';

/// Small translucent circular back button overlaid on the auth screens'
/// gradient background — shared by the Login and OTP Verification screens.
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: (isDark ? AppColors.surfaceDark : AppColors.white).withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(AppIcons.back, size: AppDimensions.iconSm),
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
    );
  }
}
