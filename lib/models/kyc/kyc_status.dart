import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';

/// Every state a KYC submission can report. The first four are progress
/// stages; the last three are terminal verdicts.
enum KycVerificationStatus {
  submitted,
  underReview,
  adminReview,
  processing,
  approved,
  rejected,
  correctionRequired;

  /// SCREAMING_SNAKE on the wire, matching the spec's example payloads
  /// (`"status": "UNDER_REVIEW"`).
  String get wireValue => switch (this) {
    KycVerificationStatus.submitted => 'SUBMITTED',
    KycVerificationStatus.underReview => 'UNDER_REVIEW',
    KycVerificationStatus.adminReview => 'ADMIN_REVIEW',
    KycVerificationStatus.processing => 'PROCESSING',
    KycVerificationStatus.approved => 'APPROVED',
    KycVerificationStatus.rejected => 'REJECTED',
    KycVerificationStatus.correctionRequired => 'CORRECTION_REQUIRED',
  };

  /// No more polling once this is reached.
  bool get isTerminal =>
      this == KycVerificationStatus.approved ||
      this == KycVerificationStatus.rejected ||
      this == KycVerificationStatus.correctionRequired;

  /// Terminal but recoverable — the user can fix documents and resubmit.
  bool get needsResubmission =>
      this == KycVerificationStatus.rejected ||
      this == KycVerificationStatus.correctionRequired;

  static KycVerificationStatus fromJson(dynamic value) {
    for (final status in KycVerificationStatus.values) {
      if (status.wireValue == value) return status;
    }
    return KycVerificationStatus.submitted;
  }
}

/// The four steps of the progress indicator on the verification screen.
/// Separate from [KycVerificationStatus] because a terminal verdict is not
/// a step — it replaces the stepper rather than extending it.
enum KycReviewStage {
  submitted,
  underReview,
  adminReview,
  processing;

  String get label => switch (this) {
    KycReviewStage.submitted => KycStrings.stageSubmitted,
    KycReviewStage.underReview => KycStrings.stageUnderReview,
    KycReviewStage.adminReview => KycStrings.stageAdminReview,
    KycReviewStage.processing => KycStrings.stageProcessing,
  };

  String get wireValue => name;

  /// Maps a status onto the furthest stage it implies. A terminal verdict
  /// means every stage is complete, so the stepper stays fully lit behind
  /// the verdict panel.
  static KycReviewStage fromStatus(KycVerificationStatus status) =>
      switch (status) {
        KycVerificationStatus.submitted => KycReviewStage.submitted,
        KycVerificationStatus.underReview => KycReviewStage.underReview,
        KycVerificationStatus.adminReview => KycReviewStage.adminReview,
        _ => KycReviewStage.processing,
      };

  static KycReviewStage fromJson(dynamic value) {
    for (final stage in KycReviewStage.values) {
      if (stage.wireValue == value) return stage;
    }
    return KycReviewStage.submitted;
  }
}
