import 'package:flutter/material.dart';

/// Central color palette for the app. Every color used anywhere in the UI
/// must be referenced from here — never hardcode a Color(...) in a widget.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Brand colors
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFFFF8A00);
  // static const Color primary = Color(0xFF2E5AAC);
  // static const Color primary = Color(0xFF2E5AAC);

  static const Color primaryLight = Color(0xFFF2B66D);
  static const Color primaryDark = Color(0xFFE67600);

  static const Color secondary = Color(0xFFB7791F);
  static const Color secondaryLight = Color(0xFFD9A75F);
  static const Color secondaryDark = Color(0xFF8A5A14);

  static const Color tertiary = Color(0xFFF2B66D);

  // ---------------------------------------------------------------------
  // Warm Amber theme (Scandinavian Minimal)
  // ---------------------------------------------------------------------
  static const Color amberStart = Color(0xFF8B6F47);
  static const Color amberEnd = Color(0xFFC6A87A);
  static const Color orange = Color(0xFFFF8A00);
  static const Color textDark = Color(0xFF3E2F1C);
  static const Color cardBg = Color(0xFFFFF9F0);
  static const Color sectionBg = Color(0xFFF3E8D9);

  /// Top / bottom navigation bar gradient (180° linear).
  static const LinearGradient amberGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [amberStart, amberEnd],
  );

  /// Dark-mode counterpart of [amberGradient].
  static const LinearGradient amberGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3B2D20), Color(0xFF5A4630)],
  );

  /// Glass card fill / hairline border (light + dark).
  static const Color glassFillLight = Color(0xCCFFF9F0);
  static const Color glassFillDark = Color(0x99222528);
  static const Color glassBorderLight = Color(0x99FFFFFF);
  static const Color glassBorderDark = Color(0x33FFFFFF);

  // ---------------------------------------------------------------------
  // Semantic colors
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF2F855A);
  static const Color successLight = Color(0xFFE6F2EA);

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFBF1E5);

  static const Color error = Color(0xFFD64545);
  static const Color errorLight = Color(0xFFFBE9E7);

  static const Color info = Color(0xFF4A6FA5);
  static const Color infoLight = Color(0xFFEAF0F8);

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
  static const Color backgroundLight = Color(0xFFF3E8D9);
  static const Color surfaceLight = Color(0xFFFFF9F0);
  /// Icon container tint (champagne) — light mode.
  static const Color mint = Color(0xFFFBF1E5);
  /// Icon container tint — dark mode.
  static const Color iconContainerDark = Color(0xFF3B2D20);
  /// Primary icon colour — dark mode (warm amber).
  static const Color iconDark = Color(0xFFF2B66D);
  /// Notification indicator dot.
  static const Color notificationDot = Color(0xFFFF8A00);
  /// Body text (14px regular).
  static const Color textBody = Color(0xFF5C4A32);
  static const Color backgroundDark = Color(0xFF151719);
  static const Color surfaceDark = Color(0xFF222528);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------
  static const Color textPrimaryLight = Color(0xFF3E2F1C);
  static const Color textSecondaryLight = Color(0xFF8A7658);
  static const Color textDisabledLight = grey400;

  static const Color textPrimaryDark = Color(0xFFF5F2ED);
  static const Color textSecondaryDark = Color(0xFFA7ADB5);
  static const Color textDisabledDark = grey600;

  // ---------------------------------------------------------------------
  // Borders / dividers
  // ---------------------------------------------------------------------
  static const Color borderLight = Color(0xFFE8DCC8);
  static const Color borderDark = Color(0xFF363A3E);
  static const Color dividerLight = Color(0xFFE8DCC8);
  static const Color dividerDark = Color(0xFF363A3E);

  // ---------------------------------------------------------------------
  // Overlay / misc
  // ---------------------------------------------------------------------
  static const Color overlay = Color(0x99000000);
  static const Color shimmerBaseLight = grey200;
  static const Color shimmerHighlightLight = grey100;
  static const Color shimmerBaseDark = grey700;
  static const Color shimmerHighlightDark = grey600;

  // ---------------------------------------------------------------------
  // Dashboard bottom navigation
  // ---------------------------------------------------------------------
  static const Color bottomNavBackgroundLight = Color(0xFF8B6F47);
  static const Color bottomNavBackgroundDark = surfaceDark;
  static const Color bottomNavSelectedLight = Color(0xFFFF8A00);
  static const Color bottomNavSelectedDark = primaryLight;

  // ---------------------------------------------------------------------
  // Dashboard widgets — misc dark-mode counterparts
  // ---------------------------------------------------------------------
  static const Color infoDark = Color(0xFF2C3A52);

  // ---------------------------------------------------------------------
  // Dashboard / Notice Board header card (shared "light blue header" look)
  // ---------------------------------------------------------------------
  static const Color dashboardHeaderLight = Color(0xFFF3E8D9);
  static const Color dashboardHeaderDark = Color(0xFF222528);
  static const Color dashboardBackgroundLight = Color(0xFFF3E8D9);
  static const Color dashboardBackgroundDark = backgroundDark;

  // ---------------------------------------------------------------------
  // Settings / Profile screens
  // ---------------------------------------------------------------------

  // settings_screen.dart — own light-only palette (was a local
  // `static const Color` block on `_SettingsScreenState`).
  static const Color settingsBackgroundLight = Color(0xFFF3E8D9);
  static const Color settingsBackgroundDark = backgroundDark;
  static const Color settingsHeaderLight = Color(0xFFF3E8D9);
  static const Color settingsHeaderDark = Color(0xFF222528);
  static const Color settingsPrimaryBlueLight = Color(0xFFFF8A00);
  static const Color settingsPrimaryBlueDark = Color(0xFFF2B66D);
  static const Color settingsLightBlueLight = Color(0xFFFBF1E5);
  static const Color settingsLightBlueDark = Color(0xFF3B2D20);
  // Text/border roles: light literal kept as its own token; the dark side
  // reuses the existing first-class textPrimaryDark/textSecondaryDark/
  // borderDark tokens directly at each call site (see settings_screen.dart).
  static const Color settingsTextPrimaryLight = Color(0xFF3E2F1C);
  static const Color settingsTextSecondaryLight = Color(0xFF8A7658);
  static const Color settingsBorderLight = Color(0xFFE8DCC8);
  static const Color settingsChevronLight = Color(0xFF8A7658);
  static const Color settingsAddBorderLight = Color(0xFFE8DCC8);
  static const Color settingsAddBorderDark = Color(0xFF363A3E);
  static const Color settingsProfileBadgeBgLight = Color(0xFFFFEEF0);
  static const Color settingsProfileBadgeBgDark = Color(0xFF3A1F22);
  static const Color settingsDangerIconBgLight = Color(0xFFFFF0F0);
  static const Color settingsDangerIconBgDark = Color(0xFF3A1F1F);
  static const Color settingsNotifyBgLight = Color(0xFFFFFAEE);
  static const Color settingsNotifyBgDark = Color(0xFF3A2F14);
  static const Color settingsNotifyBorderLight = Color(0xFFFFD477);
  static const Color settingsNotifyBorderDark = Color(0xFF6B5323);
  static const Color settingsNotifyTextLight = Color(0xFFFF8A00);
  static const Color settingsNotifyTextDark = Color(0xFFFFB74D);

  // profile_screen.dart — own light-only palette (was a local
  // `static const Color` block on `ProfileScreen`).
  static const Color profileBackgroundLight = Color(0xFFF3E8D9);
  static const Color profileBackgroundDark = backgroundDark;
  static const Color profileHeaderLight = Color(0xFFF3E8D9);
  static const Color profileHeaderDark = Color(0xFF222528);
  static const Color profilePrimaryBlueLight = Color(0xFFFF8A00);
  static const Color profilePrimaryBlueDark = Color(0xFFF2B66D);
  static const Color profileIconBgLight = Color(0xFFFBF1E5);
  static const Color profileIconBgDark = Color(0xFF3B2D20);
  static const Color profileOrangeLight = Color(0xFFFF8A00);
  static const Color profileOrangeDark = Color(0xFFFFB74D);
  static const Color profileBannerBorderLight = Color(0xFFE8DCC8);
  static const Color profileBannerBorderDark = Color(0xFF363A3E);
  // Decorative wave/circle fills painted behind the profile banner.
  static const Color profileBannerFillLight = Color(0xFFFBF1E5);
  static const Color profileBannerFillDark = Color(0xFF222528);
  static const Color profileBannerLineLight = Color(0xFFF1E4D2);
  static const Color profileBannerLineDark = Color(0xFF363A3E);
  static const Color profileBannerCircleLight = Color(0xFFF6E9D8);
  static const Color profileBannerCircleDark = Color(0xFF2C2F33);

  // add_address_details_screen.dart — own light-only palette (was a local
  // `static const Color` block on `_AddAddressDetailsScreenState`). Note
  // this screen's primaryBlue/headerBlue/backgroundBlue/labelColor happen to
  // be byte-identical to settings_screen.dart's, but each screen keeps its
  // own named token pair rather than sharing one.
  static const Color addAddressBackgroundLight = Color(0xFFF3E8D9);
  static const Color addAddressBackgroundDark = backgroundDark;
  static const Color addAddressHeaderLight = Color(0xFFF3E8D9);
  static const Color addAddressHeaderDark = Color(0xFF222528);
  static const Color addAddressPrimaryBlueLight = Color(0xFFFF8A00);
  static const Color addAddressPrimaryBlueDark = Color(0xFFF2B66D);
  static const Color addAddressLabelLight = Color(0xFF3E2F1C);
  static const Color addAddressValueLight = Color(0xFF3E2F1C);
  static const Color addAddressValueDark = Color(0xFFF5F2ED);
  static const Color addAddressBorderLight = Color(0xFFE8DCC8);
  static const Color addAddressHintLight = Color(0xFFB5A58C);

  // Shared "profile widget tile" accent — a 4th, distinct brand blue used
  // consistently across profile_tile.dart, input_field.dart, and
  // setting_item_tile.dart's default icon/accent colors.
  static const Color profileTilePrimaryBlueLight = Color(0xFFFF8A00);
  static const Color profileTilePrimaryBlueDark = Color(0xFFF2B66D);
  static const Color profileTileTagBgLight = Color(0xFFFBF1E5);
  static const Color profileTileTagBgDark = Color(0xFF3B2D20);
  static const Color settingItemIconBgLight = Color(0xFFFBF1E5);
  static const Color settingItemIconBgDark = Color(0xFF3B2D20);

  // ---------------------------------------------------------------------
  // Notice Board (Tailwind-slate palette used across notices/* screens)
  // ---------------------------------------------------------------------
  static const Color noticesBackgroundLight = Color(0xFFF3E8D9);
  static const Color noticesBackgroundDark = backgroundDark;
  static const Color noticesHeadingLight = Color(0xFF3E2F1C);
  static const Color noticesHeadingDark = textPrimaryDark;
  static const Color noticesBorderLight = Color(0xFFE8DCC8);
  static const Color noticesBorderDark = borderDark;
  static const Color noticesAmberLight = Color(0xFFFF8A00);
  static const Color noticesAmberDark = Color(0xFFF0A94E);
  static const Color noticesDangerBgLight = Color(0xFFFEF2F2);
  static const Color noticesDangerBgDark = Color(0xFF3A1F1F);
  static const Color noticesDangerBorderLight = Color(0xFFFECACA);
  static const Color noticesDangerBorderDark = Color(0xFF6B3232);
  static const Color noticesDangerDotLight = Color(0xFFEF4444);
  static const Color noticesDangerDotDark = Color(0xFFFF7A7A);
  static const Color noticesDangerTextLight = Color(0xFFDC2626);
  static const Color noticesDangerTextDark = Color(0xFFFF8A8A);

  // ---------------------------------------------------------------------
  // Notice Board — AppBar-blue (distinct from noticesBackgroundLight),
  // shared across notice-details / create-post / create-poll / create-event
  // / schedule-visit / community-posts-selection screens.
  // ---------------------------------------------------------------------
  static const Color noticesAppBarLight = Color(0xFFF3E8D9);
  static const Color noticesAppBarDark = dashboardHeaderDark;

  // Teal left-border brand accent reused identically across notice cards.
  static const Color noticesTealAccentLight = Color(0xFFFF8A00);
  static const Color noticesTealAccentDark = Color(0xFFF2B66D);

  // Slate-100 tint — subtle dividers / soft chip backgrounds.
  static const Color noticesDividerLight = Color(0xFFF1ECE5);
  static const Color noticesDividerDark = dividerDark;

  // Slate-200 — card borders / image placeholders.
  static const Color noticesCardBorderLight = Color(0xFFE8DCC8);
  static const Color noticesCardBorderDark = borderDark;

  // Slate-400 — muted captions / timestamps / hint text.
  static const Color noticesMutedLight = Color(0xFFB5A58C);
  static const Color noticesMutedDark = Color(0xFFA7ADB5);

  // Slate-500 — secondary text/icons (slightly darker than muted).
  static const Color noticesSecondaryTextLight = Color(0xFF8A7658);
  static const Color noticesSecondaryTextDark = Color(0xFFA7ADB5);

  // Slate-600 — field labels / medium-emphasis icons.
  static const Color noticesLabelTextLight = Color(0xFF5C4A32);
  static const Color noticesLabelTextDark = Color(0xFFC9CDD2);

  // Slate-700 — body copy.
  static const Color noticesBodyTextLight = Color(0xFF3E2F1C);
  static const Color noticesBodyTextDark = Color(0xFFD8DBDF);

  // Slate-800 — secondary heading/title text.
  static const Color noticesTitleTextLight = Color(0xFF3E2F1C);
  static const Color noticesTitleTextDark = noticesHeadingDark;

  // Amber-600 accent (distinct from noticesAmberLight/Dark) — avatars,
  // bullet icons, price badges, CTA icons shared across "create *" and
  // advertisement/schedule-visit screens.
  static const Color noticesAccentAmberLight = Color(0xFFFF8A00);
  static const Color noticesAccentAmberDark = Color(0xFFFFB74D);

  // Amber-50/200/500 family — soft amber info/price chips.
  static const Color noticesAmberBgLight = Color(0xFFFFFBEB);
  static const Color noticesAmberBgDark = Color(0xFF3A2E16);
  static const Color noticesAmberBorderLight = Color(0xFFFDE68A);
  static const Color noticesAmberBorderDark = Color(0xFF6B5423);
  static const Color noticesAmberStrongBorderLight = Color(0xFFFF8A00);
  static const Color noticesAmberStrongBorderDark = Color(0xFFCC8A2E);

  // Sky-600 accent blue — CTA buttons/icons shared across "create *" and
  // advertisement/schedule-visit screens.
  static const Color noticesAccentBlueLight = Color(0xFFFF8A00);
  static const Color noticesAccentBlueDark = Color(0xFFF2B66D);

  // Blue-50/100/200 family — soft blue info chips/icon containers.
  static const Color noticesBlueTintBgLight = Color(0xFFFBF1E5);
  static const Color noticesBlueTintBgDark = Color(0xFF3B2D20);
  static const Color noticesBlueLightBorderLight = Color(0xFFF1E4D2);
  static const Color noticesBlueLightBorderDark = Color(0xFF4A3A2A);
  static const Color noticesBlueBorderLight = Color(0xFFE8DCC8);
  static const Color noticesBlueBorderDark = Color(0xFF4A3A2A);

  // Emerald accent — "Location Advantages" success bullet.
  static const Color noticesSuccessBgLight = Color(0xFFE6F2EA);
  static const Color noticesSuccessBgDark = Color(0xFF1F3328);
  static const Color noticesSuccessIconLight = Color(0xFF2F855A);
  static const Color noticesSuccessIconDark = Color(0xFF68D391);

  // community_post_card.dart — Phase-0 migration off legacy_app_colors.dart.
  // communityAccentBlueLight preserves the legacy AppColors.primary pixel
  // value (0xFF2563EB) which is NOT the same as the real AppColors.primary.
  static const Color communityAccentBlueLight = Color(0xFFFF8A00);
  static const Color communityAccentBlueDark = Color(0xFFF2B66D);
  static const Color communityAvatarTextLight = Color(0xFFE67600);
  static const Color communityAvatarTextDark = Color(0xFFF2B66D);
  // Reaction/RSVP accent — intentionally identical in both themes (behaves
  // like an on-primary colored badge, see AppColors doc + migration rules).
  static const Color communityReactionOrange = Color(0xFFFF8A00);

  // ---------------------------------------------------------------------
  // Splash screen (premium animated intro)
  // ---------------------------------------------------------------------
  /// First frame of the splash flow; mirrored by `splash_background` in
  /// `android/.../res/values/splash_colors.xml`.
  static const Color splashBackgroundNavy = Color(0xFF3E2F1C);
  static const Color splashGradientTop = Color(0xFFC6A87A);
  static const Color splashGradientBottom = Color(0xFF8B6F47);
  static const Color splashPrimaryBlue = Color(0xFF8B6F47);
  static const Color splashAccentOrange = Color(0xFFFF8A00);
  static const Color splashAccentGold = Color(0xFFFFD27A);
  static const Color splashAccentAmber = Color(0xFFFF8A00);
  static const Color splashGlow = Color(0xFFF3E8D9);
}
