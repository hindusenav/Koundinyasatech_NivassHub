import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central typography scale, aligned to the Material 3 type scale so it maps
/// directly onto [TextTheme] in `app_theme.dart`. Base styles intentionally
/// omit color (color comes from the active [ColorScheme]/context) — only the
/// semantic helpers at the bottom (link, error, success) pin a color.
///
/// Widgets should never write `TextStyle(fontSize: ..., fontWeight: ...)`
/// inline — use these instead.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  // ---------------------------------------------------------------------
  // Display — hero numbers, splash headlines
  // ---------------------------------------------------------------------
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // ---------------------------------------------------------------------
  // Headline — screen titles, dashboard section headers
  // ---------------------------------------------------------------------
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // ---------------------------------------------------------------------
  // Title — app bar titles, card headers, list item titles
  // ---------------------------------------------------------------------
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
  );

  // ---------------------------------------------------------------------
  // Body — default running text
  // ---------------------------------------------------------------------
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // ---------------------------------------------------------------------
  // Label — buttons, chips, form field labels
  // ---------------------------------------------------------------------
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  // ---------------------------------------------------------------------
  // Semantic helpers — the only styles that pin a color
  // ---------------------------------------------------------------------
  static TextStyle get caption => bodySmall.copyWith(color: AppColors.grey500);

  static TextStyle get link => bodyMedium.copyWith(
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      );

  static TextStyle get errorText =>
      bodySmall.copyWith(color: AppColors.error);

  static TextStyle get successText =>
      bodySmall.copyWith(color: AppColors.success);

  static TextStyle get buttonText => labelLarge.copyWith(color: AppColors.white);
}
