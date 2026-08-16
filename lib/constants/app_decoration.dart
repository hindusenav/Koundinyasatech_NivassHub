import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_shadows.dart';

/// Border/background state for input-like containers (see [AppDecoration.inputContainer]).
enum InputFieldState { normal, focused, error, disabled }

/// Central `BoxDecoration` presets that combine [AppColors], [AppRadius], and
/// [AppShadows]. Widgets should build their container decoration from here
/// rather than constructing `BoxDecoration(...)` inline.
class AppDecoration {
  AppDecoration._();

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Flat card: surface color + rounded corners, no shadow.
  static BoxDecoration card(BuildContext context) {
    final isDark = _isDark(context);
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: AppRadius.radiusMd,
      border: Border.all(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        width: 1,
      ),
    );
  }

  /// Elevated card: surface color + rounded corners + shadow (used for
  /// [DashboardCard] and similar highlighted containers).
  static BoxDecoration elevatedCard(BuildContext context) {
    final isDark = _isDark(context);
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: AppRadius.radiusMd,
      boxShadow: isDark ? AppShadows.darkMd : AppShadows.md,
    );
  }

  /// Bottom sheet container: rounded top corners only.
  static BoxDecoration bottomSheet(BuildContext context) {
    final isDark = _isDark(context);
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: AppRadius.topLg,
    );
  }

  /// Pill-shaped tinted background, used by `StatusChip` — pass the semantic
  /// color (e.g. `AppColors.success`) and get a matching soft background.
  static BoxDecoration statusPill(Color color) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: AppRadius.radiusFull,
      border: Border.all(color: color.withValues(alpha: 0.4)),
    );
  }

  /// Container decoration for custom input fields, keyed by focus/error/
  /// disabled state so `CustomTextField` doesn't hardcode border colors.
  static BoxDecoration inputContainer(
    BuildContext context, {
    InputFieldState state = InputFieldState.normal,
  }) {
    final isDark = _isDark(context);

    Color borderColor;
    double borderWidth = 1;
    switch (state) {
      case InputFieldState.normal:
        borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
        break;
      case InputFieldState.focused:
        borderColor = AppColors.primary;
        borderWidth = 2;
        break;
      case InputFieldState.error:
        borderColor = AppColors.error;
        borderWidth = 2;
        break;
      case InputFieldState.disabled:
        borderColor = isDark ? AppColors.grey700 : AppColors.grey200;
        break;
    }

    return BoxDecoration(
      color: state == InputFieldState.disabled
          ? (isDark ? AppColors.grey800 : AppColors.grey100)
          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      borderRadius: AppRadius.radiusSm,
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }
}
