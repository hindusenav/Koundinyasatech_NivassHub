import 'package:flutter/material.dart';

class Responsive {
  const Responsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 900) return 40;
    if (width >= 600) return 32;

    return 20;
  }

  static double sectionSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= 600 ? 32 : 24;
  }

  static double cardRadius(BuildContext context) {
    return isTablet(context) ? 24 : 18;
  }

  static int quickActionColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1000) return 6;
    if (width >= 600) return 4;

    return 4;
  }

  static double bannerHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 900) return 280;
    if (width >= 600) return 220;

    return 170;
  }
}