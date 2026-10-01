/// One reviewer objection, scoped to a single document.
///
/// Per-document rather than one blanket reason for the whole submission:
/// it is what lets the resubmit screen clear *only* the offending card and
/// keep the rest (see `KycProvider.hydrateForResubmit`).
///
/// Keyed by `documentId` — the same id `GET /kyc/documents` handed out —
/// never by a client-side document type.
class KycDocumentIssue {
  const KycDocumentIssue({
    required this.documentId,
    required this.documentName,
    required this.reason,
  });

  final int documentId;
  final String documentName;
  final String reason;

  Map<String, dynamic> toJson() => {
    'documentId': documentId,
    'documentName': documentName,
    'reason': reason,
  };

  /// Returns `null` when the id is missing rather than defaulting to one,
  /// so a contract change can never silently flag the wrong card.
  static KycDocumentIssue? tryFromJson(Map<String, dynamic> json) {
    final rawId = json['documentId'];
    if (rawId == null) return null;
    return KycDocumentIssue(
      documentId: rawId is int ? rawId : int.tryParse('$rawId') ?? 0,
      documentName: json['documentName'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  static List<KycDocumentIssue> listFromJson(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => tryFromJson(Map<String, dynamic>.from(e)))
        .whereType<KycDocumentIssue>()
        .toList(growable: false);
  }
}
