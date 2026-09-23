import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';

/// The outcome banner: approved, rejected, or correction required, with
/// the reviewer's reasons listed per document.
class KycVerdictPanel extends StatelessWidget {
  const KycVerdictPanel({
    super.key,
    required this.status,
    this.reason,
    this.issues = const [],
  });

  final KycVerificationStatus status;
  final String? reason;
  final List<KycDocumentIssue> issues;

  bool get _isApproved => status == KycVerificationStatus.approved;

  Color get _accent => _isApproved ? AppColors.success : AppColors.error;

  IconData get _icon => _isApproved ? AppIcons.checkCircle : AppIcons.warning;

  String get _title => switch (status) {
    KycVerificationStatus.approved => KycStrings.verdictApprovedTitle,
    KycVerificationStatus.correctionRequired =>
      KycStrings.verdictCorrectionTitle,
    _ => KycStrings.verdictUnsuccessfulTitle,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardInsets,
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, size: AppDimensions.iconMd, color: _accent),
              AppSpacing.gapWSm,
              Expanded(
                child: Text(
                  _title,
                  style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
                ),
              ),
            ],
          ),
          if (_isApproved) ...[
            AppSpacing.gapSm,
            Text(
              KycStrings.verdictApprovedBody,
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
            ),
          ] else ...[
            if (reason != null && reason!.isNotEmpty) ...[
              AppSpacing.gapMd,
              Text(
                KycStrings.reasonLabel,
                style: AppTextStyles.labelMedium.copyWith(color: _accent),
              ),
              AppSpacing.gapXs,
              Text(
                reason!,
                style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
              ),
            ],
            // Per-document objections are listed separately from the
            // overall reason: they are what the resubmit screen clears,
            // so the user can see exactly which cards need work.
            if (issues.isNotEmpty) ...[
              AppSpacing.gapMd,
              for (final issue in issues)
                Padding(
                  padding: AppSpacing.vertical(AppSpacing.xxs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        AppIcons.chevronRight,
                        size: AppDimensions.iconXs,
                        color: _accent,
                      ),
                      AppSpacing.gapWXs,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodySmall.copyWith(
                              color: textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${KycDocumentCatalog.specFor(issue.documentType).title}: ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: issue.reason),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
