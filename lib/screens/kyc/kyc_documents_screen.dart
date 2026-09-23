import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_type.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_verification_status_screen.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_document_card.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_upload_source_sheet.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_verdict_panel.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:provider/provider.dart';

class KycDocumentsScreenArgs {
  const KycDocumentsScreenArgs({
    required this.userId,
    required this.kycToken,
    required this.role,
    this.resubmitKycId,
    this.invalidDocuments = const [],
    this.rejectionReason,
  });

  final String userId;
  final String kycToken;
  final UserRole role;

  /// Non-null turns this into a correction of an earlier submission.
  final String? resubmitKycId;

  final List<KycDocumentIssue> invalidDocuments;
  final String? rejectionReason;

  bool get isResubmission => resubmitKycId != null;
}

/// Role-based document upload (spec §8–§11).
///
/// Owner and Tenant share two address proofs and differ only in the
/// third; the screen never branches on the role itself — it renders
/// whatever `KycProvider.slots` hands it.
class KycDocumentsScreen extends StatefulWidget {
  const KycDocumentsScreen({super.key, required this.args});

  final KycDocumentsScreenArgs args;

  @override
  State<KycDocumentsScreen> createState() => _KycDocumentsScreenState();
}

class _KycDocumentsScreenState extends State<KycDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    // Re-initialised on every entry, not just the first: arriving here
    // from a rejection must rehydrate the slots against that verdict,
    // and the provider is global so it may hold a previous attempt.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<KycProvider>().initialise(
        userId: widget.args.userId,
        kycToken: widget.args.kycToken,
        role: widget.args.role,
        resubmitKycId: widget.args.resubmitKycId,
        invalidDocuments: widget.args.invalidDocuments,
        rejectionReason: widget.args.rejectionReason,
      );
    });
  }

  Future<void> _handleUpload(KycDocumentType type) async {
    final provider = context.read<KycProvider>();
    final source = await KycUploadSourceSheet.show(context);
    if (source == null) return;
    await provider.pickAndUpload(type, source);
    if (!mounted) return;

    final error = provider.slotFor(type).errorMessage;
    if (error == KycStrings.cameraPermanentlyDeniedMessage) {
      final filePicker = context.read<FilePickerServiceBase>();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error!),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: filePicker.openSettings,
            ),
          ),
        );
    }
  }

  Future<void> _handleSubmit() async {
    final provider = context.read<KycProvider>();
    final success = await provider.submit();
    if (!mounted) return;

    if (!success) {
      CustomSnackbar.error(
        context,
        provider.errorMessage ?? KycStrings.submitFailed,
      );
      return;
    }

    // `pushReplacement` so a resubmit loop does not grow the stack by two
    // routes per attempt.
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.kycVerificationStatus,
      arguments: KycVerificationStatusScreenArgs(
        kycId: provider.submittedKycId!,
        userId: widget.args.userId,
        role: widget.args.role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KycProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final args = widget.args;

    return Scaffold(
      appBar: const CustomAppBar(
        title: KycStrings.kycTitle,
        showBackButton: false,
      ),
      // `initialise` runs in a post-frame callback (it notifies listeners,
      // so it cannot run during build), leaving one frame with no slots.
      body: provider.state == KycProviderState.initial
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      args.isResubmission
                          ? KycStrings.kycResubmitSubtitle
                          : KycStrings.kycSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      '${args.role.label} · ${provider.slots.length} documents required',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    if (args.isResubmission &&
                        (args.rejectionReason != null ||
                            args.invalidDocuments.isNotEmpty)) ...[
                      AppSpacing.gapMd,
                      KycVerdictPanel(
                        status: KycVerificationStatus.correctionRequired,
                        reason: args.rejectionReason,
                        issues: args.invalidDocuments,
                      ),
                    ],
                    AppSpacing.gapMd,
                    for (final slot in provider.slots)
                      KycDocumentCard(
                        slot: slot,
                        onUpload: slot.status.isBusy
                            ? () {}
                            : () => _handleUpload(slot.type),
                        onRemove: () => provider.remove(slot.type),
                      ),
                    AppSpacing.gapLg,
                    PrimaryButton(
                      label: KycStrings.submitKyc,
                      isLoading: provider.isSubmitting,
                      size: CustomButtonSize.large,
                      // Enabled only once every card carries a document id —
                      // freshly uploaded or preserved from a prior attempt.
                      onPressed: provider.canSubmit ? _handleSubmit : null,
                    ),
                    AppSpacing.gapLg,
                  ],
                ),
              ),
            ),
    );
  }
}
