import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_user_document.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';

enum KycProviderState { initial, loading, ready, submitting, submitted, error }

/// Owns the document cards: fetching which ones the backend requires,
/// picking, uploading, removing, submitting, and rehydrating them for a
/// correction.
///
/// The card list itself is never hardcoded — [initialise] always asks
/// `GET /kyc/documents` (via [DocumentServiceBase.getApplicableDocuments])
/// and renders exactly what comes back.
///
/// Global (and lazy) rather than route-scoped because the slot map has to
/// survive `/kyc/documents` → `/kyc/verification-status` → *back to*
/// `/kyc/documents`, and those transitions use `pushReplacement`, which
/// destroys a route-scoped provider. It also has to be reconstructable at
/// cold start, when the documents route was never on the stack.
/// [reset] on logout and on approval keeps the global lifetime honest.
class KycProvider extends ChangeNotifier {
  KycProvider({
    required DocumentServiceBase documentService,
    required KycServiceBase kycService,
    required FilePickerServiceBase filePickerService,
    required AuthStateProvider authState,
  }) : _documentService = documentService,
       _kycService = kycService,
       _filePickerService = filePickerService,
       _authState = authState;

  final DocumentServiceBase _documentService;
  final KycServiceBase _kycService;
  final FilePickerServiceBase _filePickerService;
  final AuthStateProvider _authState;

  KycProviderState _state = KycProviderState.initial;
  UserRole? _role;
  String _kycToken = '';
  String _userId = '';
  String? _previousKycId;
  String? _rejectionReason;
  int _attemptNumber = 1;
  String? _errorMessage;
  String? _submittedKycId;

  final Map<int, KycDocumentSlot> _slots = {};
  final List<int> _order = [];

  KycProviderState _storedState = KycProviderState.initial;
  List<KycUserDocument> _storedDocuments = const [];
  String? _storedError;

  KycProviderState get storedState => _storedState;
  List<KycUserDocument> get storedDocuments => _storedDocuments;
  String? get storedError => _storedError;

  KycProviderState get state => _state;
  UserRole? get role => _role;
  int get attemptNumber => _attemptNumber;
  String? get errorMessage => _errorMessage;
  String? get rejectionReason => _rejectionReason;
  String? get submittedKycId => _submittedKycId;

  /// Current (rotated) KYC session token.
  String get sessionToken => _userId;
  bool get isSubmitting => _state == KycProviderState.submitting;
  bool get isResubmission => _previousKycId != null;

  /// The cards in the order `GET /kyc/documents` returned them.
  List<KycDocumentSlot> get slots =>
      _order.map((id) => _slots[id]).whereType<KycDocumentSlot>().toList(
        growable: false,
      );

  KycDocumentSlot? slotFor(int documentId) => _slots[documentId];

  /// Submit is enabled only when every card carries a `documentId` —
  /// freshly uploaded or preserved from a previous attempt, which are
  /// equivalent as far as the manifest is concerned.
  ///
  /// `every` on an empty list is vacuously true, so the emptiness check is
  /// load-bearing: without it an uninitialised provider would report that
  /// it is ready to submit nothing.
  bool get canSubmit =>
      !isSubmitting &&
      _state != KycProviderState.submitted &&
      slots.isNotEmpty &&
      slots.every((s) => !s.document.isMandatory || s.isSatisfied);

  // -------------------------------------------------------------------
  // Setup
  // -------------------------------------------------------------------

  /// Prepares the provider for a first submission or a correction.
  ///
  /// Fetches the applicable document list for [userId]/[kycToken] from the
  /// backend (`GET /kyc/documents`) — the set and order of cards shown is
  /// whatever that call returns, never a client-side list.
  ///
  /// [invalidDocuments] and [rejectionReason] come from the verdict, and
  /// are what turn this into a resubmission.
  Future<void> initialise({
    required String userId,
    required String kycToken,
    UserRole? role,
    String? resubmitKycId,
    List<KycDocumentIssue> invalidDocuments = const [],
    String? rejectionReason,
    Set<int>? onlyDocumentIds,
  }) async {
    _userId = userId;
    _kycToken = kycToken;
    _role = role;
    _previousKycId = resubmitKycId;
    _rejectionReason = rejectionReason;
    _errorMessage = null;
    _submittedKycId = null;

    _state = KycProviderState.loading;
    notifyListeners();

    final response = await _documentService.getApplicableDocuments(
      userToken: userId,
    );

    if (!response.isSuccess) {
      _errorMessage = response.message ?? KycStrings.genericError;
      _state = KycProviderState.error;
      notifyListeners();
      return;
    }

    // A returning user only sees what is still outstanding: missing
    // mandatory documents and rejected ones.
    final documents = (response.data ?? const <KycApplicableDocument>[])
        .where(
          (d) => onlyDocumentIds == null || onlyDocumentIds.contains(d.documentId),
        )
        .toList(growable: false);
    _attemptNumber = 1;

    _order
      ..clear()
      ..addAll(documents.map((d) => d.documentId));

    _slots
      ..clear()
      ..addEntries(
        documents.map(
          (document) => MapEntry(
            document.documentId,
            _hydrateSlot(
              document: document,
              issue: _issueFor(invalidDocuments, document.documentId),
            ),
          ),
        ),
      );

    _state = KycProviderState.ready;
    notifyListeners();
  }

  /// A flagged document comes back empty with the reviewer's reason.
  KycDocumentSlot _hydrateSlot({
    required KycApplicableDocument document,
    required KycDocumentIssue? issue,
  }) {
    if (issue != null) {
      return KycDocumentSlot(
        document: document,
        status: KycUploadStatus.empty,
        issueReason: issue.reason,
      );
    }
    return KycDocumentSlot(document: document);
  }

  static KycDocumentIssue? _issueFor(
    List<KycDocumentIssue> issues,
    int documentId,
  ) {
    for (final issue in issues) {
      if (issue.documentId == documentId) return issue;
    }
    return null;
  }

  // -------------------------------------------------------------------
  // Upload
  // -------------------------------------------------------------------

  /// Picks a file for [documentId] and uploads it as `multipart/form-data`
  /// to `POST /kyc/re-upload` (`user_id`, `doc_id`, plus the file). A
  /// cancelled pick restores the card to whatever it showed before,
  /// without an error.
  Future<void> pickAndUpload(int documentId, FilePickSource source) async {
    final previous = slotFor(documentId);
    if (previous == null) return;

    _update(
      documentId,
      previous.copyWith(status: KycUploadStatus.picking, clearError: true),
    );

    final picked = await _filePickerService.pick(source: source);

    if (picked.isFailure) {
      _update(
        documentId,
        previous.copyWith(
          status: previous.isSatisfied
              ? previous.status
              : KycUploadStatus.failed,
          errorMessage: picked.message ?? KycStrings.genericError,
        ),
      );
      return;
    }

    final file = picked.data;
    if (file == null) {
      // Cancelled — put the card back exactly as it was.
      _update(documentId, previous);
      return;
    }

    // Restore the pre-pick state so uploadPicked sees the document that is
    // really on the server (not a transient "picking" card).
    _update(documentId, previous);
    await uploadPicked(documentId, file);
  }

  /// Uploads an already-picked [file] for [documentId] — the shared second
  /// half of [pickAndUpload], also used directly once a screen has shown
  /// its own preview/confirmation step (in-app camera capture, or a
  /// local-file preview sheet) ahead of calling this.
  Future<void> uploadPicked(int documentId, PickedFile file) async {
    final previous = slotFor(documentId);
    if (previous == null) return;
    // A second tap or rebuild while this document is in flight must not
    // fire a duplicate upload.
    if (previous.status == KycUploadStatus.uploading) return;

    _update(
      documentId,
      previous.copyWith(status: KycUploadStatus.uploading, clearError: true),
    );

    final response = await _documentService.uploadDocument(
      DocumentUploadRequest(
        userId: _userId,
        documentId: documentId,
        documentName: previous.document.documentName,
        file: file,
        isReupload:
            previous.document.alreadyUploaded || previous.uploaded != null,
      ),
    );

    if (response.isSuccess && response.data != null) {
      // Token rotation: each successful upload returns a fresh token that
      // replaces the current one for every later call.
      final rotated = response.data!.sessionToken;
      if (rotated != null && rotated.isNotEmpty) _userId = rotated;
      _update(
        documentId,
        KycDocumentSlot(
          document: previous.document,
          status: KycUploadStatus.uploaded,
          uploaded: response.data,
        ),
      );
      // 202: everything is submitted. Nothing is stored locally; only this
      // provider's in-memory token stays, for the status screen's request.
      if (response.data!.allDocumentsUploaded) {
        await _authState.clearKycLocalData();
      }
      return;
    }

    final message = response.message ?? KycStrings.uploadFailed;
    if (previous.isSatisfied) {
      // A rejected replacement (e.g. 409 pending) leaves the server's copy
      // untouched, so the card keeps showing the document already uploaded.
      _update(documentId, previous.copyWith(errorMessage: message));
      return;
    }
    _update(
      documentId,
      previous.copyWith(
        status: KycUploadStatus.failed,
        errorMessage: message,
        clearUploaded: true,
      ),
    );
  }

  /// Clears a card. The server-side delete is fire-and-forget: the user
  /// has already been told it is gone, and a failed cleanup must not
  /// block them from choosing a replacement.
  Future<void> remove(int documentId) async {
    final slot = slotFor(documentId);
    if (slot == null) return;

    _update(
      documentId,
      KycDocumentSlot(document: slot.document, issueReason: slot.issueReason),
    );
    unawaited(
      _documentService.deleteDocument(userId: _userId, documentId: documentId),
    );
  }

  void _update(int documentId, KycDocumentSlot slot) {
    _slots[documentId] = slot;
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // Submit
  // -------------------------------------------------------------------

  Future<bool> submit() async {
    if (!canSubmit) return false;

    _state = KycProviderState.submitting;
    _errorMessage = null;
    notifyListeners();

    final response = await _kycService.submitKyc(
      KycSubmitRequest.fromSlots(
        kycToken: _kycToken,
        userId: _userId,
        // Falls back when the role wasn't known at `initialise` (arriving
        // here from the "KYC pending" login case) — `/kyc/submit` itself
        // is still mocked, with no documented contract to say what it
        // does with this field.
        role: _role ?? UserRole.owner,
        slots: slots,
        attemptNumber: _attemptNumber,
        previousKycId: _previousKycId,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _submittedKycId = response.data!.kycId;
      _state = KycProviderState.submitted;

      await _authState.moveTo(
        AuthFlowState.underReview,
        context: _authState.context.copyWith(
          kycId: _submittedKycId,
          kycAttemptNumber: _attemptNumber,
        ),
      );

      notifyListeners();
      return true;
    }

    _errorMessage = response.message ?? KycStrings.submitFailed;
    _state = KycProviderState.error;
    notifyListeners();
    return false;
  }

  // -------------------------------------------------------------------
  // Stored documents (`GET /kyc/user-documents`)
  // -------------------------------------------------------------------

  /// Fetches what the backend has stored for the user, for the KYC status
  /// screen. [fallbackToken] is used when no upload happened in this
  /// process (cold start straight onto the status screen). The returned
  /// `session_Token` replaces the current token.
  Future<bool> loadStoredDocuments({required String fallbackToken}) async {
    _storedState = KycProviderState.loading;
    _storedError = null;
    notifyListeners();

    final token = _userId.isNotEmpty ? _userId : fallbackToken;
    final response = await _documentService.getUserDocuments(userToken: token);

    if (response.isSuccess && response.data != null) {
      final rotated = response.data!.sessionToken;
      _userId = (rotated != null && rotated.isNotEmpty) ? rotated : token;
      _storedDocuments = response.data!.documents;
      _storedState = KycProviderState.ready;
    } else {
      _storedError = response.message ?? KycStrings.statusFetchFailed;
      _storedState = KycProviderState.error;
    }
    notifyListeners();
    return _storedState == KycProviderState.ready;
  }

  /// Drops every trace of the current application — called on logout and
  /// once an approval has been exchanged for an access token.
  Future<void> reset() async {
    _slots.clear();
    _order.clear();
    _state = KycProviderState.initial;
    _kycToken = '';
    _userId = '';
    _previousKycId = null;
    _rejectionReason = null;
    _submittedKycId = null;
    _attemptNumber = 1;
    _errorMessage = null;
    _storedDocuments = const [];
    _storedState = KycProviderState.initial;
    _storedError = null;

    await _kycService.reset();
    notifyListeners();
  }
}
