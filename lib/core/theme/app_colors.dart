import 'package:flutter/material.dart';

/// Central color palette for the app. Every color used anywhere in the UI
/// must be referenced from here — never hardcode a Color(...) in a widget.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Brand colors
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFF2E5AAC);
  static const Color primaryLight = Color(0xFF6685C7);
  static const Color primaryDark = Color(0xFF1E3D7A);

  static const Color secondary = Color(0xFF00A896);
  static const Color secondaryLight = Color(0xFF4FC3B6);
  static const Color secondaryDark = Color(0xFF007268);

  static const Color tertiary = Color(0xFFF2A93B);

  // ---------------------------------------------------------------------
  // Semantic colors
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF2E9E5B);
  static const Color successLight = Color(0xFFE3F5EA);

  static const Color warning = Color(0xFFE8A73B);
  static const Color warningLight = Color(0xFFFCF1DE);

  static const Color error = Color(0xFFD64545);
  static const Color errorLight = Color(0xFFFAE3E3);

  static const Color info = Color(0xFF3B8FE8);
  static const Color infoLight = Color(0xFFE3EFFC);

  // ---------------------------------------------------------------------
  // Status colors (visitor/complaint/notice states, StatusChip, etc.)
  // ---------------------------------------------------------------------
  static const Color statusActive = success;
  static const Color statusInactive = Color(0xFF9AA1AC);
  static const Color statusPending = warning;
  static const Color statusApproved = success;
  static const Color statusRejected = error;
  static const Color statusExpired = Color(0xFF9AA1AC);

  // ---------------------------------------------------------------------
  // Neutral / greyscale
  // ---------------------------------------------------------------------
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ---------------------------------------------------------------------
  // Surface / background
  // ---------------------------------------------------------------------
  static const Color backgroundLight = grey50;
  static const Color surfaceLight = white;
  static const Color backgroundDark = Color(0xFF0F1115);
  static const Color surfaceDark = Color(0xFF1A1D23);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------
  static const Color textPrimaryLight = grey900;
  static const Color textSecondaryLight = grey600;
  static const Color textDisabledLight = grey400;

  static const Color textPrimaryDark = grey50;
  static const Color textSecondaryDark = grey300;
  static const Color textDisabledDark = grey600;

  // ---------------------------------------------------------------------
  // Borders / dividers
  // ---------------------------------------------------------------------
  static const Color borderLight = grey200;
  static const Color borderDark = grey700;
  static const Color dividerLight = grey200;
  static const Color dividerDark = grey700;

  // ---------------------------------------------------------------------
  // Overlay / misc
  // ---------------------------------------------------------------------
  static const Color overlay = Color(0x99000000);
  static const Color shimmerBaseLight = grey200;
  static const Color shimmerHighlightLight = grey100;
  static const Color shimmerBaseDark = grey700;
  static const Color shimmerHighlightDark = grey600;
}
