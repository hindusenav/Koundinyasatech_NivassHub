import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../auth_colors.dart';

/// Blue-tinted circular badge with a shield/checkmark icon — the security
/// assurance mark shown near the top of the registration flow's
/// mobile-entry (`RegisterScreen`) and OTP-verification (registration mode)
/// screens, in place of the brand logo mark used elsewhere.
class AuthShieldBadge extends StatelessWidget {
  const AuthShieldBadge({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AuthColors.lightBlue.withValues(alpha: 0.14),
      ),
      child: Icon(AppIcons.shield, size: size * 0.5, color: AuthColors.primaryBlue),
    );
  }
}
