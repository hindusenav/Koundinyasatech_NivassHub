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
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';
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
      child: Scaffold(
        appBar: const CustomAppBar(
          title: KycStrings.kycTitle,
          showBackButton: false,
        ),
        body: SafeArea(child: _buildBody(context, provider)),
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
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapMd,
          Text(
            KycStrings.verificationTitle,
            style: AppTextStyles.headlineSmall.copyWith(color: textPrimary),
          ),
          AppSpacing.gapSm,
          Text(
            KycStrings.verificationBody,
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          ),
          AppSpacing.gapLg,
          CustomCard(
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
          if (provider.isTerminal) ...[
            AppSpacing.gapLg,
            KycVerdictPanel(
              status: provider.status,
              reason: provider.data?.reason,
              issues: provider.data?.invalidDocuments ?? const [],
            ),
            AppSpacing.gapLg,
            if (provider.status == KycVerificationStatus.approved)
              PrimaryButton(
                label: KycStrings.goToDashboard,
                isLoading: provider.isGeneratingToken,
                size: CustomButtonSize.large,
                onPressed: provider.isGeneratingToken ? null : _handleApproved,
              )
            else if (provider.canResubmit)
              PrimaryButton(
                label: KycStrings.correctAndResubmit,
                size: CustomButtonSize.large,
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
