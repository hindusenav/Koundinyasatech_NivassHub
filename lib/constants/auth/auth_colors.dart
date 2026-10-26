import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Palette for the mobile-OTP auth screens (Login, OTP Verification) only —
/// mirrors `OnboardingColors`' values so this flow reads as a continuation
/// of Onboarding 2's light/soft-blue look, without depending on the
/// onboarding feature directly.
///
/// Kept deliberately separate from the central `AppColors` (see that file's
/// doc comment) even though it now also supports dark mode — the light-mode
/// literals below are this flow's own branded palette, not derived from
/// `AppColors`' light side. Only the dark-mode counterparts below reuse
/// `AppColors`' dark tokens, since there's no existing dark pixel target to
/// preserve there.
class AuthColors {
  AuthColors._();

  static const Color primaryBlue = AppColors.primaryOrange;
  // Design darker-blue shade used for gradients (e.g. AuthGradientButton),
  // NOT a dark-theme variant of primaryBlue.
  static const Color primaryBlueDark = AppColors.primaryOrangeDark;
  static const Color lightBlue = AppColors.headerStart;
  static const Color background = AppColors.background;
  static const Color heading = AppColors.textDark;
  static const Color bodyText = AppColors.textMuted;
  static const Color border = AppColors.cardBorder;

  // ---------------------------------------------------------------------
  // Dark-theme counterparts (used when Theme.of(context).brightness ==
  // Brightness.dark). Not to be confused with `primaryBlueDark` above.
  // ---------------------------------------------------------------------
  static const Color primaryBlueDarkMode = AppColors.iconDark;
  static const Color lightBlueDarkMode = AppColors.iconDark;
  static const Color backgroundDarkMode = AppColors.backgroundDark;
  static const Color headingDarkMode = AppColors.textPrimaryDark;
  static const Color bodyTextDarkMode = AppColors.textSecondaryDark;
  static const Color borderDarkMode = AppColors.borderDark;
}
