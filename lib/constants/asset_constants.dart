/// Registry for static asset paths under `assets/`. Register a path here
/// the moment a real asset is added — feature code should reference
/// `AppAssets.xxx`, never a raw `'assets/...'` string literal.
class AppAssets {
  AppAssets._();

  static const String splashMark = 'assets/images/splash_mark.svg';
  static const String splashWordmark = 'assets/images/splash_wordmark.svg';
  /// Full horizontal logo (mark + "nivaashub" wordmark) as a raster.
  static const String fullLogo = 'assets/images/splash_full_logo.png';
  static const String welcomeBackground = 'assets/images/welcome_background.jpg';
  static const String onboardingSkyline = 'assets/images/onboarding_skyline_dark.png';
}
