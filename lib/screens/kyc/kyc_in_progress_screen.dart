import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';

/// Shown when `registration-check` answers 423 `KYC_IN_PROGRESS`: the
/// user's documents are already under review, so there is nothing to do
/// but wait.
class KycInProgressScreen extends StatelessWidget {
  const KycInProgressScreen({super.key, this.message});

  /// The backend's message, shown verbatim when present.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const CustomAppBar(title: 'KYC in progress'),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.hourglass_top_rounded, size: 64, color: textSecondary),
              AppSpacing.gapLg,
              Text(
                'Your KYC is under review',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(color: textPrimary),
              ),
              AppSpacing.gapSm,
              Text(
                message ??
                    'Your documents have been submitted and are being '
                        'reviewed. We will notify you once it is done.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
              ),
              AppSpacing.gapLg,
              PrimaryButton(
                label: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
