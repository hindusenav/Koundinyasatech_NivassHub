import 'package:flutter/widgets.dart';

/// Central spacing scale (4dp base unit). Use these instead of raw numbers
/// for any padding, margin, gap, or SizedBox spacer.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Standard horizontal padding applied to full-width screen content.
  static const double screenHorizontal = md;

  /// Standard vertical padding applied to full-width screen content.
  static const double screenVertical = md;

  /// Padding inside cards/containers.
  static const double cardPadding = md;

  /// Vertical gap between distinct sections on a screen.
  static const double sectionGap = lg;

  /// Vertical gap between items in a list.
  static const double listItemGap = sm;

  // -----------------------------------------------------------------------
  // EdgeInsets convenience helpers
  // -----------------------------------------------------------------------
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );

  static const EdgeInsets cardInsets = EdgeInsets.all(cardPadding);

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Vertical spacer widget, e.g. `AppSpacing.gapMd`.
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);

  /// Horizontal spacer widget, e.g. `AppSpacing.gapWSm`.
  static const SizedBox gapWXs = SizedBox(width: xs);
  static const SizedBox gapWSm = SizedBox(width: sm);
  static const SizedBox gapWMd = SizedBox(width: md);
  static const SizedBox gapWLg = SizedBox(width: lg);
  static const SizedBox gapWXl = SizedBox(width: xl);
}
