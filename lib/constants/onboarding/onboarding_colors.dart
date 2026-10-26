import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Palette for Onboarding Screen 2 only — deliberately not merged into the
/// shared [AppColors] so the rest of the app (Onboarding 1, Login, etc.)
/// keeps its existing blue unchanged.
///
/// Kept deliberately separate from the central `AppColors` even though it
/// now also supports dark mode — the light-mode literals below stay this
/// screen's own branded palette. Only the dark-mode counterparts below reuse
/// `AppColors`' dark tokens, since there's no existing dark pixel target to
/// preserve there.
class OnboardingColors {
  OnboardingColors._();

  static const Color primaryBlue = Color(0xFFFF8A00);
  // Design darker-blue shade used for gradients (e.g. CreateAccountButton),
  // NOT a dark-theme variant of primaryBlue.
  static const Color primaryBlueDark = Color(0xFFE67600);
  static const Color background = Color(0xFFF3E8D9);
  static const Color heading = Color(0xFF3E2F1C);
  static const Color bodyText = Color(0xFF8A7658);

  // Light-mode accent, mirroring the orange CTA of the navy design.
  static const Color accentOrange = Color(0xFFFF8A00);
  static const Color accentOrangeLight = Color(0xFFC58A4F);
  // Tint applied to the skyline line art on the light background.
  static const Color skylineLine = Color(0xFFFF8A00);

  // ---------------------------------------------------------------------
  // Dark-theme counterparts (used when Theme.of(context).brightness ==
  // Brightness.dark). Not to be confused with `primaryBlueDark` above.
  // ---------------------------------------------------------------------
  static const Color primaryBlueDarkMode = Color(0xFFF2B66D);
  static const Color backgroundDarkMode = AppColors.backgroundDark;
  static const Color headingDarkMode = AppColors.textPrimaryDark;
  static const Color bodyTextDarkMode = AppColors.textSecondaryDark;
}
