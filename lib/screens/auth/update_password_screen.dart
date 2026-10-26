import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/models/auth/password_requirement.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/auth/password_requirement_list.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Typed arguments for [AppRoutes.updatePassword], unpacked in
/// `auth_router.dart`.
///
/// [fpToken] is accepted here (mirroring the constructor
/// `CreateProfileScreenArgs.registrationToken` already uses) but the submit
/// flow reads its own copy cached on `ForgotPasswordProvider` from the
/// preceding `verifyOtp` call — this is intentional, harmless duplication,
/// not dead code: it keeps this screen self-sufficient even if the provider
/// were ever recreated between screens.
class UpdatePasswordScreenArgs {
  const UpdatePasswordScreenArgs({required this.fpToken});

  final String fpToken;
}

/// Screen 6 — final step of the Forgot Password flow. Collects a new
/// password (with a live strength checklist) and a matching confirmation,
/// then submits it against the `FP_Token` obtained from the preceding
/// Verify OTP step. On success, clears the whole auth stack and returns to
/// the authentication entry screen.
class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key, required this.fpToken});

  final String fpToken;

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final allRequirementsMet = evaluatePasswordRequirements(password).values.every((v) => v);
    return allRequirementsMet && confirm.isNotEmpty && confirm == password;
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_canSubmit) return;

    context.hideKeyboard();
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final success = await forgotPassword.updatePassword(_passwordController.text);
    if (!mounted) return;

    if (success) {
      // Not stored, not logged — the new password only ever lives in these
      // two controllers for the duration of this submit call.
      _passwordController.clear();
      _confirmPasswordController.clear();
      NavigationService.pushNamedAndRemoveUntil(AppRoutes.authEntry);
      CustomSnackbar.success(context, 'Password updated successfully. Please log in.');
    } else {
      CustomSnackbar.error(
        context,
        forgotPassword.errorMessage ?? 'Failed to update password. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final isUpdating = context.watch<ForgotPasswordProvider>().isUpdatingPassword;

    return PopScope(
      canPop: !isUpdating,
      child: FigmaHeaderScaffold(
        title: 'Reset Password',
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
                      'Create New Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    context.gapSm,
                    const Text(
                      'Your identity has been verified. Create a secure new '
                      'password for your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: context.rs(28)),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FigmaCard(
                            child: CustomTextField(
                              controller: _passwordController,
                              label: 'New Password',
                              hint: 'Enter new password',
                              prefixIcon: AppIcons.lock,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              // Forces a rebuild on every keystroke so the checklist and
                              // confirm-password validator (which closes over this
                              // field's current text) never see stale text.
                              onChanged: (_) => setState(() {}),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? AppIcons.visibilityOff
                                      : AppIcons.visibilityOn,
                                  size: AppDimensions.iconSm,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Password is required'
                                  : null,
                            ),
                          ),
                          SizedBox(height: context.rs(14)),
                          FigmaCard(
                            child: CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm New Password',
                              hint: 'Re-enter new password',
                              prefixIcon: AppIcons.lock,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onChanged: (_) => setState(() {}),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? AppIcons.visibilityOff
                                      : AppIcons.visibilityOn,
                                  size: AppDimensions.iconSm,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _handleSubmit(),
                            ),
                          ),
                          SizedBox(height: context.rs(14)),
                          FigmaCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _PasswordStrengthMeter(
                                  password: _passwordController.text,
                                ),
                                SizedBox(height: context.rs(12)),
                                const Text(
                                  'Password must contain:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(height: context.rs(6)),
                                PasswordRequirementList(
                                  password: _passwordController.text,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.rs(20)),
                    FigmaButton(
                      label: 'Update Password & Login',
                      isLoading: isUpdating,
                      onPressed: (_canSubmit && !isUpdating) ? _handleSubmit : null,
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

/// Segmented bar driven by how many of the [PasswordRequirement] rules the
/// current password meets; read-only, so it never affects the submit gate.
class _PasswordStrengthMeter extends StatelessWidget {
  const _PasswordStrengthMeter({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final results = evaluatePasswordRequirements(password);
    final met = results.values.where((v) => v).length;
    final total = results.length;

    final (label, color) = switch (met) {
      0 => ('Enter a password', AppColors.textMuted),
      1 || 2 => ('Weak Password', AppColors.error),
      3 => ('Fair Password', AppColors.warning),
      _ => ('Strong Password', AppColors.badgeGreen),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < total; i++) ...[
              if (i > 0) SizedBox(width: context.rs(6)),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 5,
                  decoration: BoxDecoration(
                    color: i < met ? color : AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ],
        ),
        context.gapSm,
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
