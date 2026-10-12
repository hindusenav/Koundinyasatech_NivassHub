import 'package:flutter_nivasshub/models/kyc/picked_file.dart';

/// Multipart body of `POST /kyc/upload` (or `/kyc/re-upload`) — one document
/// at a time, so a single failure never invalidates the others: [userId]
/// (the latest session token), [documentId] as given by `GET /kyc/documents`
/// for this card, and the file.
class DocumentUploadRequest {
  const DocumentUploadRequest({
    required this.userId,
    required this.documentId,
    required this.documentName,
    required this.file,
    this.isReupload = false,
  });

  /// `true` sends the file to `POST /kyc/re-upload` (a document the backend
  /// already holds); `false` to `POST /kyc/upload`.
  final bool isReupload;

  /// The encrypted user identifier issued during registration/OTP
  /// verification — never a plain id, never decrypted or regenerated here.
  final String userId;

  final int documentId;
  final String documentName;
  final PickedFile file;
}
