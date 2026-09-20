import 'package:flutter_nivasshub/models/kyc/document_upload_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';

/// Lifecycle of one document card.
enum KycUploadStatus {
  /// Nothing chosen yet.
  empty,

  /// The OS picker is open.
  picking,

  /// Bytes in flight.
  uploading,

  /// Uploaded during this attempt.
  uploaded,

  /// Accepted on a previous attempt and carried forward unchanged — no
  /// re-upload needed, only its `documentId` is re-sent.
  preserved,

  /// The upload call failed; the card offers Retry.
  failed;

  String get wireValue => name;

  /// Both count towards the Submit gate: each carries a `documentId`.
  bool get isSatisfied =>
      this == KycUploadStatus.uploaded || this == KycUploadStatus.preserved;

  bool get isBusy =>
      this == KycUploadStatus.picking || this == KycUploadStatus.uploading;

  static KycUploadStatus fromJson(dynamic value) {
    for (final status in KycUploadStatus.values) {
      if (status.wireValue == value) return status;
    }
    return KycUploadStatus.empty;
  }
}

/// The state of a single document card, and the unit of persistence that
/// makes document preservation across a resubmit work.
///
/// `uploaded.documentId` is the load-bearing field: it is what
/// `KycSubmitRequest` sends, so a carried-forward document needs nothing
/// but its id and its display metadata.
class KycDocumentSlot {
  const KycDocumentSlot({
    required this.type,
    this.status = KycUploadStatus.empty,
    this.uploaded,
    this.errorMessage,
    this.issueReason,
  });

  final KycDocumentType type;
  final KycUploadStatus status;

  /// Present whenever [status] is `uploaded` or `preserved`.
  final DocumentUploadResponseData? uploaded;

  /// A client-side or upload failure, shown inline on the card.
  final String? errorMessage;

  /// The reviewer's objection to the *previous* version of this document,
  /// shown on the resubmit screen. Distinct from [errorMessage] so a fresh
  /// pick can clear the upload error without erasing why it was flagged.
  final String? issueReason;

  bool get isSatisfied => status.isSatisfied && uploaded != null;

  bool get needsReplacement => issueReason != null && !isSatisfied;

  /// `copyWith` cannot null a field, so clearing is explicit. Every one of
  /// these is needed somewhere: removing a document clears `uploaded`,
  /// re-picking clears `errorMessage`, a successful re-upload clears
  /// `issueReason`.
  KycDocumentSlot copyWith({
    KycUploadStatus? status,
    DocumentUploadResponseData? uploaded,
    String? errorMessage,
    String? issueReason,
    bool clearUploaded = false,
    bool clearError = false,
    bool clearIssue = false,
  }) {
    return KycDocumentSlot(
      type: type,
      status: status ?? this.status,
      uploaded: clearUploaded ? null : (uploaded ?? this.uploaded),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      issueReason: clearIssue ? null : (issueReason ?? this.issueReason),
    );
  }

  /// Transient states are never persisted — a slot caught mid-upload by a
  /// process death must come back as `empty`, not as a permanently
  /// spinning card.
  Map<String, dynamic> toJson() {
    final persistable = status.isSatisfied ? status : KycUploadStatus.empty;
    return {
      'documentType': type.wireValue,
      'status': persistable.wireValue,
      'uploaded': uploaded?.toJson(),
      'issueReason': issueReason,
    };
  }

  static KycDocumentSlot? tryFromJson(Map<String, dynamic> json) {
    final type = KycDocumentType.tryFromJson(json['documentType']);
    if (type == null) return null;

    final rawUploaded = json['uploaded'];
    final uploaded = rawUploaded is Map
        ? DocumentUploadResponseData.fromJson(
            Map<String, dynamic>.from(rawUploaded),
          )
        : null;

    var status = KycUploadStatus.fromJson(json['status']);
    // A satisfied status with no document behind it would break the
    // submit gate, so demote rather than trust the blob.
    if (status.isSatisfied && uploaded == null) {
      status = KycUploadStatus.empty;
    }

    return KycDocumentSlot(
      type: type,
      status: status,
      uploaded: uploaded,
      issueReason: json['issueReason'] as String?,
    );
  }
}
