import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_issue.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_camera_capture_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_verification_status_screen.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_document_card.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_file_preview_sheet.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_upload_source_sheet.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_verdict_panel.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/dialogs/confirmation_dialog.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:provider/provider.dart';

class KycDocumentsScreenArgs {
  const KycDocumentsScreenArgs({
    required this.userId,
    this.kycToken = '',
    this.role,
    this.resubmitKycId,
    this.invalidDocuments = const [],
    this.rejectionReason,
  });

  final String userId;
  final String kycToken;

  /// `null` when arriving here straight from the login entry screen's
  /// "KYC completion is pending" case — the role isn't known client-side
  /// at that point, and `GET /kyc/documents` doesn't need it either; the
  /// backend resolves it from `userId` alone.
  final UserRole? role;

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

  Future<void> _handleUpload(int documentId) async {
    final provider = context.read<KycProvider>();
    final filePicker = context.read<FilePickerServiceBase>();

    final source = await KycUploadSourceSheet.show(context);
    if (source == null) return;

    if (source == FilePickSource.camera) {
      final permissionError = await filePicker.ensureCameraPermission();
      if (permissionError != null) {
        if (!mounted) return;
        _showPickError(permissionError.message);
        return;
      }
      if (!mounted) return;
      final file = await KycCameraCaptureScreen.show(context);
      if (file == null || !mounted) return;
      await provider.uploadPicked(documentId, file);
    } else {
      final picked = await filePicker.pick(source: source);
      if (picked.isFailure) {
        if (!mounted) return;
        _showPickError(picked.message ?? KycStrings.genericError);
        return;
      }
      final file = picked.data;
      if (file == null || !mounted) return; // user cancelled the OS picker

      final confirmed = await KycFilePreviewSheet.show(context, file: file);
      if (confirmed != true || !mounted) return;

      await provider.uploadPicked(documentId, file);
    }

    if (!mounted) return;
    final slot = provider.slotFor(documentId);
    if (slot?.status == KycUploadStatus.failed) {
      await _showUploadFailedDialog(documentId, slot!);
    }
  }

  void _showPickError(String message) {
    if (message == KycStrings.cameraPermanentlyDeniedMessage) {
      final filePicker = context.read<FilePickerServiceBase>();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: filePicker.openSettings,
            ),
          ),
        );
      return;
    }
    CustomSnackbar.error(context, message);
  }

  /// Spec: a failed upload shows a popup naming the document, never a
  /// hardcoded one, with Retry/Cancel. The backend's own message (already
  /// on `slot.errorMessage`, e.g. a 409 "pending"/"rejected" notice) is
  /// shown verbatim rather than overridden.
  Future<void> _showUploadFailedDialog(
    int documentId,
    KycDocumentSlot slot,
  ) async {
    final retry = await ConfirmationDialog.show(
      context,
      title: KycStrings.uploadFailedTitle(slot.document.documentName),
      message: slot.errorMessage ?? KycStrings.uploadFailed,
      confirmText: KycStrings.retryUpload,
    );
    if (retry && mounted) {
      await _handleUpload(documentId);
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
        role: widget.args.role ?? UserRole.owner,
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
      // It also fetches `GET /kyc/documents`, which shows the same loader
      // for the round trip rather than a blank list.
      body: provider.state == KycProviderState.initial ||
              provider.state == KycProviderState.loading
          ? const Loader()
          : provider.state == KycProviderState.error && provider.slots.isEmpty
          ? _FetchErrorView(
              message: provider.errorMessage ?? KycStrings.genericError,
              onRetry: () => context.read<KycProvider>().initialise(
                userId: args.userId,
                kycToken: args.kycToken,
                role: args.role,
                resubmitKycId: args.resubmitKycId,
                invalidDocuments: args.invalidDocuments,
                rejectionReason: args.rejectionReason,
              ),
            )
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
                      args.role == null
                          ? '${provider.slots.length} documents required'
                          : '${args.role!.label} · ${provider.slots.length} documents required',
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
                    if (provider.slots.isEmpty)
                      Text(
                        KycStrings.noOptionsAvailable,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    for (final slot in provider.slots)
                      KycDocumentCard(
                        slot: slot,
                        onUpload: slot.status.isBusy
                            ? () {}
                            : () => _handleUpload(slot.document.documentId),
                        onRemove: () => provider.remove(slot.document.documentId),
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

/// Shown when `GET /kyc/documents` itself failed — nothing to render a
/// card list from, so this replaces the whole body rather than sitting
/// above an empty one.
class _FetchErrorView extends StatelessWidget {
  const _FetchErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
            ),
            AppSpacing.gapMd,
            PrimaryButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
