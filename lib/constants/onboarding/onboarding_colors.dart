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

  static const Color primaryBlue = Color(0xFF1565D8);
  // Design darker-blue shade used for gradients (e.g. CreateAccountButton),
  // NOT a dark-theme variant of primaryBlue.
  static const Color primaryBlueDark = Color(0xFF2563EB);
  static const Color background = Color(0xFFF8FAFC);
  static const Color heading = Color(0xFF0F274B);
  static const Color bodyText = Color(0xFF6B7280);

  // ---------------------------------------------------------------------
  // Dark-theme counterparts (used when Theme.of(context).brightness ==
  // Brightness.dark). Not to be confused with `primaryBlueDark` above.
  // ---------------------------------------------------------------------
  static const Color primaryBlueDarkMode = Color(0xFF42A5F5);
  static const Color backgroundDarkMode = AppColors.backgroundDark;
  static const Color headingDarkMode = AppColors.textPrimaryDark;
  static const Color bodyTextDarkMode = AppColors.textSecondaryDark;
}
