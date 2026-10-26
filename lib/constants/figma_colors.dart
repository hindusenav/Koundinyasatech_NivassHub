import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Palette for the dashboard and the redesigned (Figma) registration + KYC
/// screens, in the Scandinavian Minimal "Warm Amber" theme.
///
/// Every themed token is resolved through [of] so each screen reads the same
/// way in light and dark. Prefer [FigmaTheme] over the constants below
/// wherever a [BuildContext] is available; the constants are theme-agnostic
/// fallbacks for call sites that cannot read the theme.
class FigmaColors {
  FigmaColors._();

  /// Deep navy used for solid header fills that carry white text. Name kept
  /// from the old palette so existing call sites keep compiling.
  static const Color navy = AppColors.headerEnd;

  /// Primary accent (warm amber-brown). Name kept from the old orange
  /// palette so existing call sites keep compiling.
  static const Color orange = AppColors.primaryOrange;

  /// Warning / highlight accent.
  static const Color warning = AppColors.warning;

  /// Info accent (follows the brand accent).
  static const Color accentBlue = AppColors.primaryOrange;

  /// Top bar / header colour in dark mode.
  static const Color darkBar = AppColors.surfaceDark;

  /// Deep-navy text colour for headings.
  static const Color ink = AppColors.textDark;

  static FigmaTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? FigmaTheme.dark
      : FigmaTheme.light;
}

class FigmaTheme {
  const FigmaTheme({
    required this.page,
    required this.header,
    required this.card,
    required this.cardBorder,
    required this.field,
    required this.fieldBorder,
    required this.heading,
    required this.body,
    required this.cta,
    required this.shadow,
    required this.accent,
    required this.iconBg,
    required this.navInactive,
  });

  final Color page;
  final Color header;
  final Color card;
  final Color cardBorder;
  final Color field;
  final Color fieldBorder;
  final Color heading;
  final Color body;

  /// Fill of the "Continue / Submit" buttons.
  final Color cta;
  final Color shadow;

  /// Primary icon / active-state colour (amber-brown light, warm amber dark).
  final Color accent;

  /// Tinted container behind a primary icon.
  final Color iconBg;

  /// Inactive bottom-navigation icon / label colour.
  final Color navInactive;

  static const light = FigmaTheme(
    page: AppColors.backgroundLight,
    header: FigmaColors.navy,
    card: AppColors.surfaceLight,
    cardBorder: AppColors.borderLight,
    field: AppColors.surfaceLight,
    fieldBorder: AppColors.borderLight,
    heading: AppColors.textPrimaryLight,
    body: AppColors.textSecondaryLight,
    cta: AppColors.primary,
    shadow: AppColors.shadowSoft,
    accent: AppColors.primary,
    iconBg: AppColors.mint,
    navInactive: AppColors.textSecondaryLight,
  );

  static const dark = FigmaTheme(
    page: AppColors.backgroundDark,
    header: FigmaColors.darkBar,
    card: AppColors.surfaceDark,
    cardBorder: AppColors.borderDark,
    field: Color(0xFF1B1D20),
    fieldBorder: AppColors.borderDark,
    heading: AppColors.textPrimaryDark,
    body: AppColors.textSecondaryDark,
    cta: AppColors.primary,
    shadow: Color(0x00000000),
    accent: AppColors.iconDark,
    iconBg: AppColors.iconContainerDark,
    navInactive: AppColors.textSecondaryDark,
  );
}
