import 'package:flutter/material.dart';

/// Palette for Onboarding Screen 2 only — deliberately not merged into the
/// shared [AppColors] so the rest of the app (Onboarding 1, Login, etc.)
/// keeps its existing blue unchanged.
class OnboardingColors {
  OnboardingColors._();

  static const Color primaryBlue = Color(0xFF1565D8);
  static const Color primaryBlueDark = Color(0xFF2563EB);
  static const Color background = Color(0xFFF8FAFC);
  static const Color heading = Color(0xFF0F274B);
  static const Color bodyText = Color(0xFF6B7280);
}
