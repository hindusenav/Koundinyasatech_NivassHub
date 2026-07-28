import 'package:flutter/widgets.dart';

/// Central border-radius scale. Use these instead of raw `BorderRadius.circular(...)`
/// values anywhere a rounded corner is needed.
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// Fully rounded (pill / circular) — used for chips, avatars, FABs.
  static const double full = 999;

  // -----------------------------------------------------------------------
  // BorderRadius convenience getters
  // -----------------------------------------------------------------------
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull =
      BorderRadius.all(Radius.circular(full));

  /// Rounds only the top corners — used for bottom sheets.
  static const BorderRadius topLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
}
