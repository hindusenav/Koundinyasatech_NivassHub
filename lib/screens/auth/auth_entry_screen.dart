import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/providers/auth/auth_entry_provider.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/screens/auth/otp_mobile_email_verification_screen.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/enter_password_screen.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_shield_badge.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/identifier_input_field.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:provider/provider.dart';

/// Route arguments for [AuthEntryScreen]. Every field is optional — the
/// router substitutes a default instance when the route is pushed with no
/// arguments, which is the common case.
class AuthEntryScreenArgs {
  const AuthEntryScreenArgs({this.prefillIdentifier, this.prefillChannel});

  final String? prefillIdentifier;
  final AuthChannel? prefillChannel;
}

/// The app's front door (spec §1).
///
/// One identifier — mobile or email — plus a country code, validated and
/// checked against the backend, then routed to password login or to
/// registration.
class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key, this.args = const AuthEntryScreenArgs()});

  final AuthEntryScreenArgs args;

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController =
      TextEditingController(text: widget.args.prefillIdentifier ?? '');

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _toggleChannel() {
    final provider = context.read<AuthEntryProvider>();
    provider.setChannel(
      provider.isMobileMode ? AuthChannel.email : AuthChannel.mobile,
    );
    _identifierController.clear();
  }

  Future<void> _handleContinue() async {
    final provider = context.read<AuthEntryProvider>();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (provider.isMobileMode && provider.countryCode == null) {
      _showMessage(KycStrings.countryCodeRequired);
      return;
    }

    final identifier = await provider.checkUserExists(
      _identifierController.text.trim(),
    );
    if (!mounted || identifier == null) return;

    final authState = context.read<AuthStateProvider>();

    if (provider.status == AuthEntryStatus.kycPending) {
      final userId = provider.pendingKycUserId;
      if (userId == null || userId.isEmpty) {
        _showMessage(KycStrings.genericError);
        return;
      }
      await Navigator.of(context).pushNamed(
        AppRoutes.kycDocuments,
        arguments: KycDocumentsScreenArgs(userId: userId),
      );
      return;
    }

    if (provider.status == AuthEntryStatus.kycInProgress) {
      await Navigator.of(context).pushNamed(AppRoutes.kycInProgress);
      return;
    }

    if (provider.status == AuthEntryStatus.resumeOtp) {
      final token = provider.registrationToken;
      if (token == null || token.isEmpty) {
        _showMessage(KycStrings.genericError);
        return;
      }
      final outcome = provider.outcome;
      final pending = switch (outcome) {
        RegistrationCheckOutcome.mobileNotVerified => {OtpChannel.mobile},
        RegistrationCheckOutcome.emailNotVerified => {OtpChannel.email},
        _ => {OtpChannel.mobile, OtpChannel.email},
      };
      await authState.saveRegistrationToken(token);
      await authState.moveTo(
        AuthFlowState.otpPending,
        context: authState.context.copyWith(identifier: identifier),
      );
      if (!mounted) return;
      await Navigator.of(context).pushNamed(
        AppRoutes.otpMobileEmailVerification,
        arguments: OtpMobileEmailVerificationScreenArgs(
          userId: token,
          mobileNumber: identifier.channel == AuthChannel.mobile
              ? identifier.masked
              : null,
          email: identifier.channel == AuthChannel.email
              ? identifier.masked
              : null,
          pendingChannels: pending,
          otpJustSent: false,
          resendIdentifier: identifier,
        ),
      );
      return;
    }

    if (provider.status == AuthEntryStatus.existingUser) {
      await Navigator.of(context).pushNamed(
        AppRoutes.enterPassword,
        arguments: EnterPasswordScreenArgs(
          identifier: identifier,
          maskedIdentifier: provider.maskedIdentifier ?? identifier.masked,
        ),
      );
      return;
    }

    await authState.moveTo(
      AuthFlowState.otpPending,
      context: authState.context.copyWith(identifier: identifier),
    );
    if (!mounted) return;

    await Navigator.of(context).pushNamed(
      AppRoutes.otpMobileEmailVerification,
      arguments: OtpMobileEmailVerificationScreenArgs(
        userId: provider.registrationToken ?? identifier.normalized,
        mobileNumber: identifier.channel == AuthChannel.mobile
            ? identifier.formatted
            : null,
        email: identifier.channel == AuthChannel.email
            ? identifier.raw
            : null,
        pendingChannels: identifier.channel == AuthChannel.mobile
            ? {OtpChannel.mobile}
            : {OtpChannel.email},
        otpJustSent: true,
        resendIdentifier: identifier,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthEntryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AuthColors.blueNh),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Skyline Painting
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AuthSkylinePainter(progress: 1.0),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AuthShieldBadge(size: 64),
                    const SizedBox(height: 12),
                    Text(
                      provider.isMobileMode
                          ? 'Enter Your Mobile Number'
                          : 'Enter Your Email Address',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AuthColors.graysBlack,
                        height: 34 / 28,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      provider.isMobileMode
                          ? 'We will send a one-time password to verify your mobile number. This helps keep your account secure.'
                          : 'We will send a one-time password to verify your email. This helps keep your account secure.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AuthColors.gray1,
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // White Elevated Form Card Container (Radius 24px, Border 0.5px #9AA7B5, Padding 24px)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AuthColors.formCardBorder, width: 0.5),
                        boxShadow: const [AuthColors.shadowCards1],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                provider.isMobileMode
                                    ? Icons.smartphone_outlined
                                    : Icons.email_outlined,
                                size: 16,
                                color: AuthColors.blueNh,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                provider.isMobileMode ? 'Mobile Number' : 'Email Address',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: AuthColors.blueNh,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          IdentifierInputField(
                            controller: _identifierController,
                            channel: provider.channel,
                            countries: provider.dialCodes,
                            selectedCountry: provider.selectedCountry,
                            isLoadingCountries: provider.isLoadingDialCodes,
                            enabled: !provider.isChecking,
                            onCountrySelected: provider.setCountry,
                            onRetryCountries: provider.loadCountryCodes,
                            onChanged: (_) => provider.clearError(),
                            onSubmitted: (_) => _handleContinue(),
                            validator: _validateIdentifier,
                          ),
                          if (provider.errorMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              provider.errorMessage!,
                              style: AppTextStyles.errorText,
                            ),
                          ],
                          const SizedBox(height: 12),
                          const Text(
                            'OTP will be sent via SMS. Standard message rates may apply.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                              color: AuthColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Security Note: 33px height, padding 8px top/bottom, 8px gap
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 16,
                                  color: AuthColors.blueNh,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Your data is encrypted and secure.',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      color: AuthColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Orange Send OTP Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AuthColors.orangeButton,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: provider.isChecking ? null : _handleContinue,
                              child: provider.isChecking
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Send OTP',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // OR Divider Container
                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: const Color(0xFFCBD5E1))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 14,
                              color: AuthColors.dividerText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(child: Container(height: 1, color: const Color(0xFFCBD5E1))),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Footer container (Gap: 16px)
                    Column(
                      children: [
                        // Already have account? Login link
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: AuthColors.inputBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AuthColors.inputBorder, width: 1),
                          ),
                          child: GestureDetector(
                            onTap: provider.isChecking ? null : _toggleChannel,
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  color: AuthColors.textMuted,
                                ),
                                children: [
                                  TextSpan(
                                    text: provider.isMobileMode ? 'Login' : 'Use Mobile',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                      color: AuthColors.blueNh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Privacy Policy Footer Note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shield_outlined, size: 14, color: AuthColors.blueNh),
                            const SizedBox(width: 6),
                            RichText(
                              text: const TextSpan(
                                text: 'By continuing, you agree to our ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  color: AuthColors.textMuted,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.0,
                                      color: AuthColors.blueNh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Delegates to the shared validators so the rules match the rest of the
  /// app. Mobile length is country-aware, since a `+44` number is not ten
  /// digits starting 6-9.
  String? _validateIdentifier(String? value) {
    final provider = context.read<AuthEntryProvider>();
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return KycStrings.identifierRequired;

    if (provider.isMobileMode) {
      return FormValidators.mobileNumberForDialCode(provider.countryCode)(
        trimmed,
      );
    }
    return FormValidators.email(trimmed);
  }
}
