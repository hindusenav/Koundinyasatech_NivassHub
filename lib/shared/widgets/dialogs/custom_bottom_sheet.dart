import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Shows [child] in a modal bottom sheet with consistent padding (styling —
/// rounded top corners, drag handle — comes from `ThemeData.bottomSheetTheme`,
/// see `core/theme/app_theme.dart`). Automatically pads for the keyboard
/// when [child] contains a text field.
class CustomBottomSheet {
  CustomBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: AppSpacing.md + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
