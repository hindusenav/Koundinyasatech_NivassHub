import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Palette for the redesigned (Figma) registration + KYC screens.
///
/// Light mode is the Figma look: navy header, soft-blue page, orange CTA.
/// Every themed token is resolved through [of] so each screen reads the same
/// way in light and dark.
class FigmaColors {
  FigmaColors._();

  static const Color navy = Color(0xFF14284B);
  static const Color orange = Color(0xFFF97316);
  static const Color accentBlue = Color(0xFF2F6FED);

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
  });

  final Color page;
  final Color header;
  final Color card;
  final Color cardBorder;
  final Color field;
  final Color fieldBorder;
  final Color heading;
  final Color body;

  /// Fill of the navy "Continue / Submit" buttons.
  final Color cta;
  final Color shadow;

  static const light = FigmaTheme(
    page: Color(0xFFF1F6FF),
    header: FigmaColors.navy,
    card: Colors.white,
    cardBorder: Color(0xFFE3ECFA),
    field: Color(0xFFF7FAFF),
    fieldBorder: Color(0xFFDCE6F5),
    heading: Color(0xFF14284B),
    body: Color(0xFF6B7280),
    cta: FigmaColors.navy,
    shadow: Color(0x1414284B),
  );

  static const dark = FigmaTheme(
    page: AppColors.backgroundDark,
    header: Color(0xFF14284B),
    card: AppColors.surfaceDark,
    cardBorder: AppColors.borderDark,
    field: Color(0xFF12151B),
    fieldBorder: AppColors.borderDark,
    heading: AppColors.textPrimaryDark,
    body: AppColors.textSecondaryDark,
    cta: Color(0xFF1D3A6B),
    shadow: Color(0x00000000),
  );
}
