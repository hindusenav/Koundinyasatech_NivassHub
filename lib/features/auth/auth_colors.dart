import 'package:flutter/material.dart';

/// Palette for the mobile-OTP auth screens (Login, OTP Verification) only —
/// mirrors `OnboardingColors`' values so this flow reads as a continuation
/// of Onboarding 2's light/soft-blue look, without depending on the
/// onboarding feature directly.
class AuthColors {
  AuthColors._();

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color primaryBlueDark = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF8FBFF);
  static const Color heading = Color(0xFF0F2B5B);
  static const Color bodyText = Color(0xFF6B7280);
  static const Color border = Color(0xFFD6E4FF);
}
