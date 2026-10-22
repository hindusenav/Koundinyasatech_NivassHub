import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_user_document.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_pick_helper.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_status_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_stage_indicator.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_verdict_panel.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_nivasshub/widgets/shared/dialogs/confirmation_dialog.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/status_chip.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:provider/provider.dart';

class KycVerificationStatusScreenArgs {
  const KycVerificationStatusScreenArgs({
    required this.kycId,
    required this.userId,
    required this.role,
  });

  final String kycId;
  final String userId;
  final UserRole role;
}

/// Review progress and outcome (spec §12–§15).
///
/// Polls until the status is terminal, then either mints the access token
/// and forwards to the Dashboard, or offers Correct & Re-submit.
class KycVerificationStatusScreen extends StatefulWidget {
  const KycVerificationStatusScreen({super.key, required this.args});

  final KycVerificationStatusScreenArgs args;

  @override
  State<KycVerificationStatusScreen> createState() =>
      _KycVerificationStatusScreenState();
}

class _KycVerificationStatusScreenState
    extends State<KycVerificationStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  /// The screen's one and only request: `GET /kyc/user-documents`. Its
  /// response rotates the session token, so it must not be repeated with
  /// the old one.
  Future<void> _load() async {
    if (!mounted) return;
    final status = context.read<KycStatusProvider>();
    final kyc = context.read<KycProvider>();
    status.setLoading();

    final ok = await kyc.loadStoredDocuments(fallbackToken: widget.args.userId);
    if (!mounted) return;

    if (!ok) {
      status.setError(kyc.storedError ?? KycStrings.statusFetchFailed);
      return;
    }
    status.evaluate(kyc.sessionToken, kyc.storedDocuments);
  }

  /// Rejected documents stay on this screen: the user re-uploads just the
  /// one they pick, then the stored documents are reloaded.
  Future<void> _reuploadDocument(KycUserDocument doc) async {
    final kyc = context.read<KycProvider>();
    final file = await pickKycFile(context);
    if (file == null || !mounted) return;

    final error = await kyc.reuploadStoredDocument(doc, file);
    if (!mounted) return;
    if (error != null) {
      CustomSnackbar.error(context, error);
      return;
    }
    CustomSnackbar.success(
      context,
      '${doc.documentName} re-uploaded. It is now under review.',
    );
    await _load();
  }

  /// Wipes the in-memory flow and session, then opens the user-check
  /// screen with every earlier screen removed from the stack.
  Future<void> _backToUserCheck() async {
    final authState = context.read<AuthStateProvider>();
    final kyc = context.read<KycProvider>();
    await authState.clear();
    await kyc.reset();
    if (!mounted) return;
    NavigationService.pushNamedAndRemoveUntil(AppRoutes.authEntry);
  }

  Future<void> _handleApproved() async {
    final provider = context.read<KycStatusProvider>();
    final kyc = context.read<KycProvider>();
    final dashboard = context.read<DashboardProvider>();

    final success = await provider.completeApproval();
    if (!mounted) return;

    if (!success) {
      CustomSnackbar.error(
        context,
        provider.errorMessage ?? KycStrings.genericError,
      );
      return;
    }

    // The application is finished — drop its documents and mock ledger so
    // a later registration on this device starts clean.
    await kyc.reset();
    if (!mounted) return;

    dashboard.refresh();
    NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KycStatusProvider>();

    return PopScope(
      // Review is not something to back out of — there is no earlier
      // screen to return to, since registration is already complete.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await ConfirmationDialog.show(
          context,
          title: StringConstants.exitConfirmationTitle,
          message: StringConstants.exitConfirmationMessage,
          confirmText: StringConstants.exit,
        );
        if (shouldExit && context.mounted) await _backToUserCheck();
      },
      child: FigmaHeaderScaffold(
        title:
            provider.status == KycVerificationStatus.rejected ||
                provider.status == KycVerificationStatus.correctionRequired
            ? 'Resubmission Required'
            : provider.isTerminal
            ? KycStrings.kycTitle
            : 'Verification Progress',
        showBackButton: false,
        body: SafeArea(top: false, child: _buildBody(context, provider)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, KycStatusProvider provider) {
    if (provider.state == KycStatusState.loading) {
      return const Loader(message: 'Fetching your verification status…');
    }

    if (provider.state == KycStatusState.error) {
      return CustomErrorWidget(
        message: provider.errorMessage ?? KycStrings.statusFetchFailed,
        onRetry: _load,
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final isRejected =
        provider.status == KycVerificationStatus.rejected ||
        provider.status == KycVerificationStatus.correctionRequired;

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isRejected) ...[
              const FigmaProgressStrip(
                label: 'Onboarding Progress',
                current: 3,
                total: 3,
              ),
              AppSpacing.gapMd,
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isRejected
                  ? Column(
                      key: const ValueKey(true),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ActionRequiredAlert(
                          title: KycStrings.verificationActionRequiredTitle,
                          body: KycStrings.verificationActionRequiredBody,
                        ),
                        AppSpacing.gapMd,
                        const _HowToCorrectCard(),
                      ],
                    )
                  : const SizedBox.shrink(key: ValueKey(false)),
            ),
            if (isRejected) AppSpacing.gapLg,
            if (!isRejected)
              FigmaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider.isTerminal
                              ? KycStrings.verificationTitle
                              : 'KYC Processing',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        StatusChip(
                          label: _statusLabel(provider.status).toUpperCase(),
                          type: _statusChipType(provider.status),
                        ),
                      ],
                    ),
                    AppSpacing.gapSm,
                    Text(
                      KycStrings.verificationBody,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textPrimary,
                      ),
                    ),
                    AppSpacing.gapMd,
                    KycStageIndicator(
                      stage: provider.stage,
                      isComplete: provider.isTerminal,
                    ),
                    AppSpacing.gapMd,
                    Divider(height: 1, color: FigmaColors.of(context).cardBorder),
                    AppSpacing.gapMd,
                    Center(
                      child: Text(
                        'Reference ID: ${widget.args.kycId}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            AppSpacing.gapLg,
            _SubmittedDocumentsSection(onReupload: _reuploadDocument),
            if (provider.status == KycVerificationStatus.approved) ...[
              AppSpacing.gapLg,
              KycVerdictPanel(
                status: provider.status,
                reason: provider.data?.reason,
                issues: provider.data?.invalidDocuments ?? const [],
              ),
              AppSpacing.gapLg,
              FigmaButton(
                label: KycStrings.goToDashboard,
                isLoading: provider.isGeneratingToken,
                navy: true,
                onPressed: provider.isGeneratingToken ? null : _handleApproved,
              ),
            ] else if (!isRejected) ...[
              AppSpacing.gapLg,
              const _ReviewHint(),
            ] else ...[
              AppSpacing.gapLg,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 18,
                    color: FigmaColors.of(context).heading,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Support desk is active at support@nivasshub.com',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: FigmaColors.of(context).heading,
                    ),
                  ),
                ],
              ),
            ],
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  static String _statusLabel(KycVerificationStatus status) => switch (status) {
    KycVerificationStatus.submitted => KycStrings.stageSubmitted,
    KycVerificationStatus.underReview => KycStrings.stageUnderReview,
    KycVerificationStatus.adminReview => KycStrings.stageAdminReview,
    KycVerificationStatus.processing => KycStrings.stageProcessing,
    KycVerificationStatus.approved => 'Approved',
    KycVerificationStatus.rejected ||
    KycVerificationStatus.correctionRequired => KycStrings.statusActionRequired,
  };

  static StatusChipType _statusChipType(KycVerificationStatus status) =>
      switch (status) {
        KycVerificationStatus.approved => StatusChipType.approved,
        KycVerificationStatus.rejected ||
        KycVerificationStatus.correctionRequired => StatusChipType.rejected,
        _ => StatusChipType.pending,
      };
}

/// Red "Action Required" banner shown when documents need resubmission.
class _ActionRequiredAlert extends StatelessWidget {
  const _ActionRequiredAlert({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: red.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF991B1B),
            ),
          ),
        ],
      ),
    );
  }
}

/// Numbered capture tips shown under the rejection banner.
class _HowToCorrectCard extends StatelessWidget {
  const _HowToCorrectCard();

  static const _tips = [
    'Ensure bright daylight and flat positioning before capturing.',
    'Upload direct PDF generated from registry portal if available.',
  ];

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return FigmaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to correct:',
            style: AppTextStyles.titleSmall.copyWith(
              color: t.heading,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < _tips.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: FigmaColors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tips[i],
                      style: AppTextStyles.bodySmall.copyWith(color: t.body),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Soft banner shown while the review is in progress.
class _ReviewHint extends StatelessWidget {
  const _ReviewHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top_rounded, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KycStrings.verifiedWithinHint,
                  style: AppTextStyles.titleSmall,
                ),
                Text(
                  KycStrings.verifiedWithinHintSub,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Submitted documents" list, driven by `GET /kyc/user-documents`.
class _SubmittedDocumentsSection extends StatelessWidget {
  const _SubmittedDocumentsSection({required this.onReupload});

  final Future<void> Function(KycUserDocument doc) onReupload;

  @override
  Widget build(BuildContext context) {
    final kyc = context.watch<KycProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final Widget content;
    if (kyc.storedState == KycProviderState.initial ||
        kyc.storedState == KycProviderState.loading) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (kyc.storedState == KycProviderState.error) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kyc.storedError ?? KycStrings.statusFetchFailed,
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          ),
          TextButton(
            onPressed: () => context.read<KycProvider>().loadStoredDocuments(
              fallbackToken: '',
            ),
            child: const Text('Retry'),
          ),
        ],
      );
    } else if (kyc.storedDocuments.isEmpty) {
      content = Text(
        KycStrings.noDocumentsFound,
        style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
      );
    } else {
      content = Column(
        children: [
          for (final doc in kyc.storedDocuments)
            _DocumentStatusTile(
              doc: doc,
              isUploading: kyc.reuploadingIds.contains(doc.documentNameId),
              onReupload: () => onReupload(doc),
            ),
        ],
      );
    }

    return FigmaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            KycStrings.submittedDocuments,
            style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
          ),
          AppSpacing.gapMd,
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: content,
          ),
        ],
      ),
    );
  }
}

/// One document: thumbnail (tap to preview), live status chip, and, when
/// rejected, the reviewer's note with a Re-upload button for this document.
class _DocumentStatusTile extends StatelessWidget {
  const _DocumentStatusTile({
    required this.doc,
    required this.isUploading,
    required this.onReupload,
  });

  final KycUserDocument doc;
  final bool isUploading;
  final VoidCallback onReupload;

  void _preview(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close preview',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
      pageBuilder: (ctx, _, _) => SafeArea(
        child: Stack(
          children: [
            Center(
              child: doc.bytes == null
                  ? Text(
                      KycStrings.previewUnavailable,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    )
                  : InteractiveViewer(
                      maxScale: 5,
                      child: Image.memory(doc.bytes!),
                    ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final label = doc.isRejected
        ? KycStrings.statusRejected
        : doc.isApproved
        ? KycStrings.statusApproved
        : KycStrings.statusPending;
    final type = doc.isRejected
        ? StatusChipType.rejected
        : doc.isApproved
        ? StatusChipType.approved
        : StatusChipType.pending;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _preview(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: doc.bytes == null
                        ? const Icon(
                            Icons.description_outlined,
                            color: AppColors.primary,
                          )
                        : Image.memory(
                            doc.bytes!,
                            fit: BoxFit.cover,
                            cacheWidth: 96,
                            gaplessPlayback: true,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.description_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.documentName,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () => _preview(context),
                      child: Text(
                        'Preview',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: StatusChip(
                  key: ValueKey(label),
                  label: label,
                  type: type,
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: doc.isRejected
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.rejectionReason.isEmpty
                              ? KycStrings.documentRejectedNote
                              : doc.rejectionReason,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isUploading ? null : onReupload,
                            icon: isUploading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file_rounded),
                            label: const Text(KycStrings.reuploadButton),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
