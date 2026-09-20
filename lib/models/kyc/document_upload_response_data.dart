/// `data` payload of a successful document upload.
///
/// ```json
/// {
///   "success": true, "documentId": "DOC001",
///   "fileName": "address_proof.pdf", "status": "uploaded"
/// }
/// ```
///
/// Round-trips through JSON because it is persisted: a preserved document
/// on a resubmit is re-sent by [documentId] alone, with no re-upload.
class DocumentUploadResponseData {
  const DocumentUploadResponseData({
    required this.documentId,
    required this.fileName,
    required this.fileType,
    required this.status,
    this.sizeBytes = 0,
    this.uploadedAt,
    this.localPath,
  });

  final String documentId;
  final String fileName;

  /// Lower-case extension, e.g. `pdf`.
  final String fileType;

  /// Server-side status string, e.g. `uploaded`.
  final String status;

  final int sizeBytes;
  final DateTime? uploadedAt;

  /// Best-effort only, for a thumbnail. Both pickers return paths inside
  /// the app cache, which the OS may reclaim — so a preserved document is
  /// never re-read from disk, and any thumbnail needs an `errorBuilder`.
  final String? localPath;

  String get displayType => fileType.toUpperCase();

  String get displaySize {
    if (sizeBytes <= 0) return '';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  factory DocumentUploadResponseData.fromJson(Map<String, dynamic> json) {
    final rawUploadedAt = json['uploadedAt'];
    return DocumentUploadResponseData(
      documentId: json['documentId'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      status: json['status'] as String? ?? 'uploaded',
      sizeBytes: json['sizeBytes'] as int? ?? 0,
      uploadedAt: rawUploadedAt is String
          ? DateTime.tryParse(rawUploadedAt)
          : null,
      localPath: json['localPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentId,
    'fileName': fileName,
    'fileType': fileType,
    'status': status,
    'sizeBytes': sizeBytes,
    'uploadedAt': uploadedAt?.toIso8601String(),
    'localPath': localPath,
  };
}
