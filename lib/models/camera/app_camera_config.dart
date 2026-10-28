import 'package:flutter_nivasshub/constants/camera/camera_strings.dart';

/// Guide overlay drawn over the live preview.
enum CameraGuide { none, document }

/// Per-call configuration for `AppCamera.capture`. The look is identical
/// everywhere; only the copy, the guide overlay and the starting lens vary.
class AppCameraConfig {
  const AppCameraConfig({
    required this.title,
    required this.hint,
    this.guide = CameraGuide.none,
    this.startWithFrontCamera = false,
  });

  final String title;
  final String hint;
  final CameraGuide guide;
  final bool startWithFrontCamera;

  /// ID cards, certificates, proofs — back camera with a document frame.
  static const AppCameraConfig document = AppCameraConfig(
    title: CameraStrings.documentTitle,
    hint: CameraStrings.documentHint,
    guide: CameraGuide.document,
  );

  /// General photos (pets, profile pictures, …).
  static const AppCameraConfig photo = AppCameraConfig(
    title: CameraStrings.photoTitle,
    hint: CameraStrings.photoHint,
  );
}
