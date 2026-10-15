import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';

/// Where a document comes from. `files` reaches the OS document picker
/// (the only route that can return a PDF); the other two reach the camera
/// and photo library.
enum FilePickSource { files, camera, gallery }

/// Contract over the platform file/image pickers.
///
/// Exists so `KycProvider` and the KYC widgets never import `file_picker`
/// or `image_picker` directly — which is what lets `MockFilePickerService`
/// stand in and makes the whole KYC flow testable with no platform
/// channel, the same swap-at-the-composition-root discipline `useMockApi`
/// already enforces for the network.
abstract class FilePickerServiceBase {
  /// Opens the picker for [source] and validates the result against
  /// [allowedExtensions] and [maxSizeBytes] before returning it.
  ///
  /// Returns `ApiResponse.success(null)` when the user backs out —
  /// cancellation is not an error and must not surface a snackbar.
  Future<ApiResponse<PickedFile?>> pick({
    required FilePickSource source,
    List<String> allowedExtensions = KycConfig.allowedKycExtensions,
    int maxSizeBytes = KycConfig.maxKycFileSizeBytes,
  });

  /// Opens this device's app-settings screen — the only recovery path
  /// once a permission (e.g. camera) has been permanently denied.
  Future<void> openSettings();

  /// Requests the camera permission if needed, returning `null` once it is
  /// granted (or already was) and an explanatory [ApiException] otherwise.
  ///
  /// Exposed separately from [pick] so the in-app camera capture screen
  /// can gate its own `CameraController` on the exact same permission
  /// flow — and the exact same permanently-denied message — that [pick]
  /// already uses for `FilePickSource.camera`.
  Future<ApiException?> ensureCameraPermission();
}
