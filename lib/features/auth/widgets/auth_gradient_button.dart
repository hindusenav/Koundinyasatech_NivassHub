import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../auth_colors.dart';

/// Shared gradient CTA for the auth flow's "Login with OTP", "Verify OTP",
/// and "Continue" buttons — a `Container` decoration (not `Ink`) behind a
/// transparent-`ElevatedButton`, with a built-in loading/disabled state
/// (spinner swap, `onPressed` forced null) so every screen shares one
/// recipe instead of duplicating it.
///
/// Deliberately `Container`, not `Ink`: `Ink`'s decoration paints via the
/// nearest ancestor `Material` rather than on its own render object, which
/// silently failed to render when this button sat under two sibling
/// `AnimatedBuilder`s each wrapping their subtree in `Opacity` (reproduced
/// on the OTP-success screen — button text/hit-area were present but the
/// gradient never painted). `Container.decoration` paints itself directly
/// and has no such dependency, with no loss of the tap ripple (the
/// `ElevatedButton` below still provides its own `Material`/`InkWell` for
/// that, unrelated to whichever widget paints the background behind it).
class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusLg,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AuthColors.primaryBlue, AuthColors.primaryBlueDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AuthColors.primaryBlue.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            elevation: 0,
            minimumSize: const Size(double.infinity, AppDimensions.buttonHeightLg),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
          ),
          child: isLoading
              ? const SizedBox(
                  height: AppDimensions.iconSm,
                  width: AppDimensions.iconSm,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppDimensions.iconSm, color: Colors.white),
                      const SizedBox(width: 10),
                    ],
                    Text(label, style: AppTextStyles.buttonText),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, size: AppDimensions.iconSm, color: Colors.white),
                  ],
                ),
        ),
      ),
    );
  }
}
