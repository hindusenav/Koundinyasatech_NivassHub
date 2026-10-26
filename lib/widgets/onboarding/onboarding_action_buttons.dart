import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/onboarding/onboarding_colors.dart';

/// Primary CTA for Onboarding Screen 2 — gradient fill with a trailing
/// circular arrow badge. Local to this screen: the shared `CustomButton` has
/// no trailing-icon-in-a-badge layout, and this treatment isn't generic
/// enough yet to add there.
class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // A plain DecoratedBox (not `Ink`) paints its own gradient directly,
    // rather than searching up the tree for an ambient Material to paint
    // onto — `Ink` decorations can fail to composite through the several
    // Transform/Opacity layers this button sits under (entrance + float
    // animations) on some renderer/device combinations.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final start = isDark ? OnboardingColors.primaryBlue : OnboardingColors.accentOrangeLight;
    final end = isDark ? OnboardingColors.primaryBlueDark : OnboardingColors.accentOrange;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start, end],
        ),
        boxShadow: [
          BoxShadow(
            color: end.withValues(alpha: 0.30),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightLg,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  const SizedBox(width: 44),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_forward, size: 18, color: end),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined "Login" action with a trailing arrow icon.
class OnboardingLoginButton extends StatelessWidget {
  const OnboardingLoginButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark
            ? OnboardingColors.primaryBlueDarkMode
            : OnboardingColors.accentOrange,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : OnboardingColors.accentOrange,
          width: isDark ? 2 : 1.5,
        ),
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeightLg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }
}
