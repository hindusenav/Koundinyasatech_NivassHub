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

  static const Color primaryBlue = Color(0xFFFF8A00);
  // Design darker-blue shade used for gradients (e.g. AuthGradientButton),
  // NOT a dark-theme variant of primaryBlue.
  static const Color primaryBlueDark = Color(0xFFE67600);
  static const Color lightBlue = Color(0xFFC58A4F);
  static const Color background = Color(0xFFF3E8D9);
  static const Color heading = Color(0xFF3E2F1C);
  static const Color bodyText = Color(0xFF8A7658);
  static const Color border = Color(0xFFE8DCC8);

  // ---------------------------------------------------------------------
  // Dark-theme counterparts (used when Theme.of(context).brightness ==
  // Brightness.dark). Not to be confused with `primaryBlueDark` above.
  // ---------------------------------------------------------------------
  static const Color primaryBlueDarkMode = Color(0xFFF2B66D);
  static const Color lightBlueDarkMode = Color(0xFFF2B66D);
  static const Color backgroundDarkMode = AppColors.backgroundDark;
  static const Color headingDarkMode = AppColors.textPrimaryDark;
  static const Color bodyTextDarkMode = AppColors.textSecondaryDark;
  static const Color borderDarkMode = AppColors.borderDark;
}
