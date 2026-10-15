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

  static const Color primaryBlue = Color(0xFF1565C0);
  // Design darker-blue shade used for gradients (e.g. AuthGradientButton),
  // NOT a dark-theme variant of primaryBlue.
  static const Color primaryBlueDark = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF8FBFF);
  static const Color heading = Color(0xFF0F2B5B);
  static const Color bodyText = Color(0xFF6B7280);
  static const Color border = Color(0xFFD6E4FF);

  // New Design tokens for Auth & Registration screens (Figma Dev Mode)
  static const Color orangeButton = Color(0xFFFC7118); // Figma Orange #FC7118
  static const Color dividerText = Color(0xFF9CA3AF); // Divider text #9CA3AF
  static const Color blueNh = Color(0xFF0E2543);
  static const Color navyButton = Color(0xFF0E2543);
  static const Color navyBadge = Color(0xFF0E2543);
  static const Color successGreen = Color(0xFF2EBA60);
  static const Color pillBackground = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color formCardBorder = Color(0xFF9AA7B5); // Light Grey 0.5px
  static const Color gray1 = Color(0xFF3E3E3E); // Subtitle Gray 1
  static const Color graysBlack = Color(0xFF000000); // Page title Black
  static const Color inputBackground = Color(0xFFF9FAFB); // Phone input fill
  static const Color inputBorder = Color(0xFFE5E7EB); // Phone input 1px border
  static const Color textMuted = Color(0xFF6B7280); // Microcopy & Security note

  /// Exact Figma Dev Mode "Shadow cards 1"
  /// X: 4, Y: 4, Blur: 4, Spread: 0, #000000 15%
  static const BoxShadow shadowCards1 = BoxShadow(
    offset: Offset(4, 4),
    blurRadius: 4,
    spreadRadius: 0,
    color: Color(0x26000000),
  );

  // ---------------------------------------------------------------------
  // Dark-theme counterparts (used when Theme.of(context).brightness ==
  // Brightness.dark). Not to be confused with `primaryBlueDark` above.
  // ---------------------------------------------------------------------
  static const Color primaryBlueDarkMode = lightBlue;
  static const Color lightBlueDarkMode = Color(0xFF64B5F6);
  static const Color backgroundDarkMode = AppColors.backgroundDark;
  static const Color headingDarkMode = AppColors.textPrimaryDark;
  static const Color bodyTextDarkMode = AppColors.textSecondaryDark;
  static const Color borderDarkMode = AppColors.borderDark;
}
