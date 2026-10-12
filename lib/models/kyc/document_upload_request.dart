import 'package:flutter_nivasshub/models/kyc/picked_file.dart';

/// Body of `POST /kyc/re-upload` — one document at a time, so a single
/// failure never invalidates the others. The file is first uploaded to
/// storage; `/kyc/re-upload` then receives [userId] (encrypted), [documentId]
/// as given by `GET /kyc/documents` for this card, and the stored file's URL.
class DocumentUploadRequest {
  const DocumentUploadRequest({
    required this.userId,
    required this.documentId,
    required this.documentName,
    required this.file,
  });

  /// The encrypted user identifier issued during registration/OTP
  /// verification — never a plain id, never decrypted or regenerated here.
  final String userId;

  final int documentId;
  final String documentName;
  final PickedFile file;
}
