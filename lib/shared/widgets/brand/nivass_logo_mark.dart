import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// The NIVASS brand mark: a house with three people inside a white circle,
/// symbolizing residents coming together to build a home and community.
/// Purely presentational — used both as the splash's centerpiece (wrapped in
/// animation/Hero there) and as the small static header mark on screens
/// like [LoginScreen].
class NivassLogoMark extends StatelessWidget {
  const NivassLogoMark({super.key, this.size = 134, this.elevated = true});

  final double size;
  final bool elevated;

  /// Shared [Hero] tag — apply to whichever wrapper transitions this mark
  /// between screens (e.g. splash's centerpiece and a screen header).
  static const heroTag = 'nivass-logo';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_rounded,
              size: size * 0.34,
              color: AppColors.splashGradientBottom,
            ),
            SizedBox(height: size * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.accessibility_new, size: size * 0.20, color: AppColors.splashPrimaryBlue),
                SizedBox(width: size * 0.01),
                Icon(Icons.accessibility_new, size: size * 0.27, color: AppColors.secondary),
                SizedBox(width: size * 0.01),
                Icon(Icons.accessibility_new, size: size * 0.20, color: AppColors.splashAccentOrange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
