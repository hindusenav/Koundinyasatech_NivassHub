import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

class UserDetailsScreenArgs {
  const UserDetailsScreenArgs({required this.identifier, this.prefillFullName});

  final AuthIdentifier identifier;
  final String? prefillFullName;
}

/// Screen 4: Profile Screen ("Create Your Profile")
///
/// Matches Screen 4 of the authentication design mockups:
/// - Dark navy user avatar badge
/// - Name (User Name)
/// - Email ID (Username@gmail.com)
/// - Create Password (**********) with "Password must be 8 Characters long" warning
/// - Confirm Password (**********)
/// - Dark navy "Continue ->" CTA button.
class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.args});

  final UserDetailsScreenArgs args;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final identifier = widget.args.identifier;

    _nameController = TextEditingController(
      text: widget.args.prefillFullName ?? '',
    );
    _emailController = TextEditingController(
      text: identifier.channel == AuthChannel.email ? identifier.raw : '',
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (_passwordController.text.length < 8) {
      CustomSnackbar.error(context, 'Password must be 8 Characters long');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      CustomSnackbar.error(context, 'Passwords do not match');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authState = context.read<AuthStateProvider>();
      await authState.moveTo(
        AuthFlowState.kycPending,
        context: authState.context.copyWith(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      );
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.kycDocuments,
        arguments: KycDocumentsScreenArgs(
          userId: widget.args.identifier.normalized,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      'Create Your Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AuthColors.graysBlack,
                        height: 34 / 28,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Dark Navy User Avatar Badge
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuthColors.navyBadge,
                        boxShadow: [AuthColors.shadowCards1],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter your details',
                      style: TextStyle(
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
                          // Name Field
                          const Row(
                            children: [
                              Icon(Icons.account_circle_outlined, size: 18, color: AuthColors.blueNh),
                              SizedBox(width: 8),
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AuthColors.blueNh,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _nameController,
                            hint: 'User Name',
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                            ],
                            validator: FormValidators.fullName,
                          ),
                          const SizedBox(height: 18),
                          // Email Field
                          const Row(
                            children: [
                              Icon(Icons.mail_outline_rounded, size: 18, color: AuthColors.blueNh),
                              SizedBox(width: 8),
                              Text(
                                'Email ID',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AuthColors.blueNh,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _emailController,
                            hint: 'Username@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: FormValidators.email,
                          ),
                          const SizedBox(height: 18),
                          // Create Password Field
                          const Row(
                            children: [
                              Icon(Icons.vpn_key_outlined, size: 18, color: AuthColors.blueNh),
                              SizedBox(width: 8),
                              Text(
                                'Create Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AuthColors.blueNh,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _passwordController,
                            hint: '**********',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: const Color(0xFF94A3B8),
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Password is required';
                              if (val.length < 8) return 'Password must be 8 Characters long';
                              return null;
                            },
                          ),
                          if (_passwordController.text.isNotEmpty &&
                              _passwordController.text.length < 8) ...[
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                Icon(Icons.info_outline, size: 14, color: Color(0xFFEF4444)),
                                SizedBox(width: 6),
                                Text(
                                  'Password must be 8 Characters long',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFEF4444),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 18),
                          // Confirm Password Field
                          const Row(
                            children: [
                              Icon(Icons.vpn_key_outlined, size: 18, color: AuthColors.blueNh),
                              SizedBox(width: 8),
                              Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AuthColors.blueNh,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hint: '**********',
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: const Color(0xFF94A3B8),
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (val != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Dark Navy Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AuthColors.navyButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 18),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
