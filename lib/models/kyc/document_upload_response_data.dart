/// `data` payload of a successful `POST /kyc/upload`.
///
/// A fresh upload comes back `201` with `actionPerformed: "inserted"`; a
/// re-upload of the same document comes back `200` with `"updated"` and
/// a bumped `version` — both controlled entirely by the backend. The
/// client never calculates a version or an action itself.
///
/// ```json
/// { "documentName": "Driving Licence", "version": 2,
///   "actionPerformed": "updated" }
/// ```
///
/// Round-trips through JSON because it is persisted: a preserved document
/// on a resubmit is re-sent by [documentId] alone, with no re-upload.
class DocumentUploadResponseData {
  const DocumentUploadResponseData({
    required this.documentId,
    required this.documentName,
    required this.fileName,
    this.fileType = '',
    this.version = 1,
    this.actionPerformed = 'inserted',
    this.sizeBytes = 0,
    this.uploadedAt,
    this.localPath,
    this.sessionToken,
  });

  /// The `doc_id` this upload was sent for — carried forward from the
  /// request since the response itself only confirms the document by name.
  final int documentId;
  final String documentName;
  final String fileName;

  /// Lower-case extension, e.g. `pdf`.
  final String fileType;

  /// Backend-controlled revision number for this document.
  final int version;

  /// `"inserted"` on a first upload, `"updated"` on a re-upload.
  final String actionPerformed;

  final int sizeBytes;
  final DateTime? uploadedAt;

  /// Best-effort only, for a thumbnail. Both pickers return paths inside
  /// the app cache, which the OS may reclaim — so a preserved document is
  /// never re-read from disk, and any thumbnail needs an `errorBuilder`.
  final String? localPath;

  /// Fresh token from the upload response (not persisted); replaces the
  /// one used for the request.
  final String? sessionToken;

  bool get isReupload => actionPerformed == 'updated';

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
    final rawDocumentId = json['documentId'];
    return DocumentUploadResponseData(
      documentId: rawDocumentId is int
          ? rawDocumentId
          : int.tryParse('$rawDocumentId') ?? 0,
      documentName: json['documentName'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      version: json['version'] as int? ?? 1,
      actionPerformed: json['actionPerformed'] as String? ?? 'inserted',
      sizeBytes: json['sizeBytes'] as int? ?? 0,
      uploadedAt: rawUploadedAt is String
          ? DateTime.tryParse(rawUploadedAt)
          : null,
      localPath: json['localPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentId,
    'documentName': documentName,
    'fileName': fileName,
    'fileType': fileType,
    'version': version,
    'actionPerformed': actionPerformed,
    'sizeBytes': sizeBytes,
    'uploadedAt': uploadedAt?.toIso8601String(),
    'localPath': localPath,
  };
}
