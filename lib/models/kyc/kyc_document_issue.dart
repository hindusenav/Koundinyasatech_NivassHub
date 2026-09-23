import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';

/// One reviewer objection, scoped to a single document.
///
/// Per-document rather than one blanket reason for the whole submission:
/// it is what lets the resubmit screen clear *only* the offending card and
/// keep the rest (see `KycProvider.hydrateForResubmit`).
class KycDocumentIssue {
  const KycDocumentIssue({required this.documentType, required this.reason});

  final KycDocumentType documentType;
  final String reason;

  Map<String, dynamic> toJson() => {
    'documentType': documentType.wireValue,
    'reason': reason,
  };

  /// Returns `null` for an unrecognised document type rather than
  /// defaulting to one, so a contract change can never silently flag the
  /// wrong card.
  static KycDocumentIssue? tryFromJson(Map<String, dynamic> json) {
    final type = KycDocumentType.tryFromJson(json['documentType']);
    if (type == null) return null;
    return KycDocumentIssue(
      documentType: type,
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
