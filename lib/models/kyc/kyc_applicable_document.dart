/// One entry returned by `GET /kyc/documents` — the backend's source of
/// truth for which documents the caller's role must upload.
///
/// ```json
/// { "document_name_id": 13, "document_name": "Aadhar",
///   "description": "...", "is_mandatory": "Mandatory" }
/// ```
///
/// `document_name_id` is the `doc_id` `POST /kyc/re-upload` expects, as a
/// number. Never hardcoded on the client — see `KycProvider.initialise`,
/// which builds its document cards from exactly this list and nothing else.
class KycApplicableDocument {
  const KycApplicableDocument({
    required this.documentId,
    required this.documentName,
    this.description = '',
    this.isMandatory = true,
    this.alreadyUploaded = false,
    this.uploadStatus = '',
  });

  /// True when the backend already holds this document for the user (it is
  /// in `uploadedDocuments`), so a new file goes to `POST /kyc/re-upload`.
  final bool alreadyUploaded;

  /// Upper-cased `Document_Status` of the uploaded copy (e.g. "DOCUMENT IS
  /// IN PENDING STATE"); empty when nothing is uploaded.
  final String uploadStatus;

  bool get isRejected => alreadyUploaded && uploadStatus.contains('REJECT');

  /// The user still has to (re-)upload this: a mandatory document that is
  /// missing, or any uploaded document the admin rejected.
  bool get needsUpload => alreadyUploaded ? isRejected : isMandatory;

  KycApplicableDocument markUploaded(String status) => KycApplicableDocument(
    documentId: documentId,
    documentName: documentName,
    description: description,
    isMandatory: isMandatory,
    alreadyUploaded: true,
    uploadStatus: status.toUpperCase(),
  );

  final int documentId;
  final String documentName;
  final String description;

  /// `false` for `"Not Mandatory"` — such a document may be skipped.
  final bool isMandatory;

  factory KycApplicableDocument.fromJson(Map<String, dynamic> json) {
    final rawId = json['document_name_id'] ?? json['documentId'];
    final rawMandatory = json['is_mandatory'] ?? json['isMandatory'];
    return KycApplicableDocument(
      documentId: rawId is int ? rawId : int.tryParse('$rawId') ?? 0,
      documentName:
          (json['document_name'] ?? json['documentName']) as String? ?? '',
      description: json['description'] as String? ?? '',
      isMandatory: rawMandatory is bool
          ? rawMandatory
          : !'$rawMandatory'.toLowerCase().contains('not'),
    );
  }

  static List<KycApplicableDocument> listFromJson(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (e) => KycApplicableDocument.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList(growable: false);
  }
}
