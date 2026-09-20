/// A file the user chose, described without reference to whichever plugin
/// produced it.
///
/// `file_picker` and `image_picker` return different shapes; both are
/// normalized into this by `FilePickerService`, so `KycProvider` and the
/// KYC widgets never import either plugin — which is also what lets
/// `MockFilePickerService` stand in during widget tests.
class PickedFile {
  const PickedFile({
    required this.path,
    required this.fileName,
    required this.extension,
    required this.sizeBytes,
  });

  final String path;
  final String fileName;

  /// Lower-case, no leading dot: `pdf`, `jpg`.
  final String extension;
  final int sizeBytes;

  /// `image/jpeg`, `application/pdf` — derived rather than asked of the
  /// plugin, since only one of the two reliably reports it.
  String get mimeType => switch (extension) {
    'pdf' => 'application/pdf',
    'png' => 'image/png',
    'jpg' || 'jpeg' => 'image/jpeg',
    _ => 'application/octet-stream',
  };

  /// What the document card shows next to the filename: `PDF · 1.2 MB`.
  String get displayType => extension.toUpperCase();

  String get displaySize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isImage => extension != 'pdf';
}
