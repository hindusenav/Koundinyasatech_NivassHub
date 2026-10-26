import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Central typography scale, aligned to the Material 3 type scale so it maps
/// directly onto [TextTheme] in `app_theme.dart`. Base styles intentionally
/// omit color (color comes from the active [ColorScheme]/context) — only the
/// semantic helpers at the bottom (link, error, success) pin a color.
///
/// Widgets should never write `TextStyle(fontSize: ..., fontWeight: ...)`
/// inline — use these instead.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // ---------------------------------------------------------------------
  // Display — hero numbers, splash headlines
  // ---------------------------------------------------------------------
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
  );
  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );
  static TextStyle get displaySmall => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // ---------------------------------------------------------------------
  // Headline — screen titles, dashboard section headers
  // ---------------------------------------------------------------------
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );
  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // ---------------------------------------------------------------------
  // Title — app bar titles, card headers, list item titles
  // ---------------------------------------------------------------------
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
  );

  // ---------------------------------------------------------------------
  // Body — default running text
  // ---------------------------------------------------------------------
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // ---------------------------------------------------------------------
  // Label — buttons, chips, form field labels
  // ---------------------------------------------------------------------
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  // ---------------------------------------------------------------------
  // Semantic helpers — the only styles that pin a color
  // ---------------------------------------------------------------------
  static TextStyle get caption => bodySmall.copyWith(color: AppColors.textSecondaryLight);

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
