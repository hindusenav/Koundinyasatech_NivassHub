import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../onboarding_colors.dart';

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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [OnboardingColors.primaryBlue, OnboardingColors.primaryBlueDark],
        ),
        boxShadow: [
          BoxShadow(
            color: OnboardingColors.primaryBlue.withValues(alpha: 0.25),
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
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: OnboardingColors.primaryBlue,
                    ),
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
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: OnboardingColors.primaryBlue,
        side: const BorderSide(color: Color(0xFFD7E3F5), width: 2),
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
