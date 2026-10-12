import 'dart:convert';
import 'dart:typed_data';

/// One entry of `data` from `GET /kyc/user-documents`.
class KycUserDocument {
  const KycUserDocument({
    required this.kycDocId,
    required this.documentNameId,
    required this.documentName,
    this.userName = '',
    this.userType = '',
    this.documentUrl = '',
    this.bytes,
    this.status = 'PENDING',
  });

  /// Review status as sent by the backend (`PENDING`, `APPROVED`,
  /// `REJECTED`), upper-cased.
  final String status;

  bool get isRejected => status.contains('REJECT');
  bool get isApproved => status.contains('APPROV');

  final int kycDocId;
  final int documentNameId;
  final String documentName;
  final String userName;
  final String userType;

  /// Stored document data as returned by the backend.
  final String documentUrl;

  /// Decoded [documentUrl] when it is Base64 PNG/JPEG data, else null.
  final Uint8List? bytes;

  static Uint8List? _decodeImage(String raw) {
    if (raw.isEmpty) return null;
    try {
      final data = raw.contains(',') ? raw.split(',').last : raw;
      final decoded = base64Decode(data.replaceAll(RegExp(r'\s'), ''));
      if (decoded.length < 4) return null;
      final isPng = decoded[0] == 0x89 && decoded[1] == 0x50;
      final isJpg = decoded[0] == 0xFF && decoded[1] == 0xD8;
      return (isPng || isJpg) ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  factory KycUserDocument.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
    final url = json['documentUrl'] as String? ?? '';
    return KycUserDocument(
      bytes: _decodeImage(url),
      kycDocId: asInt(json['KYC_doc_id']),
      documentNameId: asInt(json['documentNameId']),
      documentName: json['documentName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userType: json['userType'] as String? ?? '',
      documentUrl: url,
      status:
          '${json['Document_Status'] ?? json['status'] ?? json['document_status'] ?? json['kyc_status'] ?? 'PENDING'}'
              .toUpperCase(),
    );
  }

  static List<KycUserDocument> listFromJson(dynamic json) {
    if (json is! List) return const [];
    return json
        .whereType<Map>()
        .map((e) => KycUserDocument.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}

/// Parsed `GET /kyc/user-documents` response.
class KycUserDocumentsResult {
  const KycUserDocumentsResult({required this.documents, this.sessionToken});

  final List<KycUserDocument> documents;

  /// Fresh token that must replace the one used for the request.
  final String? sessionToken;

  factory KycUserDocumentsResult.fromJson(dynamic json) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    return KycUserDocumentsResult(
      documents: KycUserDocument.listFromJson(map['data']),
      sessionToken: map['session_Token'] as String?,
    );
  }
}
