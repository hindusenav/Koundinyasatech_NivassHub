import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Screen 4 — collects the registered email address and requests an OTP.
/// No arguments; on success navigates to the shared OTP-verify screen with
/// `channel: email`.
class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.hideKeyboard();
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final email = _emailController.text.trim();
    final success = await forgotPassword.sendOtp(
      identifier: email,
      channel: ForgotPasswordChannel.email,
    );
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.forgotPasswordVerifyOtp,
        arguments: ForgotPasswordVerifyOtpScreenArgs(
          identifier: email,
          channel: ForgotPasswordChannel.email,
        ),
      );
    } else {
      CustomSnackbar.error(
        context,
        forgotPassword.errorMessage ?? 'Failed to send OTP. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final isSendingOtp = context.watch<ForgotPasswordProvider>().isSendingOtp;

    return PopScope(
      canPop: !isSendingOtp,
      child: FigmaHeaderScaffold(
        title: 'Forgot Password',
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: context.pageInsets,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    context.gapSm,
                    const Text(
                      "Enter your registered email address and we'll send you an "
                      'OTP to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: context.rs(28)),
                    FigmaCard(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomTextField(
                          controller: _emailController,
                          hint: 'Enter Email Address',
                          prefixIcon: AppIcons.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: FormValidators.email,
                          onFieldSubmitted: (_) => _handleSendOtp(),
                        ),
                      ),
                    ),
                    SizedBox(height: context.rs(20)),
                    FigmaButton(
                      label: 'Send OTP',
                      showArrow: true,
                      isLoading: isSendingOtp,
                      onPressed: isSendingOtp ? null : _handleSendOtp,
                    ),
                    SizedBox(height: context.rs(12)),
                    TextButton(
                      onPressed: isSendingOtp ? null : () => Navigator.pop(context),
                      child: const Text(
                        'Back to Options',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
