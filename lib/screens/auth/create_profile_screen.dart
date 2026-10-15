import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/select_country_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

class CreateProfileScreenArgs {
  const CreateProfileScreenArgs({
    required this.identifier,
    this.initialFullName,
    this.initialEmail,
  });

  final AuthIdentifier identifier;
  final String? initialFullName;
  final String? initialEmail;
}

/// Screen: "Create Your Profile" (Figma artboard: "Profile Screen")
///
/// Features:
/// - Title: "Create Your Profile"
/// - Navy circular avatar badge with person icon
/// - Subtitle: "Enter your details"
/// - Elevated card with:
///   - Name (person icon + User Name hint)
///   - Email ID (mail icon + Username@gmail.com hint)
///   - Create Password (key icon + Password must be 8 Characters long helper)
///   - Confirm Password (key icon)
/// - Bottom "Continue ->" CTA button in #0E2543
/// - Background auth skyline graphic
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key, required this.args});

  final CreateProfileScreenArgs args;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  bool _hasTouchedPassword = false;

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    final initialEmail = args.initialEmail ??
        (args.identifier.channel == AuthChannel.email
            ? args.identifier.raw
            : '');

    _nameController = TextEditingController(text: args.initialFullName ?? '');
    _emailController = TextEditingController(text: initialEmail);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _passwordController.addListener(() {
      if (!_hasTouchedPassword && _passwordController.text.isNotEmpty) {
        setState(() => _hasTouchedPassword = true);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isPasswordLengthValid => _passwordController.text.length >= 8;

  Future<void> _handleContinue() async {
    if (_isSubmitting) return;

    setState(() => _hasTouchedPassword = true);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isPasswordLengthValid) {
      CustomSnackbar.error(context, 'Password must be at least 8 characters long');
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
        AuthFlowState.registration,
        context: authState.context.copyWith(
          identifier: widget.args.identifier,
        ),
      );

      if (!mounted) return;

      // Navigate to Select Country -> City -> Society details
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.selectCountry,
        arguments: SelectCountryScreenArgs(
          identifier: widget.args.identifier,
        ),
      );
    } catch (e) {
      if (mounted) {
        CustomSnackbar.error(context, 'Failed to save profile. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          // Background Image matching Figma Dev Mode specs (Profile Screen):
          // Image: bg img 2.png, Scale: Crop, Opacity: 70%, Layout: Width 442px, Height 616px, Top 340px, Left -1px
          Positioned(
            left: -1,
            right: -1,
            bottom: 0,
            height: 616,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.70,
                child: Image.asset(
                  AppAssets.authBackground,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, __, ___) => CustomPaint(
                    painter: AuthSkylinePainter(progress: 1.0),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              // Header Title (Figma: "Create Your Profile")
                              const Text(
                                'Create Your Profile',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0E2543),
                                  letterSpacing: -0.3,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              // Circular Avatar Icon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0E2543),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0E2543).withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Subtitle
                              const Text(
                                'Enter your details',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A6B82),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              // Elevated Form Card
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(maxWidth: 380),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFDCE4EE),
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 22,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Field 1: Name
                                      _buildFieldLabel(
                                        icon: Icons.account_circle_outlined,
                                        label: 'Name',
                                      ),
                                      const SizedBox(height: 8),
                                      _buildTextInput(
                                        controller: _nameController,
                                        hintText: 'User Name',
                                        keyboardType: TextInputType.name,
                                        validator: (val) {
                                          if (val == null || val.trim().isEmpty) {
                                            return 'Please enter your name';
                                          }
                                          if (val.trim().length < 2) {
                                            return 'Name must be at least 2 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      // Field 2: Email ID
                                      _buildFieldLabel(
                                        icon: Icons.mail_outline_rounded,
                                        label: 'Email ID',
                                      ),
                                      const SizedBox(height: 8),
                                      _buildTextInput(
                                        controller: _emailController,
                                        hintText: 'Username@gmail.com',
                                        keyboardType: TextInputType.emailAddress,
                                        validator: FormValidators.email,
                                      ),
                                      const SizedBox(height: 18),
                                      // Field 3: Create Password
                                      _buildFieldLabel(
                                        icon: Icons.key_rounded,
                                        label: 'Create Password',
                                      ),
                                      const SizedBox(height: 8),
                                      _buildTextInput(
                                        controller: _passwordController,
                                        hintText: '•••••••••••',
                                        obscureText: _obscurePassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                            color: const Color(0xFF64748B),
                                          ),
                                          onPressed: () {
                                            setState(() => _obscurePassword = !_obscurePassword);
                                          },
                                        ),
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter a password';
                                          }
                                          if (val.length < 8) {
                                            return 'Password must be at least 8 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 6),
                                      // Password Length Helper Message
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            size: 13,
                                            color: _isPasswordLengthValid
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFEF4444),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Password must be 8 Characters long',
                                            style: TextStyle(
                                              fontFamily: 'DM Sans',
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                              color: _isPasswordLengthValid
                                                  ? const Color(0xFF10B981)
                                                  : const Color(0xFFEF4444),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      // Field 4: Confirm Password
                                      _buildFieldLabel(
                                        icon: Icons.key_rounded,
                                        label: 'Confirm Password',
                                      ),
                                      const SizedBox(height: 8),
                                      _buildTextInput(
                                        controller: _confirmPasswordController,
                                        hintText: '•••••••••••',
                                        obscureText: _obscureConfirmPassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                            color: const Color(0xFF64748B),
                                          ),
                                          onPressed: () {
                                            setState(
                                              () => _obscureConfirmPassword =
                                                  !_obscureConfirmPassword,
                                            );
                                          },
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
                              ),
                            ],
                          ),
                          // Bottom Continue Button
                          Padding(
                            padding: const EdgeInsets.only(top: 28, bottom: 12),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 380),
                              child: SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AuthColors.navyButton, // #0E2543
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: AuthColors.navyButton,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onPressed: _isSubmitting ? null : _handleContinue,
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Stack(
                                          alignment: Alignment.center,
                                          children: const [
                                            Center(
                                              child: Text(
                                                'Continue',
                                                style: TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  height: 1.0,
                                                  letterSpacing: 0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1A4789)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF10213D),
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDCE4EE), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDCE4EE), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A4789), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
        ),
      ),
    );
  }
}
