import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';

/// One entry in a submission's document manifest.
///
/// Carries only the id and display name — never the bytes, which were
/// already uploaded. This is why a preserved document costs nothing to
/// resubmit.
class KycSubmitDocument {
  const KycSubmitDocument({
    required this.documentType,
    required this.documentId,
    required this.fileName,
  });

  final KycDocumentType documentType;
  final String documentId;
  final String fileName;

  Map<String, dynamic> toJson() => {
    'documentType': documentType.wireValue,
    'documentId': documentId,
    'fileName': fileName,
  };
}

/// Body of `POST /kyc/submit`.
class KycSubmitRequest {
  const KycSubmitRequest({
    required this.kycToken,
    required this.userId,
    required this.role,
    required this.documents,
    required this.attemptNumber,
    this.previousKycId,
  });

  final String kycToken;
  final String userId;
  final UserRole role;
  final List<KycSubmitDocument> documents;

  /// 1-based. Drives the mock verdict ladder; the real backend can ignore it.
  final int attemptNumber;

  /// Set when this submission corrects an earlier, rejected one.
  final String? previousKycId;

  /// Builds the manifest from the provider's slots. Slots without a
  /// `documentId` are skipped rather than sent empty — the Submit gate
  /// already guarantees there are none, so this is belt-and-braces.
  factory KycSubmitRequest.fromSlots({
    required String kycToken,
    required String userId,
    required UserRole role,
    required Iterable<KycDocumentSlot> slots,
    required int attemptNumber,
    String? previousKycId,
  }) {
    return KycSubmitRequest(
      kycToken: kycToken,
      userId: userId,
      role: role,
      attemptNumber: attemptNumber,
      previousKycId: previousKycId,
      documents: slots
          .where((slot) => slot.uploaded != null)
          .map(
            (slot) => KycSubmitDocument(
              documentType: slot.type,
              documentId: slot.uploaded!.documentId,
              fileName: slot.uploaded!.fileName,
            ),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'kycToken': kycToken,
    'userId': userId,
    'role': role.wireValue,
    'attemptNumber': attemptNumber,
    if (previousKycId != null) 'previousKycId': previousKycId,
    'documents': documents.map((d) => d.toJson()).toList(),
  };
}
