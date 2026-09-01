// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter_nivasshub/routes/app_routes.dart';
// // import 'package:flutter_nivasshub/constants/app_colors.dart';
// // import 'package:flutter_nivasshub/constants/app_dimensions.dart';
// // import 'package:flutter_nivasshub/constants/app_icons.dart';
// // import 'package:flutter_nivasshub/constants/app_radius.dart';
// // import 'package:flutter_nivasshub/constants/app_spacing.dart';
// // import 'package:flutter_nivasshub/constants/app_text_styles.dart';
// // import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
// // import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
// // import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
// // import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
// // import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
// // import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
// // import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
// // import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
// // import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
// // import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';

// // /// Mobile-number entry point into the OTP login flow. Sends an OTP for the
// // /// entered number, then navigates to [OtpVerificationScreen].
// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _entrance;
// //   final _formKey = GlobalKey<FormState>();
// //   final _mobileController = TextEditingController();
// //   final _passwordController = TextEditingController();

// //   String _selectedCountryCode = '+91';
// //   bool _isEmailMode = false;
// //   bool _obscurePassword = true;

// //   // List of 10 countries with their codes
// //   final List<Map<String, String>> _countries = [
// //     {'code': '+91', 'name': 'India 🇮🇳'},
// //     {'code': '+1', 'name': 'USA 🇺🇸'},
// //     {'code': '+44', 'name': 'UK 🇬🇧'},
// //     {'code': '+61', 'name': 'Australia 🇦🇺'},
// //     {'code': '+81', 'name': 'Japan 🇯🇵'},
// //     {'code': '+49', 'name': 'Germany 🇩🇪'},
// //     {'code': '+33', 'name': 'France 🇫🇷'},
// //     {'code': '+39', 'name': 'Italy 🇮🇹'},
// //     {'code': '+55', 'name': 'Brazil 🇧🇷'},
// //     {'code': '+86', 'name': 'China 🇨🇳'},
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _entrance = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 900),
// //     )..forward();

// //     _mobileController.addListener(_onMobileTextChanged);
// //   }

// //   void _onMobileTextChanged() {
// //     final text = _mobileController.text;
// //     // Check if input contains letters (alphabetical characters)
// //     final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
// //     if (hasLetters && !_isEmailMode) {
// //       setState(() {
// //         _isEmailMode = true;
// //         // Keep the text when switching to email mode
// //         _mobileController.text = text;
// //       });
// //     } else if (!hasLetters && _isEmailMode) {
// //       // If no letters and currently in email mode, switch back to number mode
// //       // But only if the text is empty or only numbers
// //       final onlyNumbers = RegExp(r'^[0-9]*$').hasMatch(text);
// //       if (onlyNumbers) {
// //         setState(() {
// //           _isEmailMode = false;
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _entrance.dispose();
// //     _mobileController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   bool _isFormValid() {
// //     final mobileValid = _mobileController.text.isNotEmpty;
// //     final passwordValid = _passwordController.text.length >= 8;
// //     return mobileValid && passwordValid;
// //   }

// //   Future<void> _handleLogin() async {
// //     // Check if form is valid - properly handle nullable
// //     final form = _formKey.currentState;
// //     if (form == null || !form.validate()) {
// //       return;
// //     }

// //     context.hideKeyboard();

// //     // Handle login based on mode
// //     if (_isEmailMode) {
// //       // Email login logic here
// //       final email = _mobileController.text.trim();
// //       final password = _passwordController.text.trim();
// //       // TODO: Implement email/password login
// //       // For now, show a snackbar
// //       if (mounted) {
// //         CustomSnackbar.info(context, 'Email login feature coming soon!');
// //       }
// //     } else {
// //       // Phone OTP login logic
// //       final mobile = _mobileController.text.trim();
// //       final auth = context.read<AuthProvider>();
// //       final success = await auth.sendOtp(mobile);
// //       if (!mounted) return;

// //       if (success) {
// //         Navigator.pushNamed(
// //           context,
// //           AppRoutes.otpVerification,
// //           arguments: OtpVerificationScreenArgs(
// //             mobileNumber: auth.mobileNumber ?? mobile,
// //             otpExpirySeconds: auth.otpExpirySeconds,
// //             isRegistrationFlow: false,
// //           ),
// //         );
// //       } else {
// //         CustomSnackbar.error(
// //           context,
// //           auth.errorMessage ?? 'Failed to send OTP. Please try again.',
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final screenHeight = context.screenHeight;
// //     final contentWidth = context.isDesktop
// //         ? AppDimensions.maxContentWidth * 0.4
// //         : (context.isTablet
// //               ? AppDimensions.maxContentWidth * 0.6
// //               : double.infinity);
// //     final isSendingOtp = context.watch<AuthProvider>().isSendingOtp;
// //     final background = isDark
// //         ? AuthColors.backgroundDarkMode
// //         : AuthColors.background;
// //     final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
// //     final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
// //     final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
// //     final primaryBlue = isDark
// //         ? AuthColors.primaryBlueDarkMode
// //         : AuthColors.primaryBlue;
// //     final lightBlue = isDark
// //         ? AuthColors.lightBlueDarkMode
// //         : AuthColors.lightBlue;

// //     return PopScope(
// //       canPop: !isSendingOtp,
// //       child: Scaffold(
// //         backgroundColor: background,
// //         body: Stack(
// //           children: [
// //             Positioned.fill(
// //               child: DecoratedBox(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     begin: Alignment.topCenter,
// //                     end: Alignment.bottomCenter,
// //                     colors: [
// //                       background,
// //                       background,
// //                       lightBlue.withValues(alpha: 0.05),
// //                     ],
// //                     stops: const [0.0, 0.55, 1.0],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             AnimatedBuilder(
// //               animation: _entrance,
// //               builder: (context, _) {
// //                 final illustrationT = const Interval(
// //                   0.20,
// //                   0.65,
// //                   curve: Curves.easeOutCubic,
// //                 ).transform(_entrance.value);
// //                 final opacity = illustrationT.clamp(0.0, 1.0);
// //                 return Positioned(
// //                   left: 0,
// //                   right: 0,
// //                   bottom: 0,
// //                   height: screenHeight * 0.32,
// //                   child: IgnorePointer(
// //                     child: Opacity(
// //                       opacity: opacity,
// //                       child: Transform.translate(
// //                         offset: Offset(0, (1 - opacity) * 20),
// //                         child: CustomPaint(
// //                           size: Size.infinite,
// //                           painter: AuthSkylinePainter(progress: opacity),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //             SafeArea(
// //               child: Center(
// //                 child: ConstrainedBox(
// //                   constraints: BoxConstraints(maxWidth: contentWidth),
// //                   child: Padding(
// //                     padding: AppSpacing.horizontal(AppSpacing.lg),
// //                     child: SingleChildScrollView(
// //                       child: ConstrainedBox(
// //                         constraints: BoxConstraints(
// //                           minHeight: screenHeight - AppSpacing.xxxl,
// //                         ),
// //                         child: AnimatedBuilder(
// //                           animation: _entrance,
// //                           builder: (context, _) {
// //                             final t = _entrance.value;
// //                             final logoT = const Interval(
// //                               0.00,
// //                               0.40,
// //                               curve: Curves.easeOutBack,
// //                             ).transform(t);
// //                             final headingT = const Interval(
// //                               0.15,
// //                               0.50,
// //                               curve: Curves.easeOut,
// //                             ).transform(t);
// //                             final subheadingT = const Interval(
// //                               0.22,
// //                               0.56,
// //                               curve: Curves.easeOut,
// //                             ).transform(t);
// //                             final labelT = const Interval(
// //                               0.32,
// //                               0.64,
// //                               curve: Curves.easeOut,
// //                             ).transform(t);
// //                             final fieldRowT = const Interval(
// //                               0.38,
// //                               0.70,
// //                               curve: Curves.easeOutCubic,
// //                             ).transform(t);
// //                             final passwordLabelT = const Interval(
// //                               0.44,
// //                               0.74,
// //                               curve: Curves.easeOut,
// //                             ).transform(t);
// //                             final passwordFieldT = const Interval(
// //                               0.50,
// //                               0.78,
// //                               curve: Curves.easeOutCubic,
// //                             ).transform(t);
// //                             final buttonT = const Interval(
// //                               0.58,
// //                               0.86,
// //                               curve: Curves.easeOutCubic,
// //                             ).transform(t);
// //                             final footerT = const Interval(
// //                               0.68,
// //                               1.00,
// //                               curve: Curves.easeOut,
// //                             ).transform(t);

// //                             return Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Opacity(
// //                                   opacity: logoT.clamp(0.0, 1.0),
// //                                   child: Transform.scale(
// //                                     scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
// //                                     child: const NivassLogoMark(size: 72),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.lg),
// //                                 FadeSlideIn(
// //                                   progress: headingT,
// //                                   child: Text(
// //                                     'Welcome Back!',
// //                                     textAlign: TextAlign.center,
// //                                     style: AppTextStyles.headlineSmall.copyWith(
// //                                       color: heading,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.xs),
// //                                 FadeSlideIn(
// //                                   progress: subheadingT,
// //                                   child: Text(
// //                                     _isEmailMode
// //                                         ? 'Login with Email'
// //                                         : 'Login to access your Account',
// //                                     textAlign: TextAlign.center,
// //                                     style: AppTextStyles.bodyLarge.copyWith(
// //                                       color: bodyText,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.xl),
// //                                 FadeSlideIn(
// //                                   progress: labelT,
// //                                   child: Align(
// //                                     alignment: Alignment.centerLeft,
// //                                     child: Text(
// //                                       _isEmailMode
// //                                           ? 'Email Address'
// //                                           : 'Mobile Number',
// //                                       style: AppTextStyles.labelLarge.copyWith(
// //                                         color: heading,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.sm),
// //                                 FadeSlideIn(
// //                                   progress: fieldRowT,
// //                                   child: Form(
// //                                     key: _formKey,
// //                                     autovalidateMode:
// //                                         AutovalidateMode.onUserInteraction,
// //                                     child: Row(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         if (!_isEmailMode)
// //                                           _buildCountryDropdown(border, isDark),
// //                                         if (!_isEmailMode) AppSpacing.gapWSm,
// //                                         Expanded(
// //                                           child: Theme(
// //                                             data: Theme.of(context).copyWith(
// //                                               inputDecorationTheme:
// //                                                   Theme.of(context)
// //                                                       .inputDecorationTheme
// //                                                       .copyWith(
// //                                                         fillColor: isDark
// //                                                             ? AppColors
// //                                                                   .surfaceDark
// //                                                             : Colors.white,
// //                                                         enabledBorder:
// //                                                             OutlineInputBorder(
// //                                                               borderRadius:
// //                                                                   AppRadius
// //                                                                       .radiusSm,
// //                                                               borderSide:
// //                                                                   BorderSide(
// //                                                                     color:
// //                                                                         border,
// //                                                                   ),
// //                                                             ),
// //                                                         border:
// //                                                             OutlineInputBorder(
// //                                                               borderRadius:
// //                                                                   AppRadius
// //                                                                       .radiusSm,
// //                                                               borderSide:
// //                                                                   BorderSide(
// //                                                                     color:
// //                                                                         border,
// //                                                                   ),
// //                                                             ),
// //                                                         hintStyle: AppTextStyles
// //                                                             .bodyMedium
// //                                                             .copyWith(
// //                                                               color: bodyText,
// //                                                             ),
// //                                                       ),
// //                                             ),
// //                                             child: CustomTextField(
// //                                               controller: _mobileController,
// //                                               hint: _isEmailMode
// //                                                   ? 'Enter email address'
// //                                                   : 'Enter mobile number',
// //                                               keyboardType: _isEmailMode
// //                                                   ? TextInputType.emailAddress
// //                                                   : TextInputType.phone,
// //                                               textInputAction:
// //                                                   TextInputAction.next,
// //                                               inputFormatters: _isEmailMode
// //                                                   ? []
// //                                                   : [
// //                                                       FilteringTextInputFormatter
// //                                                           .digitsOnly,
// //                                                       LengthLimitingTextInputFormatter(
// //                                                         10,
// //                                                       ),
// //                                                     ],
// //                                               validator: (value) {
// //                                                 if (value == null ||
// //                                                     value.isEmpty) {
// //                                                   return _isEmailMode
// //                                                       ? 'Please enter your email'
// //                                                       : 'Please enter your mobile number';
// //                                                 }
// //                                                 if (_isEmailMode) {
// //                                                   // Email validation - must end with @gmail.com
// //                                                   if (!value.contains(
// //                                                     '@gmail.com',
// //                                                   )) {
// //                                                     return 'Email must be a valid @gmail.com address';
// //                                                   }
// //                                                   if (!RegExp(
// //                                                     r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
// //                                                   ).hasMatch(value)) {
// //                                                     return 'Please enter a valid Gmail address';
// //                                                   }
// //                                                 } else {
// //                                                   // Mobile validation - exactly 10 digits
// //                                                   if (value.length != 10) {
// //                                                     return 'Mobile number must be exactly 10 digits';
// //                                                   }
// //                                                 }
// //                                                 return null;
// //                                               },
// //                                               onFieldSubmitted: (_) =>
// //                                                   FocusScope.of(
// //                                                     context,
// //                                                   ).nextFocus(),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.lg),
// //                                 FadeSlideIn(
// //                                   progress: passwordLabelT,
// //                                   child: Align(
// //                                     alignment: Alignment.centerLeft,
// //                                     child: Text(
// //                                       'Password',
// //                                       style: AppTextStyles.labelLarge.copyWith(
// //                                         color: heading,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.sm),
// //                                 FadeSlideIn(
// //                                   progress: passwordFieldT,
// //                                   child: Theme(
// //                                     data: Theme.of(context).copyWith(
// //                                       inputDecorationTheme: Theme.of(context)
// //                                           .inputDecorationTheme
// //                                           .copyWith(
// //                                             fillColor: isDark
// //                                                 ? AppColors.surfaceDark
// //                                                 : Colors.white,
// //                                             enabledBorder: OutlineInputBorder(
// //                                               borderRadius: AppRadius.radiusSm,
// //                                               borderSide: BorderSide(
// //                                                 color: border,
// //                                               ),
// //                                             ),
// //                                             border: OutlineInputBorder(
// //                                               borderRadius: AppRadius.radiusSm,
// //                                               borderSide: BorderSide(
// //                                                 color: border,
// //                                               ),
// //                                             ),
// //                                             hintStyle: AppTextStyles.bodyMedium
// //                                                 .copyWith(color: bodyText),
// //                                           ),
// //                                     ),
// //                                     child: CustomTextField(
// //                                       controller: _passwordController,
// //                                       hint: 'Enter password (min 8 characters)',
// //                                       obscureText: _obscurePassword,
// //                                       keyboardType:
// //                                           TextInputType.visiblePassword,
// //                                       textInputAction: TextInputAction.done,
// //                                       inputFormatters: [],
// //                                       suffixIcon: IconButton(
// //                                         icon: Icon(
// //                                           _obscurePassword
// //                                               ? Icons.visibility_off
// //                                               : Icons.visibility,
// //                                           color: bodyText,
// //                                           size: 20,
// //                                         ),
// //                                         onPressed: () {
// //                                           setState(() {
// //                                             _obscurePassword =
// //                                                 !_obscurePassword;
// //                                           });
// //                                         },
// //                                       ),
// //                                       validator: (value) {
// //                                         if (value == null || value.isEmpty) {
// //                                           return 'Please enter your password';
// //                                         }
// //                                         if (value.length < 8) {
// //                                           return 'Password must be at least 8 characters';
// //                                         }
// //                                         return null;
// //                                       },
// //                                       onFieldSubmitted: (_) => _handleLogin(),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.xl),
// //                                 FadeSlideIn(
// //                                   progress: buttonT,
// //                                   child: AuthGradientButton(
// //                                     label: _isEmailMode
// //                                         ? 'Login with Email'
// //                                         : 'Login with OTP',
// //                                     icon: _isEmailMode
// //                                         ? Icons.email
// //                                         : AppIcons.phone,
// //                                     isLoading: isSendingOtp,
// //                                     onPressed: _isFormValid()
// //                                         ? _handleLogin
// //                                         : null,
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: AppSpacing.xl),
// //                                 FadeSlideIn(
// //                                   progress: footerT,
// //                                   child: Column(
// //                                     children: [
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: [
// //                                           Text(
// //                                             'New to Nivaas Hub? ',
// //                                             style: AppTextStyles.bodyMedium
// //                                                 .copyWith(color: bodyText),
// //                                           ),
// //                                           GestureDetector(
// //                                             onTap: () => Navigator.pushNamed(
// //                                               context,
// //                                               AppRoutes.register,
// //                                             ),
// //                                             child: Text(
// //                                               'Create an account',
// //                                               style: AppTextStyles.bodyMedium
// //                                                   .copyWith(
// //                                                     color: primaryBlue,
// //                                                     fontWeight: FontWeight.bold,
// //                                                   ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                       SizedBox(height: AppSpacing.sm),
// //                                       GestureDetector(
// //                                         onTap: () {
// //                                           setState(() {
// //                                             _isEmailMode = !_isEmailMode;
// //                                             _mobileController.clear();
// //                                           });
// //                                         },
// //                                         child: Text(
// //                                           _isEmailMode
// //                                               ? 'Use Mobile Number instead'
// //                                               : 'Use Email instead',
// //                                           style: AppTextStyles.bodySmall
// //                                               .copyWith(
// //                                                 color: primaryBlue,
// //                                                 decoration:
// //                                                     TextDecoration.underline,
// //                                               ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: screenHeight * 0.04),
// //                               ],
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCountryDropdown(Color border, bool isDark) {
// //     return Container(
// //       height: 45,
// //       decoration: BoxDecoration(
// //         border: Border.all(color: border),
// //         borderRadius: AppRadius.radiusSm,
// //         color: isDark ? AppColors.surfaceDark : Colors.white,
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //         child: DropdownButtonHideUnderline(
// //           child: DropdownButton<String>(
// //             value: _selectedCountryCode,
// //             icon: Icon(
// //               Icons.arrow_drop_down,
// //               color: isDark ? Colors.white : Colors.black87,
// //             ),
// //             iconSize: 24,
// //             elevation: 16,
// //             style: AppTextStyles.bodyMedium.copyWith(
// //               color: isDark ? Colors.white : Colors.black87,
// //             ),
// //             onChanged: (String? newValue) {
// //               setState(() {
// //                 _selectedCountryCode = newValue!;
// //               });
// //             },
// //             items: _countries.map<DropdownMenuItem<String>>((country) {
// //               return DropdownMenuItem<String>(
// //                 value: country['code'],
// //                 child: Row(
// //                   children: [
// //                     Text(country['name']!),
// //                     const SizedBox(width: 7),
// //                     Text(
// //                       country['code']!,
// //                       style: AppTextStyles.bodySmall.copyWith(
// //                         color: isDark ? Colors.white70 : Colors.black54,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// ////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';
// import 'package:flutter_nivasshub/constants/app_colors.dart';
// import 'package:flutter_nivasshub/constants/app_dimensions.dart';
// import 'package:flutter_nivasshub/constants/app_icons.dart';
// import 'package:flutter_nivasshub/constants/app_radius.dart';
// import 'package:flutter_nivasshub/constants/app_spacing.dart';
// import 'package:flutter_nivasshub/constants/app_text_styles.dart';
// import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
// import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
// import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
// import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
// import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
// import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
// import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
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
//   final _passwordController = TextEditingController();

//   String _selectedCountryCode = '+91'; // Default to India
//   bool _isEmailMode = false;
//   bool _obscurePassword = true;
//   bool _isLoadingCountries = false;

//   // Country list - populated from API
//   List<Map<String, String>> _countries = [
//     {'code': '+91', 'name': 'India 🇮🇳'},
//     {'code': '+1', 'name': 'USA 🇺🇸'},
//     {'code': '+44', 'name': 'UK 🇬🇧'},
//     {'code': '+61', 'name': 'Australia 🇦🇺'},
//     {'code': '+81', 'name': 'Japan 🇯🇵'},
//     {'code': '+49', 'name': 'Germany 🇩🇪'},
//     {'code': '+33', 'name': 'France 🇫🇷'},
//     {'code': '+39', 'name': 'Italy 🇮🇹'},
//     {'code': '+55', 'name': 'Brazil 🇧🇷'},
//     {'code': '+86', 'name': 'China 🇨🇳'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _entrance = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();

//     _mobileController.addListener(_onMobileTextChanged);

//     // Fetch countries from API after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchCountriesFromAPI();
//     });
//   }

//   /// Fetch countries from API: http://10.10.10.34:3000/country-codes
//   Future<void> _fetchCountriesFromAPI() async {
//     setState(() {
//       _isLoadingCountries = true;
//     });

//     try {
//       final dio = Dio();
//       final response = await dio.get('http://10.10.10.102:3000/country-codes');

//       if (response.statusCode == 200) {
//         final data = response.data as Map<String, dynamic>;

//         // Check if ActiveCountries exists in response
//         if (data['ActiveCountries'] != null) {
//           final List<dynamic> activeCountries = data['ActiveCountries'];

//           if (mounted) {
//             setState(() {
//               _countries = activeCountries.map((country) {
//                 return {
//                   'code': country['callingCode'].toString(),
//                   'name':
//                       '${country['countryName']} 🇮🇳', // You can add flag emojis based on shortCode
//                 };
//               }).toList();
//             });
//           }
//         }
//       }
//     } catch (e) {
//       // API failed - keep default list
//       if (mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           CustomSnackbar.info(
//             context,
//             'Using default country list. Please check connection.',
//           );
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingCountries = false;
//         });
//       }
//     }
//   }

//   void _onMobileTextChanged() {
//     final text = _mobileController.text;
//     // Check if input contains letters (alphabetical characters)
//     final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
//     if (hasLetters && !_isEmailMode) {
//       setState(() {
//         _isEmailMode = true;
//         // Keep the text when switching to email mode
//         _mobileController.text = text;
//       });
//     } else if (!hasLetters && _isEmailMode) {
//       // If no letters and currently in email mode, switch back to number mode
//       // But only if the text is empty or only numbers
//       final onlyNumbers = RegExp(r'^[0-9]*$').hasMatch(text);
//       if (onlyNumbers) {
//         setState(() {
//           _isEmailMode = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _entrance.dispose();
//     _mobileController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   bool _isFormValid() {
//     final mobileValid = _mobileController.text.isNotEmpty;
//     final passwordValid = _passwordController.text.length >= 8;
//     return mobileValid && passwordValid;
//   }

//   Future<void> _handleLogin() async {
//     // Check if form is valid - properly handle nullable
//     final form = _formKey.currentState;
//     if (form == null || !form.validate()) {
//       return;
//     }

//     context.hideKeyboard();

//     // Handle login based on mode
//     if (_isEmailMode) {
//       // Email login logic here
//       final email = _mobileController.text.trim();
//       final password = _passwordController.text.trim();
//       // TODO: Implement email/password login
//       // For now, show a snackbar
//       if (mounted) {
//         CustomSnackbar.info(context, 'Email login feature coming soon!');
//       }
//     } else {
//       // Phone OTP login logic
//       final mobile = _mobileController.text.trim();
//       final auth = context.read<AuthProvider>();
//       final success = await auth.sendOtp(mobile);
//       if (!mounted) return;

//       if (success) {
//         Navigator.pushNamed(
//           context,
//           AppRoutes.otpVerification,
//           arguments: OtpVerificationScreenArgs(
//             mobileNumber: auth.mobileNumber ?? mobile,
//             otpExpirySeconds: auth.otpExpirySeconds ?? 120,
//             isRegistrationFlow: false,
//           ),
//         );
//       } else {
//         CustomSnackbar.error(
//           context,
//           auth.errorMessage ?? 'Failed to send OTP. Please try again.',
//         );
//       }
//     }
//   }

//   /// Show country picker with bottom sheet (Scalable for 197 countries)
//   Future<void> _showCountryPicker() async {
//     final selected = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).brightness == Brightness.dark
//           ? AppColors.surfaceDark
//           : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.7,
//           maxChildSize: 0.9,
//           minChildSize: 0.5,
//           builder: (context, scrollController) {
//             return Column(
//               children: [
//                 // Handle bar
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(top: 12, bottom: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Select Country',
//                         style: AppTextStyles.titleMedium.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(height: 1),
//                 // Country List
//                 Expanded(
//                   child: _isLoadingCountries
//                       ? const Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           controller: scrollController,
//                           itemCount: _countries.length,
//                           itemBuilder: (context, index) {
//                             final country = _countries[index];
//                             final isSelected =
//                                 country['code'] == _selectedCountryCode;

//                             return ListTile(
//                               leading: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? AuthColors.primaryBlue.withValues(
//                                           alpha: 0.1,
//                                         )
//                                       : Colors.grey.withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   country['code']!,
//                                   style: AppTextStyles.bodyMedium.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: isSelected
//                                         ? AuthColors.primaryBlue
//                                         : null,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(country['name']!),
//                               trailing: isSelected
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: AuthColors.primaryBlue,
//                                     )
//                                   : null,
//                               onTap: () =>
//                                   Navigator.pop(context, country['code']),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );

//     if (selected != null) {
//       setState(() {
//         _selectedCountryCode = selected;
//       });
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
//                             final passwordLabelT = const Interval(
//                               0.44,
//                               0.74,
//                               curve: Curves.easeOut,
//                             ).transform(t);
//                             final passwordFieldT = const Interval(
//                               0.50,
//                               0.78,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final buttonT = const Interval(
//                               0.58,
//                               0.86,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final footerT = const Interval(
//                               0.68,
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
//                                     _isEmailMode
//                                         ? 'Login with Email'
//                                         : 'Login to access your Account',
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
//                                       _isEmailMode
//                                           ? 'Email Address'
//                                           : 'Mobile Number',
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
//                                         if (!_isEmailMode)
//                                           _buildCountryDropdown(border, isDark),
//                                         if (!_isEmailMode) AppSpacing.gapWSm,
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
//                                               hint: _isEmailMode
//                                                   ? 'Enter email address'
//                                                   : 'Enter mobile number',
//                                               keyboardType: _isEmailMode
//                                                   ? TextInputType.emailAddress
//                                                   : TextInputType.phone,
//                                               textInputAction:
//                                                   TextInputAction.next,
//                                               inputFormatters: _isEmailMode
//                                                   ? []
//                                                   : [
//                                                       FilteringTextInputFormatter
//                                                           .digitsOnly,
//                                                       LengthLimitingTextInputFormatter(
//                                                         10,
//                                                       ),
//                                                     ],
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return _isEmailMode
//                                                       ? 'Please enter your email'
//                                                       : 'Please enter your mobile number';
//                                                 }
//                                                 if (_isEmailMode) {
//                                                   // Email validation - must end with @gmail.com
//                                                   if (!value.contains(
//                                                     '@gmail.com',
//                                                   )) {
//                                                     return 'Email must be a valid @gmail.com address';
//                                                   }
//                                                   if (!RegExp(
//                                                     r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
//                                                   ).hasMatch(value)) {
//                                                     return 'Please enter a valid Gmail address';
//                                                   }
//                                                 } else {
//                                                   // Mobile validation - exactly 10 digits
//                                                   if (value.length != 10) {
//                                                     return 'Mobile number must be exactly 10 digits';
//                                                   }
//                                                 }
//                                                 return null;
//                                               },
//                                               onFieldSubmitted: (_) =>
//                                                   FocusScope.of(
//                                                     context,
//                                                   ).nextFocus(),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.lg),
//                                 FadeSlideIn(
//                                   progress: passwordLabelT,
//                                   child: Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       'Password',
//                                       style: AppTextStyles.labelLarge.copyWith(
//                                         color: heading,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.sm),
//                                 FadeSlideIn(
//                                   progress: passwordFieldT,
//                                   child: Theme(
//                                     data: Theme.of(context).copyWith(
//                                       inputDecorationTheme: Theme.of(context)
//                                           .inputDecorationTheme
//                                           .copyWith(
//                                             fillColor: isDark
//                                                 ? AppColors.surfaceDark
//                                                 : Colors.white,
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius: AppRadius.radiusSm,
//                                               borderSide: BorderSide(
//                                                 color: border,
//                                               ),
//                                             ),
//                                             border: OutlineInputBorder(
//                                               borderRadius: AppRadius.radiusSm,
//                                               borderSide: BorderSide(
//                                                 color: border,
//                                               ),
//                                             ),
//                                             hintStyle: AppTextStyles.bodyMedium
//                                                 .copyWith(color: bodyText),
//                                           ),
//                                     ),
//                                     child: CustomTextField(
//                                       controller: _passwordController,
//                                       hint: 'Enter password (min 8 characters)',
//                                       obscureText: _obscurePassword,
//                                       keyboardType:
//                                           TextInputType.visiblePassword,
//                                       textInputAction: TextInputAction.done,
//                                       inputFormatters: [],
//                                       suffixIcon: IconButton(
//                                         icon: Icon(
//                                           _obscurePassword
//                                               ? Icons.visibility_off
//                                               : Icons.visibility,
//                                           color: bodyText,
//                                           size: 20,
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             _obscurePassword =
//                                                 !_obscurePassword;
//                                           });
//                                         },
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter your password';
//                                         }
//                                         if (value.length < 8) {
//                                           return 'Password must be at least 8 characters';
//                                         }
//                                         return null;
//                                       },
//                                       onFieldSubmitted: (_) => _handleLogin(),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),
//                                 FadeSlideIn(
//                                   progress: buttonT,
//                                   child: AuthGradientButton(
//                                     label: _isEmailMode
//                                         ? 'Login with Email'
//                                         : 'Login with OTP',
//                                     icon: _isEmailMode
//                                         ? Icons.email
//                                         : AppIcons.phone,
//                                     isLoading: isSendingOtp,
//                                     onPressed: _isFormValid()
//                                         ? _handleLogin
//                                         : null,
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),
//                                 FadeSlideIn(
//                                   progress: footerT,
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             'New to Nivaas Hub? ',
//                                             style: AppTextStyles.bodyMedium
//                                                 .copyWith(color: bodyText),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () => Navigator.pushNamed(
//                                               context,
//                                               AppRoutes.register,
//                                             ),
//                                             child: Text(
//                                               'Create an account',
//                                               style: AppTextStyles.bodyMedium
//                                                   .copyWith(
//                                                     color: primaryBlue,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: AppSpacing.sm),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             _isEmailMode = !_isEmailMode;
//                                             _mobileController.clear();
//                                           });
//                                         },
//                                         child: Text(
//                                           _isEmailMode
//                                               ? 'Use Mobile Number instead'
//                                               : 'Use Email instead',
//                                           style: AppTextStyles.bodySmall
//                                               .copyWith(
//                                                 color: primaryBlue,
//                                                 decoration:
//                                                     TextDecoration.underline,
//                                               ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.04),
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

//   Widget _buildCountryDropdown(Color border, bool isDark) {
//     return InkWell(
//       onTap: _showCountryPicker,
//       borderRadius: AppRadius.radiusSm,
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: border),
//           borderRadius: AppRadius.radiusSm,
//           color: isDark ? AppColors.surfaceDark : Colors.white,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               _selectedCountryCode,
//               style: AppTextStyles.bodyMedium.copyWith(
//                 color: isDark ? Colors.white : Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               Icons.arrow_drop_down,
//               color: isDark ? Colors.white : Colors.black87,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';
// import 'package:flutter_nivasshub/constants/app_colors.dart';
// import 'package:flutter_nivasshub/constants/app_dimensions.dart';
// import 'package:flutter_nivasshub/constants/app_icons.dart';
// import 'package:flutter_nivasshub/constants/app_radius.dart';
// import 'package:flutter_nivasshub/constants/app_spacing.dart';
// import 'package:flutter_nivasshub/constants/app_text_styles.dart';
// import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
// import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
// import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
// import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
// import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
// import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
// import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
// import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
// import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';

// /// Login Screen with Email and Phone login support
// /// - Fetches countries from API on load
// /// - Supports email login (cont_code: null)
// /// - Supports phone login (cont_code: +91)
// /// - Stores token in SharedPreferences
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   // Animation controller for entrance animation
//   late final AnimationController _entrance;

//   // Form key for validation
//   final _formKey = GlobalKey<FormState>();

//   // Text controllers
//   final _emailOrPhoneController = TextEditingController();
//   final _passwordController = TextEditingController();

//   // State variables
//   String _selectedCountryCode = '+91';
//   bool _isEmailMode = false;
//   bool _obscurePassword = true;
//   bool _isLoadingCountries = false;
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Token storage key
//   static const String _tokenKey = 'auth_token';

//   // Country list - populated from API
//   List<Map<String, String>> _countries = [
//     {'code': '+91', 'name': 'India 🇮🇳'},
//     {'code': '+1', 'name': 'USA 🇺🇸'},
//     {'code': '+44', 'name': 'UK 🇬🇧'},
//     {'code': '+61', 'name': 'Australia 🇦🇺'},
//     {'code': '+81', 'name': 'Japan 🇯🇵'},
//     {'code': '+49', 'name': 'Germany 🇩🇪'},
//     {'code': '+33', 'name': 'France 🇫🇷'},
//     {'code': '+39', 'name': 'Italy 🇮🇹'},
//     {'code': '+55', 'name': 'Brazil 🇧🇷'},
//     {'code': '+86', 'name': 'China 🇨🇳'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _entrance = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();

//     // Add listener for auto mode switching
//     _emailOrPhoneController.addListener(_onTextChanged);

//     // Fetch countries from API after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchCountriesFromAPI();
//     });
//   }

//   /// Fetch countries from API
//   Future<void> _fetchCountriesFromAPI() async {
//     setState(() {
//       _isLoadingCountries = true;
//     });

//     try {
//       final dio = Dio();
//       final response = await dio.get(
//         'http://10.10.10.102:3000/country-codes',
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         final data = response.data as Map<String, dynamic>;

//         if (data['ActiveCountries'] != null) {
//           final List<dynamic> activeCountries = data['ActiveCountries'];

//           if (mounted) {
//             setState(() {
//               _countries = activeCountries.map((country) {
//                 final callingCode = country['callingCode'].toString();
//                 final countryName = country['countryName'] ?? '';
//                 final shortCode = country['shortCode'] ?? '';
//                 // Get flag emoji from short code
//                 final flagEmoji = _getFlagEmoji(shortCode);
//                 return {'code': callingCode, 'name': '$countryName $flagEmoji'};
//               }).toList();
//             });
//           }
//         }
//       }
//     } catch (e) {
//       // API failed - keep default list
//       if (mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           CustomSnackbar.info(
//             context,
//             'Using default country list. Please check connection.',
//           );
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingCountries = false;
//         });
//       }
//     }
//   }

//   /// Convert country code to flag emoji
//   String _getFlagEmoji(String shortCode) {
//     if (shortCode.isEmpty) return '🌍';
//     final upper = shortCode.toUpperCase();
//     if (upper.length != 2) return '🌍';
//     const offset = 0x1F1E6 - 65;
//     final first = upper.codeUnitAt(0) + offset;
//     final second = upper.codeUnitAt(1) + offset;
//     return String.fromCharCodes([first, second]);
//   }

//   /// Auto switch between email and phone mode based on input
//   void _onTextChanged() {
//     final text = _emailOrPhoneController.text;
//     final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);

//     if (hasLetters && !_isEmailMode) {
//       setState(() {
//         _isEmailMode = true;
//       });
//     } else if (!hasLetters && _isEmailMode && text.isNotEmpty) {
//       // Check if it's only numbers
//       final onlyNumbers = RegExp(r'^[0-9]*$').hasMatch(text);
//       if (onlyNumbers) {
//         setState(() {
//           _isEmailMode = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _entrance.dispose();
//     _emailOrPhoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   /// Check if form is valid
//   bool _isFormValid() {
//     final emailOrPhone = _emailOrPhoneController.text.trim();
//     final password = _passwordController.text.trim();

//     if (emailOrPhone.isEmpty || password.isEmpty) {
//       return false;
//     }

//     if (_isEmailMode) {
//       // Email validation: must be valid email format
//       final emailRegex = RegExp(
//         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//       );
//       if (!emailRegex.hasMatch(emailOrPhone)) {
//         return false;
//       }
//     } else {
//       // Phone validation: exactly 10 digits
//       if (emailOrPhone.length != 10 ||
//           !RegExp(r'^[0-9]+$').hasMatch(emailOrPhone)) {
//         return false;
//       }
//     }

//     // Password validation: minimum 8 characters
//     if (password.length < 8) {
//       return false;
//     }

//     return true;
//   }

//   /// Save token to SharedPreferences
//   Future<void> _saveToken(String token) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_tokenKey, token);
//       debugPrint('[Auth] Token saved successfully');
//     } catch (e) {
//       debugPrint('[Auth] Error saving token: $e');
//     }
//   }

//   /// Handle login
//   Future<void> _handleLogin() async {
//     // Validate form
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     // Hide keyboard
//     context.hideKeyboard();

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final emailOrPhone = _emailOrPhoneController.text.trim();
//       final password = _passwordController.text.trim();

//       // Prepare request body based on mode
//       Map<String, dynamic> requestBody;
//       if (_isEmailMode) {
//         // Email login
//         requestBody = {
//           'umail': emailOrPhone,
//           'pwd': password,
//           'cont_code': null,
//         };
//       } else {
//         // Phone login
//         requestBody = {
//           'umail': emailOrPhone,
//           'pwd': password,
//           'cont_code': _selectedCountryCode,
//         };
//       }

//       debugPrint('[Auth] Login request: $requestBody');

//       final dio = Dio();
//       final response = await dio.post(
//         'http://10.10.10.102:3000/auth/login',
//         data: requestBody,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       if (!mounted) return;

//       final data = response.data as Map<String, dynamic>;
//       final errorCode = data['ErrorCode'] as int?;
//       final errorMsg = data['ErrorMsg'] as String?;
//       final refreshToken = data['RefreshToken'] as String?;

//       // Handle response based on status code
//       switch (errorCode) {
//         case 200:
//           // Login successful
//           if (refreshToken != null && refreshToken.isNotEmpty) {
//             // Save token to SharedPreferences
//             await _saveToken(refreshToken);

//             // Show success message
//             CustomSnackbar.success(context, errorMsg ?? 'Login successful!');

//             // Navigate to home or dashboard
//             // Navigator.pushReplacementNamed(context, AppRoutes.home);
//           } else {
//             setState(() {
//               _errorMessage = 'No token received. Please try again.';
//             });
//           }
//           break;

//         case 400:
//           setState(() {
//             _errorMessage =
//                 errorMsg ?? 'Validation error. Please check your input.';
//           });
//           break;

//         case 401:
//           setState(() {
//             _errorMessage = errorMsg ?? 'Invalid email/phone or password.';
//           });
//           break;

//         case 403:
//           setState(() {
//             _errorMessage =
//                 errorMsg ??
//                 'Account is inactive or locked. Please contact support.';
//           });
//           break;

//         case 500:
//           setState(() {
//             _errorMessage = errorMsg ?? 'Server error. Please try again later.';
//           });
//           break;

//         default:
//           setState(() {
//             _errorMessage = errorMsg ?? 'Login failed. Please try again.';
//           });
//       }
//     } on DioException catch (e) {
//       // Handle network errors
//       if (!mounted) return;

//       String errorMessage = 'Network error. Please check your connection.';

//       if (e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.sendTimeout ||
//           e.type == DioExceptionType.receiveTimeout) {
//         errorMessage = 'Connection timeout. Please try again.';
//       } else if (e.type == DioExceptionType.connectionError) {
//         errorMessage = 'No internet connection. Please check your network.';
//       } else if (e.response != null) {
//         try {
//           final data = e.response?.data as Map<String, dynamic>?;
//           if (data != null && data['ErrorMsg'] != null) {
//             errorMessage = data['ErrorMsg'] as String;
//           }
//         } catch (_) {
//           errorMessage = 'Server error. Please try again.';
//         }
//       }

//       setState(() {
//         _errorMessage = errorMessage;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _errorMessage = 'An unexpected error occurred: ${e.toString()}';
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   /// Show country picker with bottom sheet
//   Future<void> _showCountryPicker() async {
//     final selected = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).brightness == Brightness.dark
//           ? AppColors.surfaceDark
//           : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.7,
//           maxChildSize: 0.9,
//           minChildSize: 0.5,
//           builder: (context, scrollController) {
//             return Column(
//               children: [
//                 // Handle bar
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(top: 12, bottom: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Select Country',
//                         style: AppTextStyles.titleMedium.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(height: 1),
//                 // Country List
//                 Expanded(
//                   child: _isLoadingCountries
//                       ? const Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           controller: scrollController,
//                           itemCount: _countries.length,
//                           itemBuilder: (context, index) {
//                             final country = _countries[index];
//                             final isSelected =
//                                 country['code'] == _selectedCountryCode;

//                             return ListTile(
//                               leading: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? AuthColors.primaryBlue.withValues(
//                                           alpha: 0.1,
//                                         )
//                                       : Colors.grey.withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   country['code']!,
//                                   style: AppTextStyles.bodyMedium.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: isSelected
//                                         ? AuthColors.primaryBlue
//                                         : null,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(country['name']!),
//                               trailing: isSelected
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: AuthColors.primaryBlue,
//                                     )
//                                   : null,
//                               onTap: () =>
//                                   Navigator.pop(context, country['code']),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );

//     if (selected != null) {
//       setState(() {
//         _selectedCountryCode = selected;
//       });
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

//     final bool isValid = _isFormValid();

//     return PopScope(
//       canPop: !isSendingOtp,
//       child: Scaffold(
//         backgroundColor: background,
//         body: Stack(
//           children: [
//             // Background gradient
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
//             // Skyline animation
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
//             // Main content
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
//                             final passwordLabelT = const Interval(
//                               0.44,
//                               0.74,
//                               curve: Curves.easeOut,
//                             ).transform(t);
//                             final passwordFieldT = const Interval(
//                               0.50,
//                               0.78,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final buttonT = const Interval(
//                               0.58,
//                               0.86,
//                               curve: Curves.easeOutCubic,
//                             ).transform(t);
//                             final footerT = const Interval(
//                               0.68,
//                               1.00,
//                               curve: Curves.easeOut,
//                             ).transform(t);

//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Logo
//                                 Opacity(
//                                   opacity: logoT.clamp(0.0, 1.0),
//                                   child: Transform.scale(
//                                     scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
//                                     child: const NivassLogoMark(size: 72),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.lg),

//                                 // Welcome text
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

//                                 // Subtitle
//                                 FadeSlideIn(
//                                   progress: subheadingT,
//                                   child: Text(
//                                     _isEmailMode
//                                         ? 'Login with Email'
//                                         : 'Login to access your Account',
//                                     textAlign: TextAlign.center,
//                                     style: AppTextStyles.bodyLarge.copyWith(
//                                       color: bodyText,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),

//                                 // Form
//                                 Form(
//                                   key: _formKey,
//                                   autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // Label
//                                       FadeSlideIn(
//                                         progress: labelT,
//                                         child: Text(
//                                           _isEmailMode
//                                               ? 'Email Address'
//                                               : 'Mobile Number',
//                                           style: AppTextStyles.labelLarge
//                                               .copyWith(color: heading),
//                                         ),
//                                       ),
//                                       SizedBox(height: AppSpacing.sm),

//                                       // Email/Phone input with country dropdown
//                                       FadeSlideIn(
//                                         progress: fieldRowT,
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             // Country dropdown (only for phone mode)
//                                             if (!_isEmailMode)
//                                               _buildCountryDropdown(
//                                                 border,
//                                                 isDark,
//                                               ),
//                                             if (!_isEmailMode)
//                                               AppSpacing.gapWSm,
//                                             Expanded(
//                                               child: Theme(
//                                                 data: Theme.of(context).copyWith(
//                                                   inputDecorationTheme:
//                                                       Theme.of(
//                                                         context,
//                                                       ).inputDecorationTheme.copyWith(
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
//                                                 ),
//                                                 child: CustomTextField(
//                                                   controller:
//                                                       _emailOrPhoneController,
//                                                   hint: _isEmailMode
//                                                       ? 'Enter email address'
//                                                       : 'Enter mobile number',
//                                                   keyboardType: _isEmailMode
//                                                       ? TextInputType
//                                                             .emailAddress
//                                                       : TextInputType.phone,
//                                                   textInputAction:
//                                                       TextInputAction.next,
//                                                   inputFormatters: _isEmailMode
//                                                       ? []
//                                                       : [
//                                                           FilteringTextInputFormatter
//                                                               .digitsOnly,
//                                                           LengthLimitingTextInputFormatter(
//                                                             10,
//                                                           ),
//                                                         ],
//                                                   validator: (value) {
//                                                     if (value == null ||
//                                                         value.isEmpty) {
//                                                       return _isEmailMode
//                                                           ? 'Please enter your email'
//                                                           : 'Please enter your mobile number';
//                                                     }
//                                                     if (_isEmailMode) {
//                                                       // Email validation
//                                                       final emailRegex = RegExp(
//                                                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                                                       );
//                                                       if (!emailRegex.hasMatch(
//                                                         value,
//                                                       )) {
//                                                         return 'Please enter a valid email address';
//                                                       }
//                                                     } else {
//                                                       // Mobile validation - exactly 10 digits
//                                                       if (value.length != 10) {
//                                                         return 'Mobile number must be exactly 10 digits';
//                                                       }
//                                                     }
//                                                     return null;
//                                                   },
//                                                   onFieldSubmitted: (_) =>
//                                                       FocusScope.of(
//                                                         context,
//                                                       ).nextFocus(),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: AppSpacing.lg),

//                                       // Password label
//                                       FadeSlideIn(
//                                         progress: passwordLabelT,
//                                         child: Text(
//                                           'Password',
//                                           style: AppTextStyles.labelLarge
//                                               .copyWith(color: heading),
//                                         ),
//                                       ),
//                                       SizedBox(height: AppSpacing.sm),

//                                       // Password input
//                                       FadeSlideIn(
//                                         progress: passwordFieldT,
//                                         child: Theme(
//                                           data: Theme.of(context).copyWith(
//                                             inputDecorationTheme:
//                                                 Theme.of(
//                                                   context,
//                                                 ).inputDecorationTheme.copyWith(
//                                                   fillColor: isDark
//                                                       ? AppColors.surfaceDark
//                                                       : Colors.white,
//                                                   enabledBorder:
//                                                       OutlineInputBorder(
//                                                         borderRadius:
//                                                             AppRadius.radiusSm,
//                                                         borderSide: BorderSide(
//                                                           color: border,
//                                                         ),
//                                                       ),
//                                                   border: OutlineInputBorder(
//                                                     borderRadius:
//                                                         AppRadius.radiusSm,
//                                                     borderSide: BorderSide(
//                                                       color: border,
//                                                     ),
//                                                   ),
//                                                   hintStyle: AppTextStyles
//                                                       .bodyMedium
//                                                       .copyWith(
//                                                         color: bodyText,
//                                                       ),
//                                                 ),
//                                           ),
//                                           child: CustomTextField(
//                                             controller: _passwordController,
//                                             hint:
//                                                 'Enter password (min 8 characters)',
//                                             obscureText: _obscurePassword,
//                                             keyboardType:
//                                                 TextInputType.visiblePassword,
//                                             textInputAction:
//                                                 TextInputAction.done,
//                                             inputFormatters: [],
//                                             suffixIcon: IconButton(
//                                               icon: Icon(
//                                                 _obscurePassword
//                                                     ? Icons.visibility_off
//                                                     : Icons.visibility,
//                                                 color: bodyText,
//                                                 size: 20,
//                                               ),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   _obscurePassword =
//                                                       !_obscurePassword;
//                                                 });
//                                               },
//                                             ),
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'Please enter your password';
//                                               }
//                                               if (value.length < 8) {
//                                                 return 'Password must be at least 8 characters';
//                                               }
//                                               return null;
//                                             },
//                                             onFieldSubmitted: (_) =>
//                                                 _handleLogin(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),

//                                 // Error message
//                                 if (_errorMessage != null)
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 12),
//                                     child: Text(
//                                       _errorMessage!,
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontSize: 14,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),

//                                 // Login button
//                                 FadeSlideIn(
//                                   progress: buttonT,
//                                   child: AuthGradientButton(
//                                     label: _isEmailMode
//                                         ? 'Login with Email'
//                                         : 'Login with OTP',
//                                     icon: _isEmailMode
//                                         ? Icons.email
//                                         : AppIcons.phone,
//                                     isLoading: _isLoading || isSendingOtp,
//                                     onPressed:
//                                         isValid && !_isLoading && !isSendingOtp
//                                         ? _handleLogin
//                                         : null,
//                                   ),
//                                 ),
//                                 SizedBox(height: AppSpacing.xl),

//                                 // Footer
//                                 FadeSlideIn(
//                                   progress: footerT,
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             'New to Nivaas Hub? ',
//                                             style: AppTextStyles.bodyMedium
//                                                 .copyWith(color: bodyText),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () => Navigator.pushNamed(
//                                               context,
//                                               AppRoutes.register,
//                                             ),
//                                             child: Text(
//                                               'Create an account',
//                                               style: AppTextStyles.bodyMedium
//                                                   .copyWith(
//                                                     color: primaryBlue,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: AppSpacing.sm),
//                                       // Toggle between email and phone
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             _isEmailMode = !_isEmailMode;
//                                             _emailOrPhoneController.clear();
//                                             _passwordController.clear();
//                                             _errorMessage = null;
//                                           });
//                                         },
//                                         child: Text(
//                                           _isEmailMode
//                                               ? 'Use Mobile Number instead'
//                                               : 'Use Email instead',
//                                           style: AppTextStyles.bodySmall
//                                               .copyWith(
//                                                 color: primaryBlue,
//                                                 decoration:
//                                                     TextDecoration.underline,
//                                               ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.04),
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

//   /// Build country dropdown widget
//   Widget _buildCountryDropdown(Color border, bool isDark) {
//     return InkWell(
//       onTap: _showCountryPicker,
//       borderRadius: AppRadius.radiusSm,
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: border),
//           borderRadius: AppRadius.radiusSm,
//           color: isDark ? AppColors.surfaceDark : Colors.white,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               _selectedCountryCode,
//               style: AppTextStyles.bodyMedium.copyWith(
//                 color: isDark ? Colors.white : Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               Icons.arrow_drop_down,
//               color: isDark ? Colors.white : Colors.black87,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//////////////////////////////////////////////////////

// login_screen.dart - Full updated code
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

/// Login Screen with Email and Phone login support
/// - Fetches countries from API on load
/// - Supports email login (cont_code: null)
/// - Supports phone login (cont_code: +91)
/// - Stores token in SharedPreferences
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for entrance animation
  late final AnimationController _entrance;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  String _selectedCountryCode = '+91';
  bool _isEmailMode = false;
  bool _obscurePassword = true;
  bool _isLoadingCountries = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Token storage key
  static const String _tokenKey = 'auth_token';

  // Country list - populated from API
  List<Map<String, String>> _countries = [
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

    // Add listener for auto mode switching
    _emailOrPhoneController.addListener(_onTextChanged);

    // Fetch countries from API after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCountriesFromAPI();
    });
  }

  /// Fetch countries from API
  Future<void> _fetchCountriesFromAPI() async {
    setState(() {
      _isLoadingCountries = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://10.10.10.102:3000/country-codes',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['ActiveCountries'] != null) {
          final List<dynamic> activeCountries = data['ActiveCountries'];

          if (mounted) {
            setState(() {
              _countries = activeCountries.map((country) {
                final callingCode = country['callingCode'].toString();
                final countryName = country['countryName'] ?? '';
                final shortCode = country['shortCode'] ?? '';
                // Get flag emoji from short code
                final flagEmoji = _getFlagEmoji(shortCode);
                return {'code': callingCode, 'name': '$countryName $flagEmoji'};
              }).toList();
            });
          }
        }
      }
    } catch (e) {
      // API failed - keep default list
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackbar.info(
            context,
            'Using default country list. Please check connection.',
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCountries = false;
        });
      }
    }
  }

  /// Convert country code to flag emoji
  String _getFlagEmoji(String shortCode) {
    if (shortCode.isEmpty) return '🌍';
    final upper = shortCode.toUpperCase();
    if (upper.length != 2) return '🌍';
    const offset = 0x1F1E6 - 65;
    final first = upper.codeUnitAt(0) + offset;
    final second = upper.codeUnitAt(1) + offset;
    return String.fromCharCodes([first, second]);
  }

  /// Auto switch between email and phone mode based on input
  void _onTextChanged() {
    final text = _emailOrPhoneController.text;
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);

    if (hasLetters && !_isEmailMode) {
      setState(() {
        _isEmailMode = true;
      });
    } else if (!hasLetters && _isEmailMode && text.isNotEmpty) {
      // Check if it's only numbers
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
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Check if form is valid
  bool _isFormValid() {
    final emailOrPhone = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    if (emailOrPhone.isEmpty || password.isEmpty) {
      return false;
    }

    if (_isEmailMode) {
      // Email validation: must be valid email format
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(emailOrPhone)) {
        return false;
      }
    } else {
      // Phone validation: exactly 10 digits
      if (emailOrPhone.length != 10 ||
          !RegExp(r'^[0-9]+$').hasMatch(emailOrPhone)) {
        return false;
      }
    }

    // Password validation: minimum 8 characters
    if (password.length < 8) {
      return false;
    }

    return true;
  }

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      debugPrint('[Auth] Token saved successfully');
    } catch (e) {
      debugPrint('[Auth] Error saving token: $e');
    }
  }

  /// Handle login
  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Hide keyboard
    context.hideKeyboard();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final emailOrPhone = _emailOrPhoneController.text.trim();
      final password = _passwordController.text.trim();

      // Prepare request body based on mode
      Map<String, dynamic> requestBody;
      if (_isEmailMode) {
        // Email login
        requestBody = {
          'umail': emailOrPhone,
          'pwd': password,
          'cont_code': null,
        };
      } else {
        // Phone login
        requestBody = {
          'umail': emailOrPhone,
          'pwd': password,
          'cont_code': _selectedCountryCode,
        };
      }

      debugPrint('[Auth] Login request: $requestBody');

      final dio = Dio();
      final response = await dio.post(
        'http://10.10.10.102:3000/auth/login',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      final data = response.data as Map<String, dynamic>;
      final errorCode = data['ErrorCode'] as int?;
      final errorMsg = data['ErrorMsg'] as String?;
      final refreshToken = data['RefreshToken'] as String?;

      // Handle response based on status code
      switch (errorCode) {
        case 200:
          // Login successful
          if (refreshToken != null && refreshToken.isNotEmpty) {
            // Save token to SharedPreferences
            await _saveToken(refreshToken);

            // Show success message
            CustomSnackbar.success(context, errorMsg ?? 'Login successful!');

            // ✅ FIXED: Navigate to dashboard after successful login
            if (mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            }
          } else {
            setState(() {
              _errorMessage = 'No token received. Please try again.';
            });
          }
          break;

        case 400:
          setState(() {
            _errorMessage =
                errorMsg ?? 'Validation error. Please check your input.';
          });
          break;

        case 401:
          setState(() {
            _errorMessage = errorMsg ?? 'Invalid email/phone or password.';
          });
          break;

        case 403:
          setState(() {
            _errorMessage =
                errorMsg ??
                'Account is inactive or locked. Please contact support.';
          });
          break;

        case 500:
          setState(() {
            _errorMessage = errorMsg ?? 'Server error. Please try again later.';
          });
          break;

        default:
          setState(() {
            _errorMessage = errorMsg ?? 'Login failed. Please try again.';
          });
      }
    } on DioException catch (e) {
      // Handle network errors
      if (!mounted) return;

      String errorMessage = 'Network error. Please check your connection.';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.response != null) {
        try {
          final data = e.response?.data as Map<String, dynamic>?;
          if (data != null && data['ErrorMsg'] != null) {
            errorMessage = data['ErrorMsg'] as String;
          }
        } catch (_) {
          errorMessage = 'Server error. Please try again.';
        }
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Show country picker with bottom sheet
  Future<void> _showCountryPicker() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Select Country',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Country List
                Expanded(
                  child: _isLoadingCountries
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: _countries.length,
                          itemBuilder: (context, index) {
                            final country = _countries[index];
                            final isSelected =
                                country['code'] == _selectedCountryCode;

                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AuthColors.primaryBlue.withValues(
                                          alpha: 0.1,
                                        )
                                      : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  country['code']!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AuthColors.primaryBlue
                                        : null,
                                  ),
                                ),
                              ),
                              title: Text(country['name']!),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: AuthColors.primaryBlue,
                                    )
                                  : null,
                              onTap: () =>
                                  Navigator.pop(context, country['code']),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCountryCode = selected;
      });
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

    final bool isValid = _isFormValid();

    return PopScope(
      canPop: !isSendingOtp,
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            // Background gradient
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
            // Skyline animation
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
            // Main content
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
                                // Logo
                                Opacity(
                                  opacity: logoT.clamp(0.0, 1.0),
                                  child: Transform.scale(
                                    scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
                                    child: const NivassLogoMark(size: 72),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.lg),

                                // Welcome text
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

                                // Subtitle
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

                                // Form
                                Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Label
                                      FadeSlideIn(
                                        progress: labelT,
                                        child: Text(
                                          _isEmailMode
                                              ? 'Email Address'
                                              : 'Mobile Number',
                                          style: AppTextStyles.labelLarge
                                              .copyWith(color: heading),
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.sm),

                                      // Email/Phone input with country dropdown
                                      FadeSlideIn(
                                        progress: fieldRowT,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Country dropdown (only for phone mode)
                                            if (!_isEmailMode)
                                              _buildCountryDropdown(
                                                border,
                                                isDark,
                                              ),
                                            if (!_isEmailMode)
                                              AppSpacing.gapWSm,
                                            Expanded(
                                              child: Theme(
                                                data: Theme.of(context).copyWith(
                                                  inputDecorationTheme:
                                                      Theme.of(
                                                        context,
                                                      ).inputDecorationTheme.copyWith(
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
                                                  controller:
                                                      _emailOrPhoneController,
                                                  hint: _isEmailMode
                                                      ? 'Enter email address'
                                                      : 'Enter mobile number',
                                                  keyboardType: _isEmailMode
                                                      ? TextInputType
                                                            .emailAddress
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
                                                      // Email validation
                                                      final emailRegex = RegExp(
                                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                                      );
                                                      if (!emailRegex.hasMatch(
                                                        value,
                                                      )) {
                                                        return 'Please enter a valid email address';
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
                                      SizedBox(height: AppSpacing.lg),

                                      // Password label
                                      FadeSlideIn(
                                        progress: passwordLabelT,
                                        child: Text(
                                          'Password',
                                          style: AppTextStyles.labelLarge
                                              .copyWith(color: heading),
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.sm),

                                      // Password input
                                      FadeSlideIn(
                                        progress: passwordFieldT,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            inputDecorationTheme:
                                                Theme.of(
                                                  context,
                                                ).inputDecorationTheme.copyWith(
                                                  fillColor: isDark
                                                      ? AppColors.surfaceDark
                                                      : Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            AppRadius.radiusSm,
                                                        borderSide: BorderSide(
                                                          color: border,
                                                        ),
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        AppRadius.radiusSm,
                                                    borderSide: BorderSide(
                                                      color: border,
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
                                            controller: _passwordController,
                                            hint:
                                                'Enter password (min 8 characters)',
                                            obscureText: _obscurePassword,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
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
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              if (value.length < 8) {
                                                return 'Password must be at least 8 characters';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (_) =>
                                                _handleLogin(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),

                                // Error message
                                if (_errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                // Login button
                                FadeSlideIn(
                                  progress: buttonT,
                                  child: AuthGradientButton(
                                    label: _isEmailMode
                                        ? 'Login with Email'
                                        : 'Login with OTP',
                                    icon: _isEmailMode
                                        ? Icons.email
                                        : AppIcons.phone,
                                    isLoading: _isLoading || isSendingOtp,
                                    onPressed:
                                        isValid && !_isLoading && !isSendingOtp
                                        ? _handleLogin
                                        : null,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xl),

                                // Footer
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
                                      // Toggle between email and phone
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isEmailMode = !_isEmailMode;
                                            _emailOrPhoneController.clear();
                                            _passwordController.clear();
                                            _errorMessage = null;
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

  /// Build country dropdown widget
  Widget _buildCountryDropdown(Color border, bool isDark) {
    return InkWell(
      onTap: _showCountryPicker,
      borderRadius: AppRadius.radiusSm,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: AppRadius.radiusSm,
          color: isDark ? AppColors.surfaceDark : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCountryCode,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: isDark ? Colors.white : Colors.black87,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
