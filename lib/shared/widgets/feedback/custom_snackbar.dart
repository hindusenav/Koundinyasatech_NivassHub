import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';

enum SnackbarType { success, error, info, warning }

/// Shows a colored, icon-led snackbar for the given [SnackbarType]. Prefer
/// the [success]/[error]/[info]/[warning] shortcuts at call sites.
class CustomSnackbar {
  CustomSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    final (Color color, IconData icon) = switch (type) {
      SnackbarType.success => (AppColors.success, AppIcons.success),
      SnackbarType.error => (AppColors.error, AppIcons.error),
      SnackbarType.warning => (AppColors.warning, AppIcons.warning),
      SnackbarType.info => (AppColors.info, AppIcons.info),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppConstants.snackbarDuration,
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: AppDimensions.iconSm),
              AppSpacing.gapWSm,
              Expanded(
                child: Text(message, style: const TextStyle(color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.error);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.info);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: SnackbarType.warning);
}
