import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_back_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_registration_footer.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_shield_badge.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/country_code_badge.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';

/// Mobile-number entry point into the OTP registration flow for new users.
/// Sends an OTP for the entered number, then navigates to
/// [OtpVerificationScreen] with `isRegistrationFlow: true`.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

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
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.hideKeyboard();
    final mobile = _mobileController.text.trim();
    final auth = context.read<AuthProvider>();
    final success = await auth.sendOtp(mobile);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,
        arguments: OtpVerificationScreenArgs(
          mobileNumber: auth.mobileNumber ?? mobile,
          otpExpirySeconds: auth.otpExpirySeconds,
          isRegistrationFlow: true,
        ),
      );
    } else {
      CustomSnackbar.error(
        context,
        auth.errorMessage ?? 'Failed to send OTP. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet
              ? AppDimensions.maxContentWidth * 0.6
              : double.infinity);
    final isSendingOtp = context.watch<AuthProvider>().isSendingOtp;

    return PopScope(
      canPop: !isSendingOtp,
      child: Scaffold(
        backgroundColor: AuthColors.background,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AuthColors.background,
                      AuthColors.background,
                      AuthColors.lightBlue.withValues(alpha: 0.05),
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
                  height: screenHeight * 0.32,
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight - AppSpacing.xxxl,
                        ),
                        child: AnimatedBuilder(
                          animation: _entrance,
                          builder: (context, _) {
                            final t = _entrance.value;
                            final badgeT = const Interval(
                              0.00,
                              0.40,
                              curve: Curves.easeOutBack,
                            ).transform(t);
                            final headingT = const Interval(
                              0.12,
                              0.48,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final subheadingT = const Interval(
                              0.20,
                              0.54,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final labelT = const Interval(
                              0.30,
                              0.62,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final fieldRowT = const Interval(
                              0.36,
                              0.68,
                              curve: Curves.easeOutCubic,
                            ).transform(t);
                            final noteT = const Interval(
                              0.42,
                              0.74,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final buttonT = const Interval(
                              0.50,
                              0.82,
                              curve: Curves.easeOutCubic,
                            ).transform(t);
                            final footerT = const Interval(
                              0.62,
                              1.00,
                              curve: Curves.easeOut,
                            ).transform(t);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Opacity(
                                  opacity: badgeT.clamp(0.0, 1.0),
                                  child: Transform.scale(
                                    scale: 0.85 + badgeT.clamp(0.0, 1.0) * 0.15,
                                    child: const AuthShieldBadge(),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.lg),
                                FadeSlideIn(
                                  progress: headingT,
                                  child: Text(
                                    'Enter Your Mobile Number',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      color: AuthColors.heading,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                FadeSlideIn(
                                  progress: subheadingT,
                                  child: Text(
                                    'We will send a one-time password to verify your mobile '
                                    'number. This helps keep your account secure.',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AuthColors.bodyText,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: labelT,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Mobile Number',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: AuthColors.heading,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                FadeSlideIn(
                                  progress: fieldRowT,
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CountryCodeBadge(),
                                        AppSpacing.gapWSm,
                                        Expanded(
                                          child: CustomTextField(
                                            controller: _mobileController,
                                            hint: 'Enter mobile number',
                                            keyboardType: TextInputType.phone,
                                            textInputAction:
                                                TextInputAction.done,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                10,
                                              ),
                                            ],
                                            validator:
                                                FormValidators.mobileNumber,
                                            onFieldSubmitted: (_) =>
                                                _handleSendOtp(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),
                                FadeSlideIn(
                                  progress: noteT,
                                  child: Column(
                                    children: [
                                      Text(
                                        'OTP will be sent via SMS. Standard message rates may apply.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.caption,
                                      ),
                                      SizedBox(height: AppSpacing.xs),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            AppIcons.lock,
                                            size: AppDimensions.iconXs,
                                            color: AuthColors.bodyText,
                                          ),
                                          AppSpacing.gapWXs,
                                          Text(
                                            'Your data is encrypted and secure.',
                                            style: AppTextStyles.caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: buttonT,
                                  child: AuthGradientButton(
                                    label: 'Send OTP',
                                    icon: AppIcons.phone,
                                    isLoading: isSendingOtp,
                                    onPressed: _handleSendOtp,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: footerT,
                                  child: const AuthRegistrationFooter(),
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
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.all(AppSpacing.sm),
                child: AuthBackButton(
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
