import 'package:flutter/material.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Shows a title/message confirmation dialog with confirm/cancel actions.
/// Returns `true` if the user confirmed, `false` otherwise (cancel, dismiss,
/// back button).
class ConfirmationDialog {
  ConfirmationDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = StringConstants.confirm,
    String cancelText = StringConstants.cancel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? AppColors.error : AppColors.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
