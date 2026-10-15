/// Registry for static asset paths under `assets/`. Register a path here
/// the moment a real asset is added — feature code should reference
/// `AppAssets.xxx`, never a raw `'assets/...'` string literal.
class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/nivaashub_logo.png';
  static const String logoMark = 'assets/images/nivaashub_logo_mark.png';
  static const String stackedLogo = 'assets/images/nivaashub-logo-stacked.png';
  static const String verificationIcon = 'assets/images/verification_icon.png';
  static const String authBackground = 'assets/images/auth_background.png';
  static const String welcomeBackground = 'assets/images/welcome_background.jpg';
}
