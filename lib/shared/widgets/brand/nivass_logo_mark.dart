import 'package:flutter/material.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_colors.dart';

/// The NIVASS brand mark: a house with three people inside a white circle,
/// symbolizing residents coming together to build a home and community.
/// Purely presentational.
class NivassLogoMark extends StatelessWidget {
  const NivassLogoMark({super.key, this.size = 134});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.18),
        child: Image.asset(AppAssets.logoMark, fit: BoxFit.contain),
      ),
    );
  }
}
