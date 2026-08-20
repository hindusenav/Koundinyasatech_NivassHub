import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';

/// The app's standard divider — styling comes from `ThemeData.dividerTheme`
/// (see `core/theme/app_theme.dart`).
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.indent = 0, this.endIndent = 0});

  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(indent: indent, endIndent: endIndent);
  }

  /// Vertical variant — use inside a `Row` between two items.
  static Widget vertical({double height = AppDimensions.iconMd}) {
    return SizedBox(
      height: height,
      child: const VerticalDivider(width: 1, thickness: AppDimensions.dividerThickness),
    );
  }
}
