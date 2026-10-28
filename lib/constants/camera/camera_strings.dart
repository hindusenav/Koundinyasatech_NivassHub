/// Copy for the shared in-app camera (`AppCamera`) and its permission screen.
class CameraStrings {
  CameraStrings._();

  // Presets
  static const String documentTitle = 'Scan document';
  static const String documentHint = 'Fit the whole document inside the frame';
  static const String photoTitle = 'Take photo';
  static const String photoHint = 'Centre your subject and tap to capture';

  // Review step
  static const String reviewTitle = 'Review photo';
  static const String reviewHint = 'Make sure everything is sharp and readable';
  static const String retake = 'Retake';
  static const String usePhoto = 'Use photo';

  // Permission
  static const String permissionTitle = 'Let Nivaas Hub use your camera';
  static const String permissionBody =
      'Nivaas Hub needs your camera to capture photos and documents '
      'right inside the app.';
  static const String permissionDeniedTitle = 'Camera access is off';
  static const String permissionDeniedBody =
      'Turn on camera access for Nivaas Hub in your device settings, '
      'then come back to continue.';
  static const String permissionPointCapture = 'Capture documents and photos';
  static const String permissionPointPrivate =
      'Photos are only used for what you submit';
  static const String permissionPointControl =
      'Change this anytime in Settings';
  static const String allowAccess = 'Allow camera access';
  static const String openSettings = 'Open Settings';
  static const String notNow = 'Not now';

  // Errors
  static const String unavailableTitle = 'Camera unavailable';
  static const String unavailableBody =
      'The camera is unavailable on this device right now. '
      'Please try again or choose a different option.';
  static const String tryAgain = 'Try again';
  static const String captureFailed =
      'We could not capture that photo. Please try again.';
}
