import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/auth/success_check_icon.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Shared layout for the Figma success screens: optional logo, animated
/// green check, title, message and a navy CTA pinned to the bottom.
class FigmaSuccessScreen extends StatelessWidget {
  const FigmaSuccessScreen({
    super.key,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onContinue,
    this.showLogo = false,
    this.footer,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onContinue;
  final bool showLogo;

  /// Small caption under the button (e.g. "100% Secure").
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);

    return Scaffold(
      backgroundColor: t.page,
      body: FigmaBackground(
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            children: [
              if (showLogo) const NivassLogoMark(size: 72, elevated: false),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (_, value, _) =>
                              SuccessCheckIcon(entrance: value, size: 120),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: t.heading,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: t.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FigmaButton(label: buttonLabel, navy: true, showArrow: true, onPressed: onContinue),
              if (footer != null) ...[
                const SizedBox(height: 10),
                Text(footer!, style: TextStyle(fontSize: 11, color: t.body)),
              ],
            ],
          ),
        ),
        ),
        ),
    );
  }
}

/// Figma "OTP Verification" success state.
class OtpSuccessScreen extends StatelessWidget {
  const OtpSuccessScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return FigmaSuccessScreen(
      showLogo: true,
      title: 'OTP Successfully Verified!',
      message: 'Your mobile number has been verified successfully.',
      buttonLabel: 'Continue',
      footer: '100% Secure',
      onContinue: onContinue,
    );
  }
}

/// Figma "Profile Successfully Verified" screen shown at the end of KYC.
class ProfileVerifiedScreen extends StatelessWidget {
  const ProfileVerifiedScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return FigmaSuccessScreen(
      title: 'Profile Successfully Verified!',
      message:
          'Your resident identity has been validated.\nWelcome to the NivaasHub family.',
      buttonLabel: 'Continue to Dashboard',
      onContinue: onContinue,
    );
  }
}
