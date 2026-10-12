import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_status_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<KycStatusProvider>().startPolling(widget.args.kycId);
      context.read<KycProvider>().loadStoredDocuments(
        fallbackToken: widget.args.userId,
      );
    });
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

  Future<void> _handleResubmit() async {
    final provider = context.read<KycStatusProvider>();
    final authState = context.read<AuthStateProvider>();

    final kycToken = await authState.readKycToken();
    if (!mounted) return;

    if (kycToken == null) {
      CustomSnackbar.error(context, KycStrings.genericError);
      return;
    }

    // Recorded before navigating so a restart mid-correction lands on the
    // document screen rather than back on this one.
    await provider.prepareResubmission();
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.kycDocuments,
      arguments: KycDocumentsScreenArgs(
        userId: widget.args.userId,
        kycToken: kycToken,
        role: widget.args.role,
        resubmitKycId: widget.args.kycId,
        invalidDocuments: provider.data?.invalidDocuments ?? const [],
        rejectionReason: provider.reason,
      ),
    );
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
        if (shouldExit && context.mounted) Navigator.of(context).maybePop();
      },
      child: FigmaHeaderScaffold(
        title: KycStrings.kycTitle,
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
        onRetry: provider.retry,
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapMd,
          Text(
            provider.isTerminal
                ? KycStrings.verificationTitle
                : KycStrings.verificationUnderReviewTitle,
            style: AppTextStyles.headlineSmall.copyWith(color: textPrimary),
          ),
          AppSpacing.gapSm,
          Text(
            KycStrings.verificationBody,
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          ),
          AppSpacing.gapLg,
          FigmaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      KycStrings.verificationStatusLabel,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    StatusChip(
                      label: _statusLabel(provider.status),
                      type: _statusChipType(provider.status),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                KycStageIndicator(
                  stage: provider.stage,
                  isComplete: provider.isTerminal,
                ),
                AppSpacing.gapSm,
                Text(
                  'Reference: ${widget.args.kycId}',
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          const _SubmittedDocumentsSection(),
          if (provider.isTerminal) ...[
            AppSpacing.gapLg,
            KycVerdictPanel(
              status: provider.status,
              reason: provider.data?.reason,
              issues: provider.data?.invalidDocuments ?? const [],
            ),
            AppSpacing.gapLg,
            if (provider.status == KycVerificationStatus.approved)
              FigmaButton(
                label: KycStrings.goToDashboard,
                isLoading: provider.isGeneratingToken,
                navy: true,
                onPressed: provider.isGeneratingToken ? null : _handleApproved,
              )
            else if (provider.canResubmit)
              FigmaButton(
                label: KycStrings.correctAndResubmit,
                navy: true,
                onPressed: _handleResubmit,
              ),
          ] else ...[
            AppSpacing.gapXl,
            const Center(child: Loader()),
          ],
          AppSpacing.gapLg,
        ],
      ),
    );
  }

  static String _statusLabel(KycVerificationStatus status) => switch (status) {
    KycVerificationStatus.submitted => KycStrings.stageSubmitted,
    KycVerificationStatus.underReview => KycStrings.stageUnderReview,
    KycVerificationStatus.adminReview => KycStrings.stageAdminReview,
    KycVerificationStatus.processing => KycStrings.stageProcessing,
    KycVerificationStatus.approved => 'Approved',
    KycVerificationStatus.rejected => 'Rejected',
    KycVerificationStatus.correctionRequired => 'Correction required',
  };

  static StatusChipType _statusChipType(KycVerificationStatus status) =>
      switch (status) {
        KycVerificationStatus.approved => StatusChipType.approved,
        KycVerificationStatus.rejected ||
        KycVerificationStatus.correctionRequired => StatusChipType.rejected,
        _ => StatusChipType.pending,
      };
}

/// "Submitted documents" list, driven by `GET /kyc/user-documents`.
class _SubmittedDocumentsSection extends StatelessWidget {
  const _SubmittedDocumentsSection();

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
        'No documents found.',
        style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
      );
    } else {
      content = Column(
        children: [
          for (final doc in kyc.storedDocuments)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: doc.bytes == null
                        ? null
                        : () => showDialog<void>(
                            context: context,
                            builder: (_) => Dialog(
                              child: InteractiveViewer(
                                child: Image.memory(doc.bytes!),
                              ),
                            ),
                          ),
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
                        if (doc.userName.isNotEmpty)
                          Text(
                            doc.userName,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const StatusChip(
                    label: 'Uploaded',
                    type: StatusChipType.approved,
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return FigmaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submitted documents',
            style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
          ),
          AppSpacing.gapMd,
          content,
        ],
      ),
    );
  }
}
