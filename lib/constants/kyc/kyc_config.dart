import 'package:flutter_nivasshub/constants/app_constants.dart';

/// Feature flag + tunable constants for the KYC / auth-entry flow.
///
/// Mirrors `constants/auth/auth_config.dart` — flipping [useMockKycApi] to
/// `false` swaps every mock service for its Dio-backed twin at the
/// composition root (`main.dart`) without any screen or provider knowing.
class KycConfig {
  KycConfig._();

  /// No real backend exists for KYC yet. See `MockKycService`.
  static const bool useMockKycApi = true;

  // ---------------------------------------------------------------------
  // Uploads
  //
  // Deliberately NOT `AppConstants.allowedDocumentExtensions`, which is
  // `['pdf','doc','docx']` — a general contract with other consumers. KYC
  // accepts images and rejects Word documents, so it keeps its own list.
  // The size limit *is* shared, so 5 MB stays defined in one place.
  // ---------------------------------------------------------------------
  static const List<String> allowedKycExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
  ];
  static const int maxKycFileSizeBytes = AppConstants.maxUploadSizeBytes;

  // ---------------------------------------------------------------------
  // Mock timing
  // ---------------------------------------------------------------------

  /// Artificial latency on every mock call so the UI's loaders are real.
  static const Duration mockDelay = Duration(milliseconds: 800);

  /// How often the verification-status screen re-polls `getKycStatus`.
  static const Duration statusPollInterval = Duration(seconds: 2);

  // Review-stage windows, measured from `submittedAt`. Computed from
  // wall-clock rather than a counter so the progression survives a restart.
  static const Duration stageSubmittedUntil = Duration(seconds: 3);
  static const Duration stageUnderReviewUntil = Duration(seconds: 6);
  static const Duration stageAdminReviewUntil = Duration(seconds: 9);
  static const Duration stageProcessingUntil = Duration(seconds: 12);

  // ---------------------------------------------------------------------
  // Mock verdict policy
  // ---------------------------------------------------------------------

  /// Demo shortcut: when `true` every submission approves immediately,
  /// skipping the correction/rejection ladder in `MockKycService`.
  static const bool mockAlwaysApprove = false;
}
