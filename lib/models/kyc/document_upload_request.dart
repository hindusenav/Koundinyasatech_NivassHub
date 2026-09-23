import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';

/// Body of `POST /kyc/documents` — one document at a time, so a single
/// failure never invalidates the others.
class DocumentUploadRequest {
  const DocumentUploadRequest({
    required this.kycToken,
    required this.documentType,
    required this.file,
  });

  final String kycToken;
  final KycDocumentType documentType;
  final PickedFile file;

  /// The real service sends this as multipart with the bytes attached;
  /// `localPath` is what it streams from and is not itself transmitted.
  Map<String, dynamic> toJson() => {
    'kycToken': kycToken,
    'documentType': documentType.wireValue,
    'fileName': file.fileName,
    'fileType': file.extension,
    'mimeType': file.mimeType,
    'sizeBytes': file.sizeBytes,
    'localPath': file.path,
  };
}
