import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/widgets/auth/otp_input_boxes.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:provider/provider.dart';

class OtpMobileEmailVerificationScreenArgs {
  const OtpMobileEmailVerificationScreenArgs({
    required this.userId,
    required this.email,
    required this.mobileNumber,
    required this.role,
  });

  final String userId;
  final String email;
  final String mobileNumber;
  final UserRole role;
}

/// Verifies the mobile and email OTPs sent after registration via
/// `POST /country-codes/user-registration/verify-otp`, with a
/// `POST /otp/resend` link on each card, then hands off to KYC document
/// upload once both are verified.
class OtpMobileEmailVerificationScreen extends StatefulWidget {
  const OtpMobileEmailVerificationScreen({super.key, required this.args});

  final OtpMobileEmailVerificationScreenArgs args;

  @override
  State<OtpMobileEmailVerificationScreen> createState() =>
      _OtpMobileEmailVerificationScreenState();
}

class _OtpMobileEmailVerificationScreenState
    extends State<OtpMobileEmailVerificationScreen> {
  String _mobileOtp = '';
  String _emailOtp = '';

  Timer? _cooldownTicker;

  @override
  void initState() {
    super.initState();
    // Only drives the resend-cooldown countdown text below each card —
    // cheap enough to just tick every second for the screen's lifetime
    // rather than tracking exactly when a cooldown is active.
    _cooldownTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _cooldownTicker?.cancel();
    super.dispose();
  }

  Future<void> _verify(OtpChannel channel, String otp) async {
    final provider = context.read<OtpMobileEmailVerificationProvider>();
    final success = await provider.verifyOtp(channel, otp);
    if (!mounted) return;

    if (success && provider.isFullyVerified) {
      _continueToKyc();
    } else if (!success) {
      CustomSnackbar.error(
        context,
        provider.stateFor(channel).verifyError ?? KycStrings.genericError,
      );
    }
  }

  Future<void> _resend(OtpChannel channel) async {
    final provider = context.read<OtpMobileEmailVerificationProvider>();
    final success = await provider.resendOtp(channel);
    if (!mounted) return;

    if (success) {
      CustomSnackbar.success(context, 'OTP resent successfully.');
    } else {
      CustomSnackbar.error(
        context,
        provider.stateFor(channel).resendError ?? KycStrings.genericError,
      );
    }
  }

  void _continueToKyc() {
    final args = widget.args;
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.kycDocuments,
      arguments: KycDocumentsScreenArgs(
        userId: args.userId,
        // MISSING API CONTRACT — verify-otp's response is `{verified:
        // true}` only, no kyc token; left empty until that's documented.
        kycToken: '',
        role: args.role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OtpMobileEmailVerificationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const CustomAppBar(
        title: KycStrings.otpVerificationTitle,
        showBackButton: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      KycStrings.otpVerificationSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    AppSpacing.gapLg,
                    _OtpCard(
                      channel: OtpChannel.mobile,
                      icon: AppIcons.phone,
                      title: KycStrings.otpMobileSectionTitle,
                      subtitle: widget.args.mobileNumber,
                      state: provider.stateFor(OtpChannel.mobile),
                      cooldownSeconds:
                          provider.remainingCooldownSeconds(OtpChannel.mobile),
                      onChanged: (value) => setState(() => _mobileOtp = value),
                      onVerify: () => _verify(OtpChannel.mobile, _mobileOtp),
                      onResend: () => _resend(OtpChannel.mobile),
                      canVerify: _mobileOtp.length == 6,
                    ),
                    AppSpacing.gapLg,
                    _OtpCard(
                      channel: OtpChannel.email,
                      icon: AppIcons.email,
                      title: KycStrings.otpEmailSectionTitle,
                      subtitle: widget.args.email,
                      state: provider.stateFor(OtpChannel.email),
                      cooldownSeconds:
                          provider.remainingCooldownSeconds(OtpChannel.email),
                      onChanged: (value) => setState(() => _emailOtp = value),
                      onVerify: () => _verify(OtpChannel.email, _emailOtp),
                      onResend: () => _resend(OtpChannel.email),
                      canVerify: _emailOtp.length == 6,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// One channel's card: icon badge, masked identifier, the OTP boxes,
/// an inline error, the Verify button, and a Resend row underneath —
/// or, once verified, a compact "Verified" state in place of all of it.
class _OtpCard extends StatelessWidget {
  const _OtpCard({
    required this.channel,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
    required this.cooldownSeconds,
    required this.onChanged,
    required this.onVerify,
    required this.onResend,
    required this.canVerify,
  });

  final OtpChannel channel;
  final IconData icon;
  final String title;
  final String subtitle;
  final OtpChannelState state;
  final int cooldownSeconds;
  final ValueChanged<String> onChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final bool canVerify;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(
          color: state.isVerified ? AppColors.success : border,
          width: state.isVerified ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.24 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: AppSpacing.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (state.isVerified ? AppColors.success : AppColors.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Icon(
                  state.isVerified ? AppIcons.checkCircle : icon,
                  color: state.isVerified ? AppColors.success : AppColors.primary,
                ),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (state.isVerified)
                Container(
                  padding: AppSpacing.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Text(
                    KycStrings.otpVerifiedLabel,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.success),
                  ),
                ),
            ],
          ),
          if (!state.isVerified) ...[
            AppSpacing.gapLg,
            Center(
              child: OtpInputBoxes(
                length: 6,
                autofocus: false,
                onChanged: onChanged,
                onCompleted: onChanged,
              ),
            ),
            if (state.verifyError != null) ...[
              AppSpacing.gapSm,
              Center(
                child: Text(
                  state.verifyError!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.errorText,
                ),
              ),
            ],
            AppSpacing.gapMd,
            PrimaryButton(
              label: KycStrings.otpVerifyLabel,
              isLoading: state.isVerifying,
              size: CustomButtonSize.large,
              onPressed: canVerify && !state.isVerifying ? onVerify : null,
            ),
            AppSpacing.gapSm,
            Center(child: _ResendRow(state: state, cooldownSeconds: cooldownSeconds, onResend: onResend)),
          ],
        ],
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.state,
    required this.cooldownSeconds,
    required this.onResend,
  });

  final OtpChannelState state;
  final int cooldownSeconds;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    if (state.isResending) {
      return Text(
        'Resending…',
        style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      );
    }

    if (cooldownSeconds > 0) {
      return Text(
        "Didn't get the code? Resend in ${cooldownSeconds}s",
        style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      );
    }

    return CustomButton(
      label: 'Resend OTP',
      onPressed: onResend,
      variant: CustomButtonVariant.text,
      isFullWidth: false,
      size: CustomButtonSize.small,
    );
  }
}
