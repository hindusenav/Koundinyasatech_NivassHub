import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';

/// Lets the user choose how to supply a document: the OS file picker (the
/// only route that can return a PDF), the camera, or the photo library.
class KycUploadSourceSheet extends StatelessWidget {
  const KycUploadSourceSheet({super.key});

  /// Resolves to the chosen source, or `null` if dismissed.
  static Future<FilePickSource?> show(BuildContext context) {
    return showModalBottomSheet<FilePickSource>(
      context: context,
      builder: (_) => const KycUploadSourceSheet(),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KycStrings.uploadSourceSheetTitle,
                  style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
                ),
                AppSpacing.gapXs,
                Text(
                  KycStrings.fileSizeHint,
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
          _option(
            context,
            icon: AppIcons.attach,
            label: KycStrings.uploadSourceFile,
            source: FilePickSource.files,
            textColor: textPrimary,
          ),
          _option(
            context,
            icon: AppIcons.camera,
            label: KycStrings.uploadSourceCamera,
            source: FilePickSource.camera,
            textColor: textPrimary,
          ),
          _option(
            context,
            icon: AppIcons.upload,
            label: KycStrings.uploadSourceGallery,
            source: FilePickSource.gallery,
            textColor: textPrimary,
          ),
          AppSpacing.gapSm,
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String label,
    required FilePickSource source,
    required Color textColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: AppDimensions.iconMd, color: AppColors.primary),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(color: textColor),
      ),
      onTap: () => Navigator.of(context).pop(source),
    );
  }
}
