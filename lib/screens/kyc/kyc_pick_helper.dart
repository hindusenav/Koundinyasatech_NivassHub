import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/models/camera/app_camera_config.dart';
import 'package:flutter_nivasshub/screens/camera/app_camera.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_file_preview_sheet.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_upload_source_sheet.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:provider/provider.dart';

/// Source sheet -> camera or file picker -> preview/confirm. Returns the
/// file the user confirmed, or null when they cancelled or picking failed
/// (failures are reported to the user here).
Future<PickedFile?> pickKycFile(BuildContext context) async {
  final filePicker = context.read<FilePickerServiceBase>();

  final source = await KycUploadSourceSheet.show(context);
  if (source == null || !context.mounted) return null;

  if (source == FilePickSource.camera) {
    return AppCamera.capture(context, config: AppCameraConfig.document);
  }

  final picked = await filePicker.pick(source: source);
  if (!context.mounted) return null;
  if (picked.isFailure) {
    _showPickError(
      context,
      filePicker,
      picked.message ?? KycStrings.genericError,
    );
    return null;
  }
  final file = picked.data;
  if (file == null) return null; // user cancelled the OS picker

  final confirmed = await KycFilePreviewSheet.show(context, file: file);
  return confirmed == true ? file : null;
}

void _showPickError(
  BuildContext context,
  FilePickerServiceBase filePicker,
  String message,
) {
  if (message == KycStrings.cameraPermanentlyDeniedMessage) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: filePicker.openSettings,
          ),
        ),
      );
    return;
  }
  CustomSnackbar.error(context, message);
}
