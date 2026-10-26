import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Blue-tinted circular badge with the Nivaas Hub brand mark — the
/// assurance mark shown near the top of the registration flow's
/// mobile-entry (`RegisterScreen`) and OTP-verification (registration mode)
/// screens.
class AuthShieldBadge extends StatelessWidget {
  const AuthShieldBadge({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lightBlue = isDark
        ? AuthColors.lightBlueDarkMode
        : AuthColors.lightBlue;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: lightBlue.withValues(alpha: 0.14),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.splashMark,
          width: size * 0.55,
          height: size * 0.55,
        ),
      ),
    );
  }
}
