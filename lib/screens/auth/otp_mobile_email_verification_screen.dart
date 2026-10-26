import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/services/auth/sms_otp_listener.dart';
import 'package:flutter_nivasshub/widgets/auth/otp_input_boxes.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:provider/provider.dart';

class OtpMobileEmailVerificationScreenArgs {
  const OtpMobileEmailVerificationScreenArgs({
    required this.userId,
    this.email,
    this.mobileNumber,
    this.role,
    this.pendingChannels = const {OtpChannel.mobile, OtpChannel.email},
    this.otpJustSent = true,
    this.resendIdentifier,
  });

  final String userId;

  /// Unknown when resuming from a registration-check result.
  final String? email;
  final String? mobileNumber;
  final UserRole? role;

  /// Channels still needing verification; the others are shown as done.
  final Set<OtpChannel> pendingChannels;

  /// `false` when resuming from registration-check: no OTP has just been
  /// sent, so resend must be available immediately.
  final bool otpJustSent;

  /// Identifier re-submitted to registration-check to resend the OTPs.
  final AuthIdentifier? resendIdentifier;
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

  // Mobile OTP only; the email OTP is always typed manually.
  final TextEditingController _mobileOtpController = TextEditingController();
  late final SmsOtpListener _smsListener = SmsOtpListener(
    length: 6,
    onCode: _onSmsCode,
  );

  @override
  void initState() {
    super.initState();
    if (widget.args.pendingChannels.contains(OtpChannel.mobile)) {
      _smsListener.start();
    }
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
    _smsListener.stop();
    _mobileOtpController.dispose();
    super.dispose();
  }

  void _onSmsCode(String code) {
    if (!mounted) return;
    _mobileOtpController.text = code;
    setState(() => _mobileOtp = code);
  }

  Future<void> _verify(OtpChannel channel, String otp) async {
    final provider = context.read<OtpMobileEmailVerificationProvider>();
    final success = await provider.verifyOtp(channel, otp);
    if (!mounted) return;

    if (success && provider.canContinueToKyc) {
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
      if (channel == OtpChannel.mobile) _smsListener.restart();
      CustomSnackbar.success(context, 'OTP resent successfully.');
    } else {
      CustomSnackbar.error(
        context,
        provider.stateFor(channel).resendError ?? KycStrings.genericError,
      );
    }
  }

  Future<void> _continueToKyc() async {
    final args = widget.args;
    // The rotated token from verify-otp is what GET /kyc/documents and
    // /kyc/re-upload expect; the registration token is only a fallback.
    final sessionToken =
        context.read<OtpMobileEmailVerificationProvider>().sessionToken ??
        args.userId;

    // OTP is done: the registration token is spent. Record where a restart
    // should resume. Without a known role (a resume from registration-check)
    // there is nothing to restore KYC with, so fall back to the entry
    // screen, where registration-check routes straight to KYC again.
    final authState = context.read<AuthStateProvider>();
    await authState.clearRegistrationToken();
    final role = args.role;
    if (role != null) {
      await authState.saveKycToken(sessionToken);
      await authState.moveTo(
        AuthFlowState.kycPending,
        context: authState.context.copyWith(userId: sessionToken, role: role),
      );
    } else {
      await authState.moveTo(AuthFlowState.unauthenticated);
    }
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.kycDocuments,
      arguments: KycDocumentsScreenArgs(userId: sessionToken, role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OtpMobileEmailVerificationProvider>();
    final pending = widget.args.pendingChannels;
    return FigmaLightScaffold(
      showBackButton: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: context.pageInsets,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: FigmaBadge()),
                  SizedBox(height: context.rs(20)),
                  const FigmaTitleBlock(
                    title: KycStrings.otpVerificationTitle,
                    subtitle: KycStrings.otpVerificationSubtitle,
                  ),
                  if (pending.contains(OtpChannel.mobile)) ...[
                    AppSpacing.gapLg,
                    _OtpCard(
                      channel: OtpChannel.mobile,
                      icon: AppIcons.phone,
                      title: KycStrings.otpMobileSectionTitle,
                      subtitle: widget.args.mobileNumber ?? '',
                      state: provider.stateFor(OtpChannel.mobile),
                      cooldownSeconds: provider.remainingCooldownSeconds(
                        OtpChannel.mobile,
                      ),
                      codeController: _mobileOtpController,
                      onChanged: (value) => setState(() => _mobileOtp = value),
                      onVerify: () => _verify(OtpChannel.mobile, _mobileOtp),
                      onResend: () => _resend(OtpChannel.mobile),
                      canVerify: _mobileOtp.length == 6,
                    ),
                  ],
                  if (pending.contains(OtpChannel.email)) ...[
                    AppSpacing.gapLg,
                    _OtpCard(
                      channel: OtpChannel.email,
                      icon: AppIcons.email,
                      title: KycStrings.otpEmailSectionTitle,
                      subtitle: widget.args.email ?? '',
                      state: provider.stateFor(OtpChannel.email),
                      cooldownSeconds: provider.remainingCooldownSeconds(
                        OtpChannel.email,
                      ),
                      onChanged: (value) => setState(() => _emailOtp = value),
                      onVerify: () => _verify(OtpChannel.email, _emailOtp),
                      onResend: () => _resend(OtpChannel.email),
                      canVerify: _emailOtp.length == 6,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
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
    this.codeController,
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
  final TextEditingController? codeController;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final bool canVerify;

  @override
  Widget build(BuildContext context) {
    const textSecondary = AppColors.textMuted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: state.isVerified ? AppColors.badgeGreen : AppColors.cardBorder,
          width: state.isVerified ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 18,
            offset: Offset(0, 6),
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
                  color: state.isVerified
                      ? AppColors.badgeGreenBg
                      : AppColors.accentTint,
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Icon(
                  state.isVerified ? AppIcons.checkCircle : icon,
                  color: state.isVerified
                      ? AppColors.badgeGreen
                      : AppColors.primaryOrange,
                ),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (state.isVerified)
                Container(
                  padding: AppSpacing.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.badgeGreenBg,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Text(
                    KycStrings.otpVerifiedLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.badgeGreen,
                    ),
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
                controller: codeController,
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
            FigmaButton(
              label: KycStrings.otpVerifyLabel,
              isLoading: state.isVerifying,
              onPressed: canVerify && !state.isVerifying ? onVerify : null,
            ),
            AppSpacing.gapSm,
            Center(
              child: _ResendRow(
                state: state,
                cooldownSeconds: cooldownSeconds,
                onResend: onResend,
              ),
            ),
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
    const textSecondary = AppColors.textMuted;

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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      alignment: Alignment.center,
      child: CustomButton(
        label: 'Resend OTP',
        onPressed: onResend,
        variant: CustomButtonVariant.text,
        isFullWidth: false,
        size: CustomButtonSize.small,
      ),
    );
  }
}
