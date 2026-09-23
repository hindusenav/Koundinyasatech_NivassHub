import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/enter_password_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:provider/provider.dart';

class EnterPasswordScreenArgs {
  const EnterPasswordScreenArgs({
    required this.identifier,
    required this.maskedIdentifier,
  });

  final AuthIdentifier identifier;
  final String maskedIdentifier;
}

/// Password entry for an account that already exists (spec §3).
class EnterPasswordScreen extends StatefulWidget {
  const EnterPasswordScreen({super.key, required this.args});

  final EnterPasswordScreenArgs args;

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<EnterPasswordProvider>();
    final dashboard = context.read<DashboardProvider>();

    final success = await provider.login(
      identifier: widget.args.identifier,
      password: _passwordController.text,
    );

    // A wrong password renders inline via the provider's status; there is
    // deliberately no navigation and no snackbar on that path.
    if (!success || !mounted) return;

    dashboard.refresh();
    NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnterPasswordProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: const CustomAppBar(title: '', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.gapLg,
                Text(
                  KycStrings.enterPasswordTitle,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: textPrimary,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  widget.args.maskedIdentifier,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapXl,
                CustomTextField(
                  controller: _passwordController,
                  label: KycStrings.passwordLabel,
                  hint: KycStrings.passwordHint,
                  prefixIcon: AppIcons.lock,
                  obscureText: _obscurePassword,
                  enabled: !provider.isSubmitting,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => provider.clearError(),
                  onFieldSubmitted: (_) => _handleLogin(),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Password is required'
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? AppIcons.visibilityOff
                          : AppIcons.visibilityOn,
                      size: AppDimensions.iconSm,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                if (provider.errorMessage != null) ...[
                  AppSpacing.gapSm,
                  Text(provider.errorMessage!, style: AppTextStyles.errorText),
                ],
                AppSpacing.gapSm,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    // Reuses the existing forgot-password chain unchanged.
                    onPressed: provider.isSubmitting
                        ? null
                        : () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.forgotPassword),
                    child: const Text(KycStrings.forgotPassword),
                  ),
                ),
                AppSpacing.gapLg,
                PrimaryButton(
                  label: KycStrings.loginLabel,
                  isLoading: provider.isSubmitting,
                  size: CustomButtonSize.large,
                  onPressed: provider.isSubmitting ? null : _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
