import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

enum SocialProvider { google, apple }

/// Outlined "Continue with ..." button for third-party sign-in. Google has
/// no single-color [IconData] and no brand asset/package is installed, so it
/// renders a neutral "G" glyph badge instead of the literal multi-color
/// mark; Apple uses the built-in [Icons.apple] glyph.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  final SocialProvider provider;
  final VoidCallback onPressed;

  String get _label => switch (provider) {
        SocialProvider.google => 'Continue with Google',
        SocialProvider.apple => 'Continue with Apple',
      };

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGlyph(),
          const SizedBox(width: 10),
          Text(_label),
        ],
      ),
    );
  }

  Widget _buildGlyph() {
    if (provider == SocialProvider.apple) {
      return const Icon(
        Icons.apple,
        size: AppDimensions.iconSm,
        color: AppColors.textPrimaryLight,
      );
    }
    return Container(
      width: AppDimensions.iconSm,
      height: AppDimensions.iconSm,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey100,
        border: Border.all(color: AppColors.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
