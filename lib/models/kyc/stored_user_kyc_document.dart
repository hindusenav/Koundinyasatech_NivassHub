/// Stored user KYC document returned by `GET /kyc/user-documents`.
class StoredUserKycDocument {
  const StoredUserKycDocument({
    required this.kycDocId,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.documentNameId,
    required this.documentName,
    required this.documentUrl,
  });

  final int kycDocId;
  final int userId;
  final String userName;
  final String userType;
  final int documentNameId;
  final String documentName;
  final String documentUrl;

  factory StoredUserKycDocument.fromJson(Map<String, dynamic> json) {
    final rawDocId = json['KYC_doc_id'] ?? json['kycDocId'];
    final rawUserId = json['user_id'] ?? json['userId'];
    final rawDocNameId = json['documentNameId'] ?? json['document_name_id'];

    return StoredUserKycDocument(
      kycDocId: rawDocId is int ? rawDocId : int.tryParse('$rawDocId') ?? 0,
      userId: rawUserId is int ? rawUserId : int.tryParse('$rawUserId') ?? 0,
      userName: json['userName'] as String? ?? '',
      userType: json['userType'] as String? ?? '',
      documentNameId: rawDocNameId is int
          ? rawDocNameId
          : int.tryParse('$rawDocNameId') ?? 0,
      documentName: json['documentName'] as String? ?? '',
      documentUrl: json['documentUrl'] as String? ?? '',
    );
  }

  static List<StoredUserKycDocument> listFromJson(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => StoredUserKycDocument.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}

/// Response payload from `GET /kyc/user-documents`.
class StoredUserKycResponseData {
  const StoredUserKycResponseData({
    required this.sessionToken,
    required this.documents,
  });

  final String? sessionToken;
  final List<StoredUserKycDocument> documents;

  factory StoredUserKycResponseData.fromJson(Map<String, dynamic> json) {
    final token = (json['session_Token'] ?? json['sessionToken']) as String?;
    final list = json['data'];
    return StoredUserKycResponseData(
      sessionToken: token,
      documents: StoredUserKycDocument.listFromJson(list),
    );
  }
}
