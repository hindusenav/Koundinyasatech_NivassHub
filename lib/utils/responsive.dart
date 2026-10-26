import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';

/// Width classes the whole app reasons in. Thresholds live in
/// [AppDimensions]; the app shell caps width at [AppDimensions.appMaxWidth],
/// so on a tablet the widest class a screen sees is [tablet].
enum ScreenClass {
  /// Small phones (iPhone SE/mini, 320-359dp Androids).
  compact,

  /// Regular phones (360-599dp).
  phone,

  /// Large phones in landscape, tablets, iPads (>= 600dp).
  tablet;

  static ScreenClass of(double width) {
    if (width < AppDimensions.breakpointCompact) return compact;
    if (width < AppDimensions.breakpointMobile) return phone;
    return tablet;
  }
}

/// Single source of responsive numbers. Prefer the [ResponsiveContext]
/// extension (`context.rs(16)`, `context.pageInsets`) in widgets.
class Responsive {
  const Responsive._();

  /// Design width the raw numbers in the code were authored against.
  static const double designWidth = 390;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Proportional scale for [width]: 1.0 at the design width, never below
  /// 0.85 (keeps touch targets usable) nor above 1.2 (stops big phones and
  /// tablets looking inflated).
  static double scaleFor(double width) =>
      (width / designWidth).clamp(0.85, 1.2).toDouble();

  static double scale(BuildContext context) => scaleFor(widthOf(context));

  static bool isMobile(BuildContext context) =>
      widthOf(context) < AppDimensions.breakpointMobile;

  static bool isTablet(BuildContext context) =>
      widthOf(context) >= AppDimensions.breakpointMobile;

  static ScreenClass screenClass(BuildContext context) =>
      ScreenClass.of(widthOf(context));

  /// Picks a value per [ScreenClass]; [phone] is the default for [compact]
  /// and [tablet] when they aren't given.
  static T value<T>(
    BuildContext context, {
    required T phone,
    T? compact,
    T? tablet,
  }) {
    switch (screenClass(context)) {
      case ScreenClass.compact:
        return compact ?? phone;
      case ScreenClass.phone:
        return phone;
      case ScreenClass.tablet:
        return tablet ?? phone;
    }
  }

  static double horizontalPadding(BuildContext context) =>
      value(context, compact: 16.0, phone: 20.0, tablet: 32.0);

  static double verticalPadding(BuildContext context) =>
      value(context, compact: 16.0, phone: 24.0, tablet: 32.0);

  static double sectionSpacing(BuildContext context) =>
      value(context, compact: 20.0, phone: 24.0, tablet: 32.0);

  static double cardRadius(BuildContext context) =>
      value(context, phone: 18.0, tablet: 24.0);

  static int quickActionColumns(BuildContext context) =>
      value(context, compact: 3, phone: 4, tablet: 4);

  /// Banner height follows the width (16:7-ish) instead of a fixed number,
  /// so it never dominates a short screen or looks tiny on a wide one.
  static double bannerHeight(BuildContext context) =>
      (widthOf(context) * 0.45).clamp(150.0, 240.0).toDouble();
}

/// Context shortcuts for responsive sizing — the reusable replacement for
/// literal numbers in widgets.
extension ResponsiveContext on BuildContext {
  ScreenClass get screenClass => Responsive.screenClass(this);

  /// True on 320-359dp phones (iPhone SE, small Androids).
  bool get isCompact => screenClass == ScreenClass.compact;

  /// Scales [size] with the screen width (see [Responsive.scaleFor]).
  double rs(double size) => size * Responsive.scale(this);

  /// Standard screen padding, e.g. `SingleChildScrollView(padding: ...)`.
  EdgeInsets get pageInsets => EdgeInsets.symmetric(
    horizontal: Responsive.horizontalPadding(this),
    vertical: Responsive.verticalPadding(this),
  );

  /// Vertical gaps between blocks. Use instead of `SizedBox(height: 24)`.
  SizedBox get gapXs => SizedBox(height: rs(4));
  SizedBox get gapSm => SizedBox(height: rs(8));
  SizedBox get gapMd => SizedBox(height: rs(16));
  SizedBox get gapLg => SizedBox(height: rs(24));
  SizedBox get gapXl => SizedBox(height: rs(32));

  /// Horizontal counterpart of the gaps above.
  SizedBox get gapWSm => SizedBox(width: rs(8));
  SizedBox get gapWMd => SizedBox(width: rs(16));
}

/// Sizing for boxes that hold text.
extension ResponsiveTextContext on BuildContext {
  /// Like [ResponsiveContext.rs] but never smaller than [size], and grows
  /// with the user's text size, so fixed-height tiles/cards holding text
  /// can't clip on small phones or with large system fonts.
  double rt(double size) {
    final grow = Responsive.scale(this) < 1 ? 1.0 : Responsive.scale(this);
    final text = MediaQuery.textScalerOf(this).scale(1).clamp(1.0, 1.3);
    return size * grow * text;
  }
}
