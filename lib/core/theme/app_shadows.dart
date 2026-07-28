import 'package:flutter/widgets.dart';
import 'app_colors.dart';

/// Central elevation/shadow presets. Use these instead of hand-rolled
/// `BoxShadow(...)` lists so elevation reads consistently across the app.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  /// Subtler shadows for dark surfaces, where a black drop shadow reads as a
  /// muddy patch instead of depth — a soft outline shows elevation better.
  static const List<BoxShadow> darkSm = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> darkMd = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// 1px hairline "shadow" — an alternative to a real shadow on dark surfaces.
  static const List<BoxShadow> outline = [
    BoxShadow(
      color: AppColors.grey700,
      offset: Offset(0, 0),
      blurRadius: 0,
      spreadRadius: 1,
    ),
  ];
}
