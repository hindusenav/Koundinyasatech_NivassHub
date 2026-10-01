import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';

/// Confirmation step shown after picking a file/image from the OS file
/// picker or photo gallery, before it is uploaded — an image preview when
/// the file is a photo, otherwise a name/type/size card. Camera captures
/// get their own preview inside `KycCameraCaptureScreen` and don't need a
/// second one here.
class KycFilePreviewSheet extends StatelessWidget {
  const KycFilePreviewSheet({super.key, required this.file});

  final PickedFile file;

  /// Resolves to `true` if the user confirmed the upload, `false`/`null`
  /// otherwise (cancel, dismiss, back button).
  static Future<bool?> show(BuildContext context, {required PickedFile file}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => KycFilePreviewSheet(file: file),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              KycStrings.filePreviewTitle,
              style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
            ),
            AppSpacing.gapMd,
            if (file.isImage)
              ClipRRect(
                borderRadius: AppRadius.radiusSm,
                child: Image.file(
                  File(file.path),
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      _FileCard(file: file, textPrimary: textPrimary, textSecondary: textSecondary),
                ),
              )
            else
              _FileCard(
                file: file,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(StringConstants.cancel),
                  ),
                ),
                AppSpacing.gapWSm,
                Expanded(
                  child: PrimaryButton(
                    label: KycStrings.filePreviewUpload,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
          ],
        ),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({
    required this.file,
    required this.textPrimary,
    required this.textSecondary,
  });

  final PickedFile file;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.radiusSm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.attach,
            size: AppDimensions.iconLg,
            color: AppColors.primary,
          ),
          AppSpacing.gapWSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
                ),
                Text(
                  '${file.displayType} · ${file.displaySize}',
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
