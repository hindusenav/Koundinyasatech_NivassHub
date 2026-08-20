import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Full-bleed backdrop for the [WelcomeScreen]: the brand's neighborhood
/// illustration fills the screen, with a soft white scrim over the middle
/// so the logo, greeting, and buttons stay legible against it.
class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.welcomeBackground,
            fit: BoxFit.cover,
            alignment: const Alignment(-0.5, 0.3),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.white.withValues(alpha: 0.05),
                  AppColors.white.withValues(alpha: 0.85),
                  AppColors.white.withValues(alpha: 0.85),
                  AppColors.white.withValues(alpha: 0.40),
                ],
                stops: const [0.0, 0.22, 0.80, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
