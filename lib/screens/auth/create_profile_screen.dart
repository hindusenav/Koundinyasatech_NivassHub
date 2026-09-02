import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';

/// Typed arguments for [AppRoutes.createProfile], unpacked in
/// `auth_router.dart`.
class CreateProfileScreenArgs {
  const CreateProfileScreenArgs({required this.registrationToken});

  final String registrationToken;
}

/// Profile-completion form for a new user (no existing account) after OTP
/// verification. Reached only when `OtpVerificationSuccessScreen` finds
/// `userExists == false`; on successful submit the returned session tokens
/// are persisted and the user lands on the Home Dashboard with the auth
/// stack cleared.
///
/// [registrationToken] is accepted here (mirroring the constructor
/// `OtpVerificationSuccessScreen` already calls) but the submit flow reads
/// its own copy cached on `AuthProvider` from the preceding `verifyOtp`
/// call — this is intentional, harmless duplication, not dead code.
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key, required this.registrationToken});

  final String registrationToken;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.hideKeyboard();
    final auth = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final success = await auth.completeRegistration(
      fullName: _fullNameController.text.trim(),
      email: email.isEmpty ? null : email,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      address: _addressController.text.trim(),
    );
    if (!mounted) return;

    if (success) {
      final accessToken = auth.accessToken;
      final refreshToken = auth.refreshToken;
      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        // completeRegistration() reported success but didn't give us usable
        // session tokens (backend contract violation) — don't persist an
        // empty/missing token as if it were valid. Recover via Login
        // instead of landing on Dashboard with a broken session.
        CustomSnackbar.error(
          context,
          'Registration succeeded but signing you in failed. Please log in.',
        );
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
        return;
      }
      final storage = context.read<SecureStorageService>();
      await storage.saveAccessToken(accessToken);
      await storage.saveRefreshToken(refreshToken);
      await storage.saveSession();
      if (!mounted) return;
      // A previous logout may have left Dashboard reset to its initial
      // state (or a prior session's data cached) — refresh explicitly so
      // this fresh login shows current data rather than stale/empty data.
      context.read<DashboardProvider>().refresh();
      NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
    } else {
      CustomSnackbar.error(
        context,
        auth.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = context.screenHeight;
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet
              ? AppDimensions.maxContentWidth * 0.6
              : double.infinity);
    final isRegistering = context.watch<AuthProvider>().isRegistering;
    final background = isDark
        ? AuthColors.backgroundDarkMode
        : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark
        ? AuthColors.bodyTextDarkMode
        : AuthColors.bodyText;
    final lightBlue = isDark
        ? AuthColors.lightBlueDarkMode
        : AuthColors.lightBlue;

    return PopScope(
      canPop: !isRegistering,
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
                    colors: [
                      background,
                      background,
                      lightBlue.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _entrance,
              builder: (context, _) {
                final illustrationT = const Interval(
                  0.20,
                  0.65,
                  curve: Curves.easeOutCubic,
                ).transform(_entrance.value);
                final opacity = illustrationT.clamp(0.0, 1.0);
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: screenHeight * 0.24,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, (1 - opacity) * 20),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: AuthSkylinePainter(progress: opacity),
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                          final logoT = const Interval(
                            0.00,
                            0.35,
                            curve: Curves.easeOutBack,
                          ).transform(t);
                          final headingT = const Interval(
                            0.10,
                            0.45,
                            curve: Curves.easeOut,
                          ).transform(t);
                          final subheadingT = const Interval(
                            0.16,
                            0.50,
                            curve: Curves.easeOut,
                          ).transform(t);
                          final formT = const Interval(
                            0.26,
                            0.72,
                            curve: Curves.easeOutCubic,
                          ).transform(t);
                          final buttonT = const Interval(
                            0.55,
                            0.90,
                            curve: Curves.easeOutCubic,
                          ).transform(t);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: AppSpacing.lg),
                              Opacity(
                                opacity: logoT.clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
                                  child: const NivassLogoMark(size: 72),
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              FadeSlideIn(
                                progress: headingT,
                                child: Text(
                                  'Create Your Profile',
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
                                  'Just a few details to get your account ready.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: bodyText,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),
                              FadeSlideIn(
                                progress: formT,
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: _fullNameController,
                                        label: 'Full Name',
                                        hint: 'Enter your full name',
                                        prefixIcon: AppIcons.profile,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[A-Za-z ]'),
                                          ),
                                        ],
                                        validator: FormValidators.fullName,
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      CustomTextField(
                                        controller: _emailController,
                                        label: 'Email (Optional)',
                                        hint: 'Enter your email address',
                                        prefixIcon: AppIcons.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: FormValidators.optionalEmail,
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      CustomTextField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        hint: 'Create a password',
                                        prefixIcon: AppIcons.lock,
                                        obscureText: _obscurePassword,
                                        textInputAction: TextInputAction.next,
                                        // Forces a rebuild on every keystroke so the Confirm
                                        // Password field's validator (which closes over this
                                        // field's current text) never validates against a
                                        // stale password.
                                        onChanged: (_) => setState(() {}),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? AppIcons.visibilityOff
                                                : AppIcons.visibilityOn,
                                            size: AppDimensions.iconSm,
                                            color: bodyText,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                        ),
                                        validator: FormValidators.password,
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      CustomTextField(
                                        controller: _confirmPasswordController,
                                        label: 'Confirm Password',
                                        hint: 'Re-enter your password',
                                        prefixIcon: AppIcons.lock,
                                        obscureText: _obscureConfirmPassword,
                                        textInputAction: TextInputAction.next,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? AppIcons.visibilityOff
                                                : AppIcons.visibilityOn,
                                            size: AppDimensions.iconSm,
                                            color: bodyText,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscureConfirmPassword =
                                                !_obscureConfirmPassword,
                                          ),
                                        ),
                                        validator:
                                            FormValidators.confirmPassword(
                                              _passwordController.text,
                                            ),
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      CustomTextField(
                                        controller: _addressController,
                                        label: 'Address',
                                        hint: 'Enter your address',
                                        prefixIcon: AppIcons.location,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        textInputAction:
                                            TextInputAction.newline,
                                        maxLines: 3,
                                        validator: (v) =>
                                            FormValidators.required(
                                              v,
                                              message: 'Address is required',
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
                                  label: 'Create Profile',
                                  isLoading: isRegistering,
                                  onPressed: _handleSubmit,
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
