import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// A centered loading spinner with an optional message underneath. Use for
/// full-screen/full-section loading states; use [ShimmerListPlaceholder]
/// instead for list content.
class Loader extends StatelessWidget {
  const Loader({super.key, this.message, this.size = AppDimensions.iconLg});

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            AppSpacing.gapMd,
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            ),
          ],
        ],
      ),
    );
  }
}
