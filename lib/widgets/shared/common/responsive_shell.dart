import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';

/// App-wide responsive wrapper, placed in `MaterialApp.builder` so every
/// screen, sheet and dialog gets the same behaviour:
///
/// * Width is capped at [AppDimensions.appMaxWidth] and centred, so tablets
///   and iPads show a phone-style column rather than stretched fields. The
///   [MediaQuery] size is overridden to match, so `Responsive`/`context.rs`
///   and every `LayoutBuilder` below see the real usable width.
/// * Text scale follows the screen width (small phones a little smaller,
///   big phones a little larger) on top of the user's system setting, and is
///   clamped so large accessibility text can't overflow layouts.
/// * Phones are locked to portrait; tablets rotate freely.
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key, required this.child});

  final Widget child;

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  bool? _isPhone;

  static const double _minUserTextScale = 0.9;
  static const double _maxUserTextScale = 1.15;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `shortestSide` is orientation-independent: < 600dp is a phone.
    final isPhone =
        MediaQuery.sizeOf(context).shortestSide < AppDimensions.breakpointMobile;
    if (isPhone == _isPhone) return;
    _isPhone = isPhone;
    SystemChrome.setPreferredOrientations(
      isPhone
          ? const [DeviceOrientation.portraitUp]
          : DeviceOrientation.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width.clamp(0.0, AppDimensions.appMaxWidth).toDouble();

    // Linear factor of the user's own setting, bounded, then adjusted for
    // the usable width.
    final user = mq.textScaler
        .scale(1)
        .clamp(_minUserTextScale, _maxUserTextScale)
        .toDouble();
    final byWidth = (width / Responsive.designWidth).clamp(0.92, 1.1);

    final constrained = mq.copyWith(
      size: Size(width, mq.size.height),
      textScaler: TextScaler.linear(user * byWidth),
    );

    return ColoredBox(
      color: AppColors.background,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: MediaQuery(data: constrained, child: widget.child),
        ),
      ),
    );
  }
}
