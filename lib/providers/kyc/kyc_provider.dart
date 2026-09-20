import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/document_upload_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/document_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';

enum KycProviderState { initial, ready, submitting, submitted, error }

/// Owns the three document cards: picking, uploading, removing,
/// submitting, and rehydrating them for a correction.
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
    required LocalStorageService localStorage,
    required AuthStateProvider authState,
  }) : _documentService = documentService,
       _kycService = kycService,
       _filePickerService = filePickerService,
       _localStorage = localStorage,
       _authState = authState;

  final DocumentServiceBase _documentService;
  final KycServiceBase _kycService;
  final FilePickerServiceBase _filePickerService;
  final LocalStorageService _localStorage;
  final AuthStateProvider _authState;

  KycProviderState _state = KycProviderState.initial;
  UserRole _role = UserRole.owner;
  String _kycToken = '';
  String _userId = '';
  String? _previousKycId;
  String? _rejectionReason;
  int _attemptNumber = 1;
  String? _errorMessage;
  String? _submittedKycId;

  final Map<KycDocumentType, KycDocumentSlot> _slots = {};

  KycProviderState get state => _state;
  UserRole get role => _role;
  int get attemptNumber => _attemptNumber;
  String? get errorMessage => _errorMessage;
  String? get rejectionReason => _rejectionReason;
  String? get submittedKycId => _submittedKycId;
  bool get isSubmitting => _state == KycProviderState.submitting;
  bool get isResubmission => _previousKycId != null;

  /// The three cards in display order, driven entirely by the role — the
  /// screen never branches on it itself.
  ///
  /// Derived from the populated slot map rather than from the catalog, so
  /// it is genuinely empty before [initialise] and after [reset]. Deriving
  /// it from the catalog instead would hand back three phantom cards
  /// carrying whatever role was last used.
  List<KycDocumentSlot> get slots => KycDocumentCatalog.typesForRole(_role)
      .map((type) => _slots[type])
      .whereType<KycDocumentSlot>()
      .toList(growable: false);

  KycDocumentSlot slotFor(KycDocumentType type) =>
      _slots[type] ?? KycDocumentSlot(type: type);

  /// Submit is enabled only when all three carry a `documentId` — freshly
  /// uploaded or preserved from a previous attempt, which are equivalent
  /// as far as the manifest is concerned.
  ///
  /// `every` on an empty list is vacuously true, so the emptiness check is
  /// load-bearing: without it an uninitialised provider would report that
  /// it is ready to submit nothing.
  bool get canSubmit =>
      !isSubmitting && slots.isNotEmpty && slots.every((s) => s.isSatisfied);

  // -------------------------------------------------------------------
  // Setup
  // -------------------------------------------------------------------

  /// Prepares the provider for a first submission or a correction.
  ///
  /// [invalidDocuments] and [rejectionReason] come from the verdict, and
  /// are what turn this into a resubmission.
  Future<void> initialise({
    required String userId,
    required String kycToken,
    required UserRole role,
    String? resubmitKycId,
    List<KycDocumentIssue> invalidDocuments = const [],
    String? rejectionReason,
  }) async {
    _userId = userId;
    _kycToken = kycToken;
    _role = role;
    _previousKycId = resubmitKycId;
    _rejectionReason = rejectionReason;
    _errorMessage = null;
    _submittedKycId = null;

    final stored = _readStoredDocuments();
    final isSameApplication = stored != null && stored.role == role;

    _attemptNumber = resubmitKycId == null
        ? 1
        : (isSameApplication ? stored.attemptNumber + 1 : 1);

    _slots
      ..clear()
      ..addEntries(
        KycDocumentCatalog.typesForRole(role).map(
          (type) => MapEntry(
            type,
            _hydrateSlot(
              type: type,
              stored: isSameApplication ? stored.slots[type] : null,
              issue: _issueFor(invalidDocuments, type),
            ),
          ),
        ),
      );

    _state = KycProviderState.ready;
    notifyListeners();
  }

  /// A flagged document is cleared so it must be replaced; anything else
  /// that previously uploaded is carried forward untouched.
  ///
  /// If the cache is missing or belongs to a different role the slot comes
  /// back empty — a wiped cache must not brick the loop, it just means the
  /// user re-uploads.
  KycDocumentSlot _hydrateSlot({
    required KycDocumentType type,
    required KycDocumentSlot? stored,
    required KycDocumentIssue? issue,
  }) {
    if (issue != null) {
      return KycDocumentSlot(
        type: type,
        status: KycUploadStatus.empty,
        issueReason: issue.reason,
      );
    }
    if (stored != null && stored.uploaded != null) {
      return KycDocumentSlot(
        type: type,
        status: KycUploadStatus.preserved,
        uploaded: stored.uploaded,
      );
    }
    return KycDocumentSlot(type: type);
  }

  static KycDocumentIssue? _issueFor(
    List<KycDocumentIssue> issues,
    KycDocumentType type,
  ) {
    for (final issue in issues) {
      if (issue.documentType == type) return issue;
    }
    return null;
  }

  // -------------------------------------------------------------------
  // Upload
  // -------------------------------------------------------------------

  /// Picks a file for [type] and uploads it. A cancelled pick restores the
  /// card to whatever it showed before, without an error.
  Future<void> pickAndUpload(
    KycDocumentType type,
    FilePickSource source,
  ) async {
    final previous = slotFor(type);

    _update(
      type,
      previous.copyWith(status: KycUploadStatus.picking, clearError: true),
    );

    final picked = await _filePickerService.pick(source: source);

    if (picked.isFailure) {
      _update(
        type,
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
      _update(type, previous);
      return;
    }

    _update(
      type,
      previous.copyWith(status: KycUploadStatus.uploading, clearError: true),
    );

    final response = await _documentService.uploadDocument(
      DocumentUploadRequest(
        kycToken: _kycToken,
        documentType: type,
        file: file,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _update(
        type,
        KycDocumentSlot(
          type: type,
          status: KycUploadStatus.uploaded,
          uploaded: response.data,
        ),
      );
      await _persistDocuments();
      return;
    }

    _update(
      type,
      previous.copyWith(
        status: KycUploadStatus.failed,
        errorMessage: response.message ?? KycStrings.uploadFailed,
        clearUploaded: true,
      ),
    );
  }

  /// Clears a card. The server-side delete is fire-and-forget: the user
  /// has already been told it is gone, and a failed cleanup must not
  /// block them from choosing a replacement.
  Future<void> remove(KycDocumentType type) async {
    final slot = slotFor(type);
    final documentId = slot.uploaded?.documentId;

    _update(type, KycDocumentSlot(type: type, issueReason: slot.issueReason));
    await _persistDocuments();

    if (documentId != null) {
      unawaited(
        _documentService.deleteDocument(
          kycToken: _kycToken,
          documentId: documentId,
        ),
      );
    }
  }

  void _update(KycDocumentType type, KycDocumentSlot slot) {
    _slots[type] = slot;
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
        role: _role,
        slots: slots,
        attemptNumber: _attemptNumber,
        previousKycId: _previousKycId,
      ),
    );

    if (response.isSuccess && response.data != null) {
      _submittedKycId = response.data!.kycId;
      _state = KycProviderState.submitted;

      // Persisted before the state moves on, so the documents survive a
      // process death between submitting and the verdict arriving.
      await _persistDocuments();
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

  /// Drops every trace of the current application — called on logout and
  /// once an approval has been exchanged for an access token.
  Future<void> reset() async {
    _slots.clear();
    _state = KycProviderState.initial;
    _kycToken = '';
    _userId = '';
    _previousKycId = null;
    _rejectionReason = null;
    _submittedKycId = null;
    _attemptNumber = 1;
    _errorMessage = null;

    await _localStorage.remove(StorageKeys.kycUploadedDocuments);
    await _kycService.reset();
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // Persistence — the document-preservation record
  // -------------------------------------------------------------------

  Future<void> _persistDocuments() {
    return _localStorage.setJson(StorageKeys.kycUploadedDocuments, {
      'role': _role.wireValue,
      'attemptNumber': _attemptNumber,
      'slots': _slots.values.map((slot) => slot.toJson()).toList(),
    });
  }

  _StoredDocuments? _readStoredDocuments() {
    try {
      final raw = _localStorage.getJson(StorageKeys.kycUploadedDocuments);
      if (raw is! Map) return null;
      final map = Map<String, dynamic>.from(raw);

      final role = UserRole.tryFromJson(map['role']);
      if (role == null) return null;

      final rawSlots = map['slots'];
      final slots = <KycDocumentType, KycDocumentSlot>{};
      if (rawSlots is List) {
        for (final entry in rawSlots.whereType<Map>()) {
          final slot = KycDocumentSlot.tryFromJson(
            Map<String, dynamic>.from(entry),
          );
          if (slot != null) slots[slot.type] = slot;
        }
      }

      return _StoredDocuments(
        role: role,
        attemptNumber: map['attemptNumber'] as int? ?? 1,
        slots: slots,
      );
    } catch (e, stack) {
      // A corrupt cache must degrade to "upload everything again", never
      // to a crash on the way into the KYC screen.
      debugPrint('[Kyc] could not read stored documents: $e\n$stack');
      return null;
    }
  }
}

class _StoredDocuments {
  const _StoredDocuments({
    required this.role,
    required this.attemptNumber,
    required this.slots,
  });

  final UserRole role;
  final int attemptNumber;
  final Map<KycDocumentType, KycDocumentSlot> slots;
}
