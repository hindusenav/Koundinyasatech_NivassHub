import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
// The image_picker package exports a deprecated PickedFile of its own; hide
// it so the name unambiguously means this app plugin-agnostic model.
import 'package:image_picker/image_picker.dart' hide PickedFile;
import 'package:permission_handler/permission_handler.dart' as ph;

/// Real picker, wrapping two plugins behind one contract.
///
/// `file_picker` handles [FilePickSource.files] because `image_picker`
/// physically cannot return a PDF — it only surfaces photos and videos,
/// and no configuration changes that. `image_picker` is kept for camera
/// and gallery, where it gives a far better capture experience and is
/// already a dependency used by the profile screen.
class FilePickerService implements FilePickerServiceBase {
  FilePickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<ApiResponse<PickedFile?>> pick({
    required FilePickSource source,
    List<String> allowedExtensions = KycConfig.allowedKycExtensions,
    int maxSizeBytes = KycConfig.maxKycFileSizeBytes,
  }) async {
    try {
      if (source == FilePickSource.camera) {
        final permissionError = await _ensureCameraPermission();
        if (permissionError != null) return ApiResponse.failure(permissionError);
      }

      final picked = switch (source) {
        FilePickSource.files => await _pickFromFiles(allowedExtensions),
        FilePickSource.camera => await _pickImage(ImageSource.camera),
        FilePickSource.gallery => await _pickImage(ImageSource.gallery),
      };

      // Cancellation, not failure.
      if (picked == null) return ApiResponse.success(null);

      return _validate(picked, allowedExtensions, maxSizeBytes);
    } on PlatformException catch (e, stack) {
      debugPrint('[FilePicker] pick($source) platform failure: $e\n$stack');
      return ApiResponse.failure(
        ApiException(
          message: source == FilePickSource.camera
              ? 'The camera is unavailable on this device right now. '
                    'Please try again or choose a different option.'
              : KycStrings.genericError,
          type: ApiExceptionType.unknown,
        ),
      );
    } catch (e, stack) {
      // `ApiService.handleRequest` is not in play here (this is not a
      // network call), so log before flattening or the real cause is lost.
      debugPrint('[FilePicker] pick($source) failed: $e\n$stack');
      return ApiResponse.failure(
        const ApiException(
          message: KycStrings.genericError,
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  /// Requests the camera permission if needed, returning `null` when it is
  /// granted (or already was) and an explanatory [ApiException] otherwise.
  /// A permanently-denied permission gets a distinct message pointing the
  /// user at Settings, since re-requesting it would just silently no-op.
  Future<ApiException?> _ensureCameraPermission() async {
    var status = await ph.Permission.camera.status;
    if (status.isGranted) return null;

    if (!status.isPermanentlyDenied) {
      status = await ph.Permission.camera.request();
      if (status.isGranted) return null;
    }

    if (status.isPermanentlyDenied) {
      return const ApiException(
        message: KycStrings.cameraPermanentlyDeniedMessage,
        type: ApiExceptionType.forbidden,
      );
    }

    return const ApiException(
      message: 'Camera permission is required to take a photo.',
      type: ApiExceptionType.forbidden,
    );
  }

  @override
  Future<void> openSettings() => ph.openAppSettings();

  Future<PickedFile?> _pickFromFiles(List<String> allowedExtensions) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      dialogTitle: KycStrings.uploadSourceSheetTitle,
    );
    if (file == null) return null;

    // `path` is null when the platform hands back a non-file URI. It is
    // only ever used for a thumbnail, so fall back to the URI string
    // rather than rejecting an otherwise valid pick.
    final path = file.path ?? file.uri.toString();
    final size = file.lengthSync() ?? await file.length() ?? 0;

    return PickedFile(
      path: path,
      fileName: file.name,
      extension: (file.extension ?? '').toLowerCase(),
      sizeBytes: size,
    );
  }

  Future<PickedFile?> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      // Bounds a full-resolution camera photo so it doesn't turn a
      // successful capture into a doomed upload against
      // KycConfig.maxKycFileSizeBytes.
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image == null) return null;

    final extension = _extensionOf(image.name, fallback: 'jpg');
    return PickedFile(
      path: image.path,
      fileName: image.name,
      extension: extension,
      sizeBytes: await _sizeOf(image.path),
    );
  }

  /// Client-side gate: rejecting here is instant and saves a doomed
  /// upload. The server re-checks independently — see
  /// `MockDocumentService.uploadDocument`.
  ApiResponse<PickedFile?> _validate(
    PickedFile file,
    List<String> allowedExtensions,
    int maxSizeBytes,
  ) {
    if (!allowedExtensions.contains(file.extension)) {
      return ApiResponse.failure(
        ApiException(
          message: KycStrings.unsupportedFileType(allowedExtensions),
          type: ApiExceptionType.validation,
        ),
      );
    }

    if (file.sizeBytes > maxSizeBytes) {
      return ApiResponse.failure(
        ApiException(
          message: KycStrings.fileTooLarge(maxSizeBytes),
          type: ApiExceptionType.validation,
        ),
      );
    }

    return ApiResponse.success(file);
  }

  static String _extensionOf(String name, {required String fallback}) {
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot == name.length - 1) return fallback;
    return name.substring(dot + 1).toLowerCase();
  }

  static Future<int> _sizeOf(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      // A size of 0 skips the size check rather than blocking the user on
      // a stat failure; the server-side check still applies.
      return 0;
    }
  }
}
