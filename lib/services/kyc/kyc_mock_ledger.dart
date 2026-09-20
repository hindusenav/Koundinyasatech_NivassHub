import 'package:flutter_nivasshub/constants/storage_keys.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';

/// The persisted record of one mock KYC submission.
///
/// `MockKycService` decides a verdict *once*, at submit time, and freezes
/// it here. Status polling then only reveals it as wall-clock time
/// elapses — so the review progression survives a cold restart, and a
/// relaunch thirty seconds later shows the terminal verdict immediately
/// rather than replaying the animation.
///
/// Kept out of `mock_kyc_service.dart` so the verdict rule there reads as
/// policy rather than as storage plumbing.
class KycMockLedger {
  const KycMockLedger({
    required this.kycId,
    required this.attemptNumber,
    required this.submittedAtEpochMs,
    required this.verdict,
    this.issues = const [],
    this.reason,
    this.notificationSent = false,
  });

  final String kycId;

  /// 1-based. Drives the default verdict ladder.
  final int attemptNumber;

  final int submittedAtEpochMs;

  /// Decided at submit time and never recomputed.
  final KycVerificationStatus verdict;

  final List<KycDocumentIssue> issues;
  final String? reason;

  /// Set the first time a terminal status is observed, so polling every
  /// two seconds (and restarting the app) cannot re-send the same email.
  final bool notificationSent;

  Duration get elapsed => Duration(
    milliseconds: DateTime.now().millisecondsSinceEpoch - submittedAtEpochMs,
  );

  KycMockLedger copyWith({bool? notificationSent}) => KycMockLedger(
    kycId: kycId,
    attemptNumber: attemptNumber,
    submittedAtEpochMs: submittedAtEpochMs,
    verdict: verdict,
    issues: issues,
    reason: reason,
    notificationSent: notificationSent ?? this.notificationSent,
  );

  Map<String, dynamic> toJson() => {
    'kycId': kycId,
    'attemptNumber': attemptNumber,
    'submittedAtEpochMs': submittedAtEpochMs,
    'verdict': verdict.wireValue,
    'issues': issues.map((i) => i.toJson()).toList(),
    'reason': reason,
    'notificationSent': notificationSent,
  };

  factory KycMockLedger.fromJson(Map<String, dynamic> json) {
    return KycMockLedger(
      kycId: json['kycId'] as String? ?? '',
      attemptNumber: json['attemptNumber'] as int? ?? 1,
      submittedAtEpochMs: json['submittedAtEpochMs'] as int? ?? 0,
      verdict: KycVerificationStatus.fromJson(json['verdict']),
      issues: KycDocumentIssue.listFromJson(json['issues']),
      reason: json['reason'] as String?,
      notificationSent: json['notificationSent'] as bool? ?? false,
    );
  }

  // -------------------------------------------------------------------
  // Persistence
  // -------------------------------------------------------------------

  static KycMockLedger? read(LocalStorageService storage) {
    final raw = storage.getJson(StorageKeys.kycMockLedger);
    if (raw is! Map) return null;
    return KycMockLedger.fromJson(Map<String, dynamic>.from(raw));
  }

  static Future<void> write(LocalStorageService storage, KycMockLedger ledger) {
    return storage.setJson(StorageKeys.kycMockLedger, ledger.toJson());
  }

  static Future<void> clear(LocalStorageService storage) {
    return storage.remove(StorageKeys.kycMockLedger);
  }
}
