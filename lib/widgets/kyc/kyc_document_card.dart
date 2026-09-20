import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/status_chip.dart';

/// One document requirement: what it is, its upload state, the chosen
/// file, and the actions available on it.
///
/// Built from `CustomCard` + `StatusChip` + `AppColors.status*` rather
/// than the hand-rolled hex values of the previous KYC screen, so it
/// works in both themes.
class KycDocumentCard extends StatelessWidget {
  const KycDocumentCard({
    super.key,
    required this.slot,
    required this.onUpload,
    required this.onRemove,
  });

  final KycDocumentSlot slot;

  /// Opens the source sheet. Disabled while the slot is busy.
  final VoidCallback onUpload;

  final VoidCallback onRemove;

  KycDocumentSpec get _spec => KycDocumentCatalog.specFor(slot.type);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Padding(
      padding: AppSpacing.vertical(AppSpacing.sm),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconTile(icon: _spec.icon),
                AppSpacing.gapWSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _spec.title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: textPrimary,
                        ),
                      ),
                      AppSpacing.gapXs,
                      Text(
                        _spec.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapWSm,
                StatusChip(label: _statusLabel, type: _statusType),
              ],
            ),
            AppSpacing.gapMd,
            _buildBody(context, textPrimary, textSecondary),
            if (slot.errorMessage != null) ...[
              AppSpacing.gapSm,
              _Message(text: slot.errorMessage!, color: AppColors.error),
            ],
            // The reviewer's objection stays visible until a replacement
            // has actually been uploaded, so the user can see what they
            // are fixing while they fix it.
            if (slot.issueReason != null && !slot.isSatisfied) ...[
              AppSpacing.gapSm,
              _Message(text: slot.issueReason!, color: AppColors.warning),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    if (slot.status.isBusy) {
      return Row(
        children: [
          const SizedBox(
            width: AppDimensions.iconSm,
            height: AppDimensions.iconSm,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          AppSpacing.gapWSm,
          Text(
            KycStrings.uploading,
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          ),
        ],
      );
    }

    final uploaded = slot.uploaded;
    if (slot.isSatisfied && uploaded != null) {
      final size = uploaded.displaySize;
      return Row(
        children: [
          Icon(
            AppIcons.checkCircle,
            size: AppDimensions.iconSm,
            color: AppColors.success,
          ),
          AppSpacing.gapWSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uploaded.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
                ),
                Text(
                  size.isEmpty
                      ? uploaded.displayType
                      : '${uploaded.displayType} · $size',
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUpload,
            child: const Text(KycStrings.replaceDocument),
          ),
          IconButton(
            tooltip: KycStrings.removeDocument,
            icon: const Icon(AppIcons.delete, size: AppDimensions.iconSm),
            onPressed: onRemove,
          ),
        ],
      );
    }

    return _UploadTarget(
      onTap: onUpload,
      label: slot.status == KycUploadStatus.failed
          ? KycStrings.retryUpload
          : KycStrings.uploadDocument,
      isAttention: slot.needsReplacement,
    );
  }

  String get _statusLabel => switch (slot.status) {
    KycUploadStatus.uploaded => KycStrings.statusUploaded,
    KycUploadStatus.preserved => KycStrings.statusPreserved,
    KycUploadStatus.failed => KycStrings.statusFailed,
    KycUploadStatus.picking ||
    KycUploadStatus.uploading => KycStrings.uploading,
    KycUploadStatus.empty =>
      slot.needsReplacement
          ? KycStrings.statusNeedsReplacement
          : KycStrings.statusPending,
  };

  StatusChipType get _statusType => switch (slot.status) {
    KycUploadStatus.uploaded ||
    KycUploadStatus.preserved => StatusChipType.approved,
    KycUploadStatus.failed => StatusChipType.rejected,
    KycUploadStatus.empty =>
      slot.needsReplacement ? StatusChipType.rejected : StatusChipType.pending,
    _ => StatusChipType.pending,
  };
}

/// Tinted square holding the document type's icon.
class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.avatarMd,
      height: AppDimensions.avatarMd,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: AppRadius.radiusSm,
      ),
      child: Icon(icon, size: AppDimensions.iconMd, color: AppColors.primary),
    );
  }
}

/// The dashed-feel tap target shown before a document has been supplied.
class _UploadTarget extends StatelessWidget {
  const _UploadTarget({
    required this.onTap,
    required this.label,
    required this.isAttention,
  });

  final VoidCallback onTap;
  final String label;

  /// Flagged by the reviewer — bordered in the warning colour so the card
  /// that needs work stands out among preserved ones.
  final bool isAttention;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isAttention
        ? AppColors.warning
        : (isDark ? AppColors.borderDark : AppColors.borderLight);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusSm,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusSm,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(
              AppIcons.upload,
              size: AppDimensions.iconMd,
              color: AppColors.primary,
            ),
            AppSpacing.gapXs,
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapXs,
            Text(
              KycStrings.fileSizeHint,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline validation / objection line under a card.
class _Message extends StatelessWidget {
  const _Message({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(AppIcons.info, size: AppDimensions.iconXs, color: color),
        AppSpacing.gapWXs,
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
