import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_response_data.dart';
import 'package:flutter_nivasshub/models/notifications/mock_notification_model.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_mock_ledger.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/notifications/notification_service_base.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';

/// Stands in for the whole reviewer side of KYC.
///
/// There is no admin app and none is planned, so the three verdicts are
/// produced here, deterministically, with no UI of any kind behind them.
/// Two rules, in priority order — see [_decideVerdict]:
///
/// 1. **Filename token.** A file named `approve.pdf`, `reject.jpg` or
///    `correct.pdf` forces that outcome. This mirrors the magic-value
///    convention `MockAuthService` already uses for OTP codes
///    (`'1234'`/`'1111'`/`'0000'`) and `'taken@example.com'`.
/// 2. **Attempt ladder.** Failing that, attempt 1 asks for a correction,
///    attempt 2 rejects, attempt 3 and beyond approve. So a tester who
///    simply taps through reaches all three branches in order, exercises
///    the correct-and-resubmit loop twice, and can never get stuck —
///    attempt ≥ 3 approves unconditionally.
///
/// Each failing attempt flags exactly one of the three documents, so
/// document preservation is visibly demonstrated on both loops.
///
/// The verdict is frozen at submit time; [getKycStatus] only reveals it
/// once enough wall-clock time has passed, and never re-decides.
class MockKycService implements KycServiceBase {
  MockKycService({
    required LocalStorageService storage,
    required NotificationServiceBase notificationService,
    required this.recipientResolver,
    required this.nameResolver,
  }) : _storage = storage,
       _notificationService = notificationService;

  final LocalStorageService _storage;
  final NotificationServiceBase _notificationService;

  /// Where the mock email is addressed. A callback rather than a stored
  /// value because the service is built once at startup, long before the
  /// user registers.
  final String Function() recipientResolver;
  final String Function() nameResolver;

  int _sequence = 10000;

  @override
  Future<ApiResponse<KycSubmitResponseData>> submitKyc(
    KycSubmitRequest request,
  ) async {
    if (request.kycToken.isEmpty) {
      return _failure(KycStrings.genericError, ApiExceptionType.unauthorized);
    }

    // Invalid Input: a manifest must carry all three documents. The UI's
    // submit gate already guarantees this; the server checks anyway.
    final expected = KycDocumentCatalog.typesForRole(request.role);
    final submitted = request.documents.map((d) => d.documentType).toSet();
    if (!expected.every(submitted.contains)) {
      return _failure(
        'Please upload all ${expected.length} required documents.',
        ApiExceptionType.validation,
      );
    }

    await Future<void>.delayed(KycConfig.mockDelay);

    _sequence++;
    final kycId = 'KYC$_sequence';
    final verdict = _decideVerdict(request);

    await KycMockLedger.write(
      _storage,
      KycMockLedger(
        kycId: kycId,
        attemptNumber: request.attemptNumber,
        submittedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
        verdict: verdict.status,
        issues: verdict.issues,
        reason: verdict.reason,
      ),
    );

    debugPrint(
      '[MockKyc] $kycId submitted (attempt ${request.attemptNumber}) '
      '-> frozen verdict ${verdict.status.wireValue}',
    );

    return ApiResponse.success(
      KycSubmitResponseData(
        kycId: kycId,
        status: KycVerificationStatus.underReview,
        submittedAt: DateTime.now(),
        message: 'KYC submitted successfully',
      ),
    );
  }

  @override
  Future<ApiResponse<KycStatusResponseData>> getKycStatus({
    required String kycId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final ledger = KycMockLedger.read(_storage);
    if (ledger == null || ledger.kycId != kycId) {
      return _failure(KycStrings.statusFetchFailed, ApiExceptionType.notFound);
    }

    final elapsed = ledger.elapsed;
    final stageStatus = _stageFor(elapsed);

    // Still progressing — the frozen verdict stays hidden.
    if (stageStatus != null) {
      return ApiResponse.success(
        KycStatusResponseData(
          kycId: kycId,
          status: stageStatus,
          stage: KycReviewStage.fromStatus(stageStatus),
          canResubmit: false,
        ),
      );
    }

    // Terminal. Fire the email exactly once — polling runs every two
    // seconds and a restart re-reads the same ledger, so the guard must
    // live here (in the persisted record) and not in the provider.
    if (!ledger.notificationSent) {
      await KycMockLedger.write(
        _storage,
        ledger.copyWith(notificationSent: true),
      );
      await _sendNotification(ledger);
    }

    return ApiResponse.success(
      KycStatusResponseData(
        kycId: kycId,
        status: ledger.verdict,
        stage: KycReviewStage.processing,
        reason: ledger.reason,
        invalidDocuments: ledger.issues,
        reviewedAt: DateTime.fromMillisecondsSinceEpoch(
          ledger.submittedAtEpochMs,
        ).add(KycConfig.stageProcessingUntil),
        canResubmit: ledger.verdict.needsResubmission,
      ),
    );
  }

  @override
  Future<void> reset() => KycMockLedger.clear(_storage);

  // -------------------------------------------------------------------
  // Verdict policy
  // -------------------------------------------------------------------

  _Verdict _decideVerdict(KycSubmitRequest request) {
    if (KycConfig.mockAlwaysApprove) return const _Verdict.approved();

    final tokenVerdict = _verdictFromFilenames(request);
    if (tokenVerdict != null) return tokenVerdict;

    final ownershipProof = KycDocumentCatalog.ownershipProofFor(request.role);

    return switch (request.attemptNumber) {
      1 => _Verdict(
        status: KycVerificationStatus.correctionRequired,
        reason:
            'Your second address proof is not legible. '
            'Please upload a clearer copy.',
        issues: const [
          KycDocumentIssue(
            documentType: KycDocumentType.addressProofTwo,
            reason: 'The document is blurred and could not be read.',
          ),
        ],
      ),
      2 => _Verdict(
        status: KycVerificationStatus.rejected,
        reason:
            'The ownership document could not be matched against '
            'society records.',
        issues: [
          KycDocumentIssue(
            documentType: ownershipProof,
            reason:
                'The name on this document does not match your '
                'registered details.',
          ),
        ],
      ),
      // Attempt 3 and beyond approve unconditionally, so the
      // correct-and-resubmit loop provably terminates.
      _ => const _Verdict.approved(),
    };
  }

  /// Lets a tester jump straight to any branch by naming the file, without
  /// walking the ladder — and without any admin control existing.
  _Verdict? _verdictFromFilenames(KycSubmitRequest request) {
    bool matches(String token, String name) =>
        name.toLowerCase().contains(token);

    if (request.documents.any((d) => matches('approve', d.fileName))) {
      return const _Verdict.approved();
    }

    for (final token in const ['reject', 'correct']) {
      final flagged = request.documents
          .where((d) => matches(token, d.fileName))
          .map((d) => d.documentType)
          .toList(growable: false);
      if (flagged.isEmpty) continue;

      final isRejection = token == 'reject';
      return _Verdict(
        status: isRejection
            ? KycVerificationStatus.rejected
            : KycVerificationStatus.correctionRequired,
        reason: isRejection
            ? 'One or more documents could not be verified.'
            : 'One or more documents need to be re-uploaded.',
        issues: flagged
            .map(
              (type) => KycDocumentIssue(
                documentType: type,
                reason: isRejection
                    ? 'This document was not accepted.'
                    : 'Please upload a clearer copy of this document.',
              ),
            )
            .toList(growable: false),
      );
    }

    return null;
  }

  /// The review animation, driven by wall-clock elapsed rather than an
  /// in-memory counter so it resumes correctly after a process death.
  /// Returns `null` once the terminal verdict is due.
  static KycVerificationStatus? _stageFor(Duration elapsed) {
    if (elapsed < KycConfig.stageSubmittedUntil) {
      return KycVerificationStatus.submitted;
    }
    if (elapsed < KycConfig.stageUnderReviewUntil) {
      return KycVerificationStatus.underReview;
    }
    if (elapsed < KycConfig.stageAdminReviewUntil) {
      return KycVerificationStatus.adminReview;
    }
    if (elapsed < KycConfig.stageProcessingUntil) {
      return KycVerificationStatus.processing;
    }
    return null;
  }

  Future<void> _sendNotification(KycMockLedger ledger) {
    final type = switch (ledger.verdict) {
      KycVerificationStatus.approved => MockNotificationType.kycApproved,
      KycVerificationStatus.rejected => MockNotificationType.kycRejected,
      _ => MockNotificationType.kycCorrectionRequired,
    };

    return _notificationService.sendKycNotification(
      type: type,
      recipient: recipientResolver(),
      userFullName: nameResolver(),
      reason: ledger.reason,
      issues: ledger.issues,
    );
  }

  static ApiResponse<T> _failure<T>(String message, ApiExceptionType type) {
    return ApiResponse.failure(ApiException(message: message, type: type));
  }
}

/// A frozen decision: the outcome plus why.
class _Verdict {
  const _Verdict({required this.status, required this.issues, this.reason});

  const _Verdict.approved()
    : status = KycVerificationStatus.approved,
      issues = const [],
      reason = null;

  final KycVerificationStatus status;
  final List<KycDocumentIssue> issues;
  final String? reason;
}
