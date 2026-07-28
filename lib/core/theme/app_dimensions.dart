/// Central sizing constants for icons, controls, and layout breakpoints.
/// Use these instead of raw numeric literals for widths/heights/sizes.
class AppDimensions {
  AppDimensions._();

  // -----------------------------------------------------------------------
  // Icon sizes
  // -----------------------------------------------------------------------
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // -----------------------------------------------------------------------
  // Controls
  // -----------------------------------------------------------------------
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;

  static const double inputHeight = 48;
  static const double minTouchTarget = 48;

  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
  static const double bottomSheetHandleWidth = 40;
  static const double bottomSheetHandleHeight = 4;

  // -----------------------------------------------------------------------
  // Avatars / thumbnails
  // -----------------------------------------------------------------------
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 72;
  static const double avatarXl = 96;

  // -----------------------------------------------------------------------
  // Misc
  // -----------------------------------------------------------------------
  static const double dividerThickness = 1;
  static const double borderThickness = 1;
  static const double borderThicknessFocused = 2;
  static const double cardElevation = 1;

  // -----------------------------------------------------------------------
  // Responsive breakpoints (max width, in logical pixels, for each class)
  // -----------------------------------------------------------------------
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 1024;
  static const double breakpointDesktop = 1440;

  /// Content is capped at this width on large screens (web/desktop) so
  /// text and forms don't stretch edge-to-edge.
  static const double maxContentWidth = 1080;
}
