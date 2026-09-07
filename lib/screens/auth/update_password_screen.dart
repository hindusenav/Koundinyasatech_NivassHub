import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/password_requirement.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/password_requirement_list.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

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
/// Login.
class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key, required this.fpToken});

  final String fpToken;

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
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
      NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = context.screenHeight;
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final isUpdating = context.watch<ForgotPasswordProvider>().isUpdatingPassword;
    final background = isDark ? AuthColors.backgroundDarkMode : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final lightBlue = isDark ? AuthColors.lightBlueDarkMode : AuthColors.lightBlue;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;

    return PopScope(
      canPop: !isUpdating,
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [background, background, lightBlue.withValues(alpha: 0.05)],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Padding(
                    padding: AppSpacing.horizontal(AppSpacing.lg),
                    child: SingleChildScrollView(
                      child: AnimatedBuilder(
                        animation: _entrance,
                        builder: (context, _) {
                          final t = _entrance.value;
                          final headingT =
                              const Interval(0.00, 0.40, curve: Curves.easeOut).transform(t);
                          final subheadingT =
                              const Interval(0.08, 0.46, curve: Curves.easeOut).transform(t);
                          final formT =
                              const Interval(0.20, 0.65, curve: Curves.easeOutCubic).transform(t);
                          final buttonT =
                              const Interval(0.55, 0.90, curve: Curves.easeOutCubic).transform(t);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.08),
                              FadeSlideIn(
                                progress: headingT,
                                child: Text(
                                  'Update Password',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: heading,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              FadeSlideIn(
                                progress: subheadingT,
                                child: Text(
                                  'Create a new password for your account.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(color: bodyText),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),
                              FadeSlideIn(
                                progress: formT,
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      CustomTextField(
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
                                            color: bodyText,
                                          ),
                                          onPressed: () =>
                                              setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                        validator: (v) => (v == null || v.isEmpty)
                                            ? 'Password is required'
                                            : null,
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      CustomTextField(
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
                                            color: bodyText,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscureConfirmPassword = !_obscureConfirmPassword,
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
                                      SizedBox(height: AppSpacing.md),
                                      Container(
                                        width: double.infinity,
                                        padding: AppSpacing.all(AppSpacing.md),
                                        decoration: BoxDecoration(
                                          color: (isDark ? AuthColors.backgroundDarkMode : Colors.white)
                                              .withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: border),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Password must contain:',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: heading,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: AppSpacing.xs),
                                            PasswordRequirementList(
                                              password: _passwordController.text,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),
                              Opacity(
                                opacity: buttonT.clamp(0.0, 1.0),
                                child: AuthGradientButton(
                                  label: 'Update Password',
                                  isLoading: isUpdating,
                                  onPressed: (_canSubmit && !isUpdating) ? _handleSubmit : null,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.06),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
