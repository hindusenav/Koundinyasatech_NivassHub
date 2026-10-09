/// Registry for static asset paths under `assets/`. Register a path here
/// the moment a real asset is added — feature code should reference
/// `AppAssets.xxx`, never a raw `'assets/...'` string literal.
class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/nivaashub_logo.png';
  static const String logoMark = 'assets/images/nivaashub_logo_mark.png';
  static const String splashMark = 'assets/images/splash_mark.svg';
  static const String splashWordmark = 'assets/images/splash_wordmark.svg';
  static const String welcomeBackground = 'assets/images/welcome_background.jpg';
}
