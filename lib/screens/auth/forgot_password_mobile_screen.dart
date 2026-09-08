// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_nivasshub/constants/app_dimensions.dart';
// import 'package:flutter_nivasshub/constants/app_icons.dart';
// import 'package:flutter_nivasshub/constants/app_spacing.dart';
// import 'package:flutter_nivasshub/constants/app_text_styles.dart';
// import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
// import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';
// import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
// import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
// import 'package:flutter_nivasshub/utils/form_validators.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_back_button.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
// import 'package:flutter_nivasshub/widgets/auth/country_code_badge.dart';
// import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
// import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
// import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

// /// Screen 2 — collects the registered mobile number and requests an OTP.
// /// No arguments; on success navigates to the shared OTP-verify screen with
// /// `channel: mobile`.
// class ForgotPasswordMobileScreen extends StatefulWidget {
//   const ForgotPasswordMobileScreen({super.key});

//   @override
//   State<ForgotPasswordMobileScreen> createState() => _ForgotPasswordMobileScreenState();
// }

// class _ForgotPasswordMobileScreenState extends State<ForgotPasswordMobileScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _entrance;
//   final _formKey = GlobalKey<FormState>();
//   final _mobileController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _entrance = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _entrance.dispose();
//     _mobileController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSendOtp() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     context.hideKeyboard();
//     final forgotPassword = context.read<ForgotPasswordProvider>();
//     final mobileNumber = _mobileController.text.trim();
//     final success = await forgotPassword.sendOtp(
//       identifier: mobileNumber,
//       channel: ForgotPasswordChannel.mobile,
//     );
//     if (!mounted) return;

//     if (success) {
//       Navigator.pushNamed(
//         context,
//         AppRoutes.forgotPasswordVerifyOtp,
//         arguments: ForgotPasswordVerifyOtpScreenArgs(
//           identifier: mobileNumber,
//           channel: ForgotPasswordChannel.mobile,
//         ),
//       );
//     } else {
//       CustomSnackbar.error(
//         context,
//         forgotPassword.errorMessage ?? 'Failed to send OTP. Please try again.',
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final screenHeight = context.screenHeight;
//     final contentWidth = context.isDesktop
//         ? AppDimensions.maxContentWidth * 0.4
//         : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
//     final isSendingOtp = context.watch<ForgotPasswordProvider>().isSendingOtp;
//     final background = isDark ? AuthColors.backgroundDarkMode : AuthColors.background;
//     final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
//     final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
//     final primaryBlue = isDark ? AuthColors.primaryBlueDarkMode : AuthColors.primaryBlue;
//     final lightBlue = isDark ? AuthColors.lightBlueDarkMode : AuthColors.lightBlue;

//     return PopScope(
//       canPop: !isSendingOtp,
//       child: Scaffold(
//         backgroundColor: background,
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [background, background, lightBlue.withValues(alpha: 0.05)],
//                     stops: const [0.0, 0.55, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: AppSpacing.all(AppSpacing.sm),
//                   child: AuthBackButton(onTap: () => Navigator.pop(context)),
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: contentWidth),
//                   child: Padding(
//                     padding: AppSpacing.horizontal(AppSpacing.lg),
//                     child: SingleChildScrollView(
//                       child: AnimatedBuilder(
//                         animation: _entrance,
//                         builder: (context, _) {
//                           final t = _entrance.value;
//                           final headingT =
//                               const Interval(0.10, 0.45, curve: Curves.easeOut).transform(t);
//                           final subheadingT =
//                               const Interval(0.16, 0.50, curve: Curves.easeOut).transform(t);
//                           final formT =
//                               const Interval(0.26, 0.72, curve: Curves.easeOutCubic).transform(t);
//                           final buttonT =
//                               const Interval(0.55, 0.90, curve: Curves.easeOutCubic).transform(t);
//                           final footerT =
//                               const Interval(0.65, 0.98, curve: Curves.easeOut).transform(t);

//                           return Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(height: screenHeight * 0.08),
//                               FadeSlideIn(
//                                 progress: headingT,
//                                 child: Text(
//                                   'Forgot Password?',
//                                   textAlign: TextAlign.center,
//                                   style: AppTextStyles.headlineSmall.copyWith(
//                                     color: heading,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: AppSpacing.xs),
//                               FadeSlideIn(
//                                 progress: subheadingT,
//                                 child: Text(
//                                   "Enter your registered mobile number and we'll send you an "
//                                   'OTP to reset your password.',
//                                   textAlign: TextAlign.center,
//                                   style: AppTextStyles.bodyMedium.copyWith(color: bodyText),
//                                 ),
//                               ),
//                               SizedBox(height: AppSpacing.xl),
//                               FadeSlideIn(
//                                 progress: formT,
//                                 child: Form(
//                                   key: _formKey,
//                                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const CountryCodeBadge(),
//                                       AppSpacing.gapWSm,
//                                       Expanded(
//                                         child: CustomTextField(
//                                           controller: _mobileController,
//                                           hint: 'Enter Mobile Number',
//                                           keyboardType: TextInputType.phone,
//                                           textInputAction: TextInputAction.done,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly,
//                                             LengthLimitingTextInputFormatter(10),
//                                           ],
//                                           validator: FormValidators.mobileNumber,
//                                           onFieldSubmitted: (_) => _handleSendOtp(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: AppSpacing.xl),
//                               Opacity(
//                                 opacity: buttonT.clamp(0.0, 1.0),
//                                 child: AuthGradientButton(
//                                   label: 'Send OTP',
//                                   isLoading: isSendingOtp,
//                                   onPressed: isSendingOtp ? null : _handleSendOtp,
//                                 ),
//                               ),
//                               SizedBox(height: AppSpacing.lg),
//                               Opacity(
//                                 opacity: footerT.clamp(0.0, 1.0),
//                                 child: GestureDetector(
//                                   onTap: isSendingOtp ? null : () => Navigator.pop(context),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         AppIcons.back,
//                                         size: AppDimensions.iconXs,
//                                         color: primaryBlue,
//                                       ),
//                                       AppSpacing.gapWXs,
//                                       Text(
//                                         'Back to Options',
//                                         style: AppTextStyles.bodyMedium.copyWith(
//                                           color: primaryBlue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.06),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///////////////////////////////////////////////////

// lib/screens/auth/forgot_password_mobile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_back_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/country_code_badge.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import '../../services/forget_Password/forget_password_service.dart';

/// Screen 2 — collects the registered mobile number and requests an OTP.
/// No arguments; on success navigates to the shared OTP-verify screen with
/// `channel: mobile`.
class ForgotPasswordMobileScreen extends StatefulWidget {
  const ForgotPasswordMobileScreen({super.key});

  @override
  State<ForgotPasswordMobileScreen> createState() =>
      _ForgotPasswordMobileScreenState();
}

class _ForgotPasswordMobileScreenState extends State<ForgotPasswordMobileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  // Create service instance
  final _service = ForgotPasswordService();

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
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final mobileNumber = _mobileController.text.trim();

    // Set loading state
    forgotPassword.setSendingOtp(true);
    forgotPassword.clearError();

    try {
      // Call the API directly
      final response = await _service.generateOTP(
        umail: mobileNumber,
        contCode: '+91', // You can make this dynamic based on selected country
        action: 'GENERATE',
      );

      if (!mounted) return;

      if (response.success && response.otpKey != null) {
        // Store OTP key and other data in provider
        forgotPassword.setOtpData(
          otpKey: response.otpKey!,
          identifier: response.identifier ?? mobileNumber,
          otpType: response.otpType ?? 'SMS',
          channel: ForgotPasswordChannel.mobile,
        );

        // Navigate to verification screen
        Navigator.pushNamed(
          context,
          AppRoutes.forgotPasswordVerifyOtp,
          arguments: ForgotPasswordVerifyOtpScreenArgs(
            identifier: mobileNumber,
            channel: ForgotPasswordChannel.mobile,
          ),
        );

        CustomSnackbar.success(context, response.message);
      } else {
        CustomSnackbar.error(context, response.message);
      }
    } on ForgotPasswordException catch (e) {
      if (!mounted) return;
      _handleError(e.statusCode, e.message);
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.error(
        context,
        'An unexpected error occurred. Please try again.',
      );
    } finally {
      if (mounted) {
        forgotPassword.setSendingOtp(false);
      }
    }
  }

  void _handleError(int statusCode, String message) {
    if (statusCode == 429) {
      // Handle rate limiting - show countdown if available
      CustomSnackbar.error(context, message);
    } else if (statusCode == 404) {
      CustomSnackbar.error(
        context,
        'No account found with this mobile number.',
      );
    } else if (statusCode == 403) {
      CustomSnackbar.error(
        context,
        'This account is not verified. Please contact support.',
      );
    } else if (statusCode == 400) {
      CustomSnackbar.error(context, message);
    } else {
      CustomSnackbar.error(context, message);
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
    final isSendingOtp = context.watch<ForgotPasswordProvider>().isSendingOtp;
    final background = isDark
        ? AuthColors.backgroundDarkMode
        : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;
    final lightBlue = isDark
        ? AuthColors.lightBlueDarkMode
        : AuthColors.lightBlue;

    return PopScope(
      canPop: !isSendingOtp,
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
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: AppSpacing.all(AppSpacing.sm),
                  child: AuthBackButton(onTap: () => Navigator.pop(context)),
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
                          final footerT = const Interval(
                            0.65,
                            0.98,
                            curve: Curves.easeOut,
                          ).transform(t);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.08),
                              FadeSlideIn(
                                progress: headingT,
                                child: Text(
                                  'Forgot Password?',
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
                                  "Enter your registered mobile number and we'll send you an "
                                  'OTP to reset your password.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CountryCodeBadge(),
                                      AppSpacing.gapWSm,
                                      Expanded(
                                        child: CustomTextField(
                                          controller: _mobileController,
                                          hint: 'Enter Mobile Number',
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.done,
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
                              SizedBox(height: AppSpacing.xl),
                              Opacity(
                                opacity: buttonT.clamp(0.0, 1.0),
                                child: AuthGradientButton(
                                  label: 'Send OTP',
                                  isLoading: isSendingOtp,
                                  onPressed: isSendingOtp
                                      ? null
                                      : _handleSendOtp,
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Opacity(
                                opacity: footerT.clamp(0.0, 1.0),
                                child: GestureDetector(
                                  onTap: isSendingOtp
                                      ? null
                                      : () => Navigator.pop(context),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        AppIcons.back,
                                        size: AppDimensions.iconXs,
                                        color: primaryBlue,
                                      ),
                                      AppSpacing.gapWXs,
                                      Text(
                                        'Back to Options',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: primaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
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
