import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// Shortcuts for the things every screen ends up reaching for —
/// theme/colorScheme/textTheme access, screen size, and responsive
/// breakpoint checks (thresholds come from [AppDimensions]).
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < AppDimensions.breakpointMobile;
  bool get isTablet =>
      screenWidth >= AppDimensions.breakpointMobile &&
      screenWidth < AppDimensions.breakpointTablet;
  bool get isDesktop => screenWidth >= AppDimensions.breakpointTablet;

  void hideKeyboard() => FocusScope.of(this).unfocus();
}
