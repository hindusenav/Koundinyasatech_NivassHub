// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';
// import 'package:flutter_nivasshub/constants/app_colors.dart';
// import 'package:flutter_nivasshub/constants/app_dimensions.dart';
// import 'package:flutter_nivasshub/constants/app_icons.dart';
// import 'package:flutter_nivasshub/constants/app_radius.dart';
// import 'package:flutter_nivasshub/constants/app_spacing.dart';
// import 'package:flutter_nivasshub/constants/app_text_styles.dart';
// import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
// import 'package:flutter_nivasshub/utils/form_validators.dart';
// import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
// import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
// import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
// import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
// import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
// import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
// import 'package:flutter_nivasshub/widgets/auth/country_code_badge.dart';
// import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';

// /// Mobile-number entry point into the OTP login flow. Sends an OTP for the
// /// entered number, then navigates to [OtpVerificationScreen].
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
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

//   Future<void> _handleLogin() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     context.hideKeyboard();
//     final mobile = _mobileController.text.trim();
//     final auth = context.read<AuthProvider>();
//     final success = await auth.sendOtp(mobile);
//     if (!mounted) return;

//     if (success) {
//       Navigator.pushNamed(
//         context,
//         AppRoutes.otpVerification,
//         arguments: OtpVerificationScreenArgs(
//           mobileNumber: auth.mobileNumber ?? mobile,
//           otpExpirySeconds: auth.otpExpirySeconds,
//           isRegistrationFlow: false,
//         ),
//       );
//     } else {
//       CustomSnackbar.error(
//         context,
//         auth.errorMessage ?? 'Failed to send OTP. Please try again.',
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final screenHeight = context.screenHeight;
//     final contentWidth = context.isDesktop
//         ? AppDimensions.maxContentWidth * 0.4
//         : (context.isTablet
//               ? AppDimensions.maxContentWidth * 0.6
//               : double.infinity);
//     final isSendingOtp = context.watch<AuthProvider>().isSendingOtp;
//     final background = isDark
//         ? AuthColors.backgroundDarkMode
//         : AuthColors.background;
//     final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
//     final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
//     final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
//     final primaryBlue = isDark
//         ? AuthColors.primaryBlueDarkMode
//         : AuthColors.primaryBlue;
//     final lightBlue = isDark
//         ? AuthColors.lightBlueDarkMode
//         : AuthColors.lightBlue;

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
//                     colors: [
//                       background,
//                       background,
//                       lightBlue.withValues(alpha: 0.05),
//                     ],
//                     stops: const [0.0, 0.55, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: _entrance,
//               builder: (context, _) {
//                 final illustrationT = const Interval(
//                   0.20,
//                   0.65,
//                   curve: Curves.easeOutCubic,
//                 ).transform(_entrance.value);
//                 final opacity = illustrationT.clamp(0.0, 1.0);
//                 return Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   height: screenHeight * 0.32,
//                   child: IgnorePointer(
//                     child: Opacity(
//                       opacity: opacity,
//                       child: Transform.translate(
//                         offset: Offset(0, (1 - opacity) * 20),
//                         child: CustomPaint(
//                           size: Size.infinite,
//                           painter: AuthSkylinePainter(progress: opacity),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SafeArea(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: contentWidth),
//                   child: Padding(
//                     padding: AppSpacing.horizontal(AppSpacing.lg),
//                     child: SingleChildScrollView(
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minHeight: screenHeight - AppSpacing.xxxl,
//                         ),
//                         child: AnimatedBuilder(
//                           animation: _entrance,
//                           builder: (context, _) {
//                             final t = _entrance.value;
//                             final logoT = const Interval(
//                               0.00,
//                               0.40,
//                               curve: Curves.easeOutBack,
//                             ).transform(t);
//                             final headingT = const Interval(
//                               0.15,
//                               0.50,
//                               curve: Curves.easeOut,
//                             ).transform(t);
//                             final subheadingT = const Interval(
//                               0.22,
//                               0.56,
//                               curve: Curves.easeOut,
//                             ).transform(t);
//                             final labelT = const Interval(
//                               0.32,
//                               0.64,
//                               curve: Curves.easeOut,
//                             ).transform(t);
//                             final fieldRowT = const Interval(
//                               0.38,
//                               0.70,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final buttonT = const Interval(
//                               0.50,
//                               0.82,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final footerT = const Interval(
//                               0.62,
//                               1.00,
//                               curve: Curves.easeOut,
//                             ).transform(t);

//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Opacity(
//                                   opacity: logoT.clamp(0.0, 1.0),
//                                   child: Transform.scale(
//                                     scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
//                                     child: const NivassLogoMark(size: 72),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.lg),
//                                 FadeSlideIn(
//                                   progress: headingT,
//                                   child: Text(
//                                     'Welcome Back!',
//                                     textAlign: TextAlign.center,
//                                     style: AppTextStyles.headlineSmall.copyWith(
//                                       color: heading,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xs),
//                                 FadeSlideIn(
//                                   progress: subheadingT,
//                                   child: Text(
//                                     'Login to access your Account',
//                                     textAlign: TextAlign.center,
//                                     style: AppTextStyles.bodyLarge.copyWith(
//                                       color: bodyText,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),
//                                 FadeSlideIn(
//                                   progress: labelT,
//                                   child: Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       'Mobile Number',
//                                       style: AppTextStyles.labelLarge.copyWith(
//                                         color: heading,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.sm),
//                                 FadeSlideIn(
//                                   progress: fieldRowT,
//                                   child: Form(
//                                     key: _formKey,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const CountryCodeBadge(),
//                                         AppSpacing.gapWSm,
//                                         Expanded(
//                                           child: Theme(
//                                             data: Theme.of(context).copyWith(
//                                               inputDecorationTheme:
//                                                   Theme.of(context)
//                                                       .inputDecorationTheme
//                                                       .copyWith(
//                                                         fillColor: isDark
//                                                             ? AppColors
//                                                                   .surfaceDark
//                                                             : Colors.white,
//                                                         enabledBorder:
//                                                             OutlineInputBorder(
//                                                               borderRadius:
//                                                                   AppRadius
//                                                                       .radiusSm,
//                                                               borderSide:
//                                                                   BorderSide(
//                                                                     color:
//                                                                         border,
//                                                                   ),
//                                                             ),
//                                                         border:
//                                                             OutlineInputBorder(
//                                                               borderRadius:
//                                                                   AppRadius
//                                                                       .radiusSm,
//                                                               borderSide:
//                                                                   BorderSide(
//                                                                     color:
//                                                                         border,
//                                                                   ),
//                                                             ),
//                                                         hintStyle: AppTextStyles
//                                                             .bodyMedium
//                                                             .copyWith(
//                                                               color: bodyText,
//                                                             ),
//                                                       ),
//                                             ),
//                                             child: CustomTextField(
//                                               controller: _mobileController,
//                                               hint: 'Enter mobile number',
//                                               keyboardType: TextInputType.phone,
//                                               textInputAction:
//                                                   TextInputAction.done,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                   10,
//                                                 ),
//                                               ],
//                                               validator:
//                                                   FormValidators.mobileNumber,
//                                               onFieldSubmitted: (_) =>
//                                                   _handleLogin(),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),
//                                 FadeSlideIn(
//                                   progress: buttonT,
//                                   child: AuthGradientButton(
//                                     label: 'Login with OTP',
//                                     icon: AppIcons.phone,
//                                     isLoading: isSendingOtp,
//                                     onPressed: _handleLogin,
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),
//                                 FadeSlideIn(
//                                   progress: footerT,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'New to Nivaas Hub? ',
//                                         style: AppTextStyles.bodyMedium
//                                             .copyWith(color: bodyText),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () => Navigator.pushNamed(
//                                           context,
//                                           AppRoutes.register,
//                                         ),
//                                         child: Text(
//                                           'Create an account',
//                                           style: AppTextStyles.bodyMedium
//                                               .copyWith(
//                                                 color: primaryBlue,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.06),
//                               ],
//                             );
//                           },
//                         ),
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

/////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';

/// Mobile-number entry point into the OTP login flow. Sends an OTP for the
/// entered number, then navigates to [OtpVerificationScreen].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedCountryCode = '+91';
  bool _isEmailMode = false;
  bool _obscurePassword = true;

  // List of 10 countries with their codes
  final List<Map<String, String>> _countries = [
    {'code': '+91', 'name': 'India 🇮🇳'},
    {'code': '+1', 'name': 'USA 🇺🇸'},
    {'code': '+44', 'name': 'UK 🇬🇧'},
    {'code': '+61', 'name': 'Australia 🇦🇺'},
    {'code': '+81', 'name': 'Japan 🇯🇵'},
    {'code': '+49', 'name': 'Germany 🇩🇪'},
    {'code': '+33', 'name': 'France 🇫🇷'},
    {'code': '+39', 'name': 'Italy 🇮🇹'},
    {'code': '+55', 'name': 'Brazil 🇧🇷'},
    {'code': '+86', 'name': 'China 🇨🇳'},
  ];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _mobileController.addListener(_onMobileTextChanged);
  }

  void _onMobileTextChanged() {
    final text = _mobileController.text;
    // Check if input contains letters (alphabetical characters)
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
    if (hasLetters && !_isEmailMode) {
      setState(() {
        _isEmailMode = true;
        // Keep the text when switching to email mode
        _mobileController.text = text;
      });
    } else if (!hasLetters && _isEmailMode) {
      // If no letters and currently in email mode, switch back to number mode
      // But only if the text is empty or only numbers
      final onlyNumbers = RegExp(r'^[0-9]*$').hasMatch(text);
      if (onlyNumbers) {
        setState(() {
          _isEmailMode = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final mobileValid = _mobileController.text.isNotEmpty;
    final passwordValid = _passwordController.text.length >= 8;
    return mobileValid && passwordValid;
  }

  Future<void> _handleLogin() async {
    // Check if form is valid - properly handle nullable
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    context.hideKeyboard();

    // Handle login based on mode
    if (_isEmailMode) {
      // Email login logic here
      final email = _mobileController.text.trim();
      final password = _passwordController.text.trim();
      // TODO: Implement email/password login
      // For now, show a snackbar
      if (mounted) {
        CustomSnackbar.info(context, 'Email login feature coming soon!');
      }
    } else {
      // Phone OTP login logic
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
            isRegistrationFlow: false,
          ),
        );
      } else {
        CustomSnackbar.error(
          context,
          auth.errorMessage ?? 'Failed to send OTP. Please try again.',
        );
      }
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
    final isSendingOtp = context.watch<AuthProvider>().isSendingOtp;
    final background = isDark
        ? AuthColors.backgroundDarkMode
        : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
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
                            final logoT = const Interval(
                              0.00,
                              0.40,
                              curve: Curves.easeOutBack,
                            ).transform(t);
                            final headingT = const Interval(
                              0.15,
                              0.50,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final subheadingT = const Interval(
                              0.22,
                              0.56,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final labelT = const Interval(
                              0.32,
                              0.64,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final fieldRowT = const Interval(
                              0.38,
                              0.70,
                              curve: Curves.easeOutCubic,
                            ).transform(t);
                            final passwordLabelT = const Interval(
                              0.44,
                              0.74,
                              curve: Curves.easeOut,
                            ).transform(t);
                            final passwordFieldT = const Interval(
                              0.50,
                              0.78,
                              curve: Curves.easeOutCubic,
                            ).transform(t);
                            final buttonT = const Interval(
                              0.58,
                              0.86,
                              curve: Curves.easeOutCubic,
                            ).transform(t);
                            final footerT = const Interval(
                              0.68,
                              1.00,
                              curve: Curves.easeOut,
                            ).transform(t);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                    'Welcome Back!',
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
                                    _isEmailMode
                                        ? 'Login with Email'
                                        : 'Login to access your Account',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: bodyText,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: labelT,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _isEmailMode
                                          ? 'Email Address'
                                          : 'Mobile Number',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: heading,
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
                                        if (!_isEmailMode)
                                          _buildCountryDropdown(border, isDark),
                                        if (!_isEmailMode) AppSpacing.gapWSm,
                                        Expanded(
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              inputDecorationTheme:
                                                  Theme.of(context)
                                                      .inputDecorationTheme
                                                      .copyWith(
                                                        fillColor: isDark
                                                            ? AppColors
                                                                  .surfaceDark
                                                            : Colors.white,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  AppRadius
                                                                      .radiusSm,
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        border,
                                                                  ),
                                                            ),
                                                        border:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  AppRadius
                                                                      .radiusSm,
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        border,
                                                                  ),
                                                            ),
                                                        hintStyle: AppTextStyles
                                                            .bodyMedium
                                                            .copyWith(
                                                              color: bodyText,
                                                            ),
                                                      ),
                                            ),
                                            child: CustomTextField(
                                              controller: _mobileController,
                                              hint: _isEmailMode
                                                  ? 'Enter email address'
                                                  : 'Enter mobile number',
                                              keyboardType: _isEmailMode
                                                  ? TextInputType.emailAddress
                                                  : TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.next,
                                              inputFormatters: _isEmailMode
                                                  ? []
                                                  : [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                        10,
                                                      ),
                                                    ],
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return _isEmailMode
                                                      ? 'Please enter your email'
                                                      : 'Please enter your mobile number';
                                                }
                                                if (_isEmailMode) {
                                                  // Email validation - must end with @gmail.com
                                                  if (!value.contains(
                                                    '@gmail.com',
                                                  )) {
                                                    return 'Email must be a valid @gmail.com address';
                                                  }
                                                  if (!RegExp(
                                                    r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                                                  ).hasMatch(value)) {
                                                    return 'Please enter a valid Gmail address';
                                                  }
                                                } else {
                                                  // Mobile validation - exactly 10 digits
                                                  if (value.length != 10) {
                                                    return 'Mobile number must be exactly 10 digits';
                                                  }
                                                }
                                                return null;
                                              },
                                              onFieldSubmitted: (_) =>
                                                  FocusScope.of(
                                                    context,
                                                  ).nextFocus(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.lg),
                                FadeSlideIn(
                                  progress: passwordLabelT,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Password',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: heading,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                FadeSlideIn(
                                  progress: passwordFieldT,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      inputDecorationTheme: Theme.of(context)
                                          .inputDecorationTheme
                                          .copyWith(
                                            fillColor: isDark
                                                ? AppColors.surfaceDark
                                                : Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: AppRadius.radiusSm,
                                              borderSide: BorderSide(
                                                color: border,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: AppRadius.radiusSm,
                                              borderSide: BorderSide(
                                                color: border,
                                              ),
                                            ),
                                            hintStyle: AppTextStyles.bodyMedium
                                                .copyWith(color: bodyText),
                                          ),
                                    ),
                                    child: CustomTextField(
                                      controller: _passwordController,
                                      hint: 'Enter password (min 8 characters)',
                                      obscureText: _obscurePassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [],
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: bodyText,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 8) {
                                          return 'Password must be at least 8 characters';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _handleLogin(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: buttonT,
                                  child: AuthGradientButton(
                                    label: _isEmailMode
                                        ? 'Login with Email'
                                        : 'Login with OTP',
                                    icon: _isEmailMode
                                        ? Icons.email
                                        : AppIcons.phone,
                                    isLoading: isSendingOtp,
                                    onPressed: _isFormValid()
                                        ? _handleLogin
                                        : null,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),
                                FadeSlideIn(
                                  progress: footerT,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'New to Nivaas Hub? ',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(color: bodyText),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              AppRoutes.register,
                                            ),
                                            child: Text(
                                              'Create an account',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: primaryBlue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isEmailMode = !_isEmailMode;
                                            _mobileController.clear();
                                          });
                                        },
                                        child: Text(
                                          _isEmailMode
                                              ? 'Use Mobile Number instead'
                                              : 'Use Email instead',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: primaryBlue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.04),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(Color border, bool isDark) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: AppRadius.radiusSm,
        color: isDark ? AppColors.surfaceDark : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCountryCode,
            icon: Icon(
              Icons.arrow_drop_down,
              color: isDark ? Colors.white : Colors.black87,
            ),
            iconSize: 24,
            elevation: 16,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountryCode = newValue!;
              });
            },
            items: _countries.map<DropdownMenuItem<String>>((country) {
              return DropdownMenuItem<String>(
                value: country['code'],
                child: Row(
                  children: [
                    Text(country['name']!),
                    const SizedBox(width: 8),
                    Text(
                      country['code']!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
