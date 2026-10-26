import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/country_code_selector.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Screen 2 — collects the registered mobile number and requests an OTP.
/// No arguments; on success navigates to the shared OTP-verify screen with
/// `channel: mobile`.
class ForgotPasswordMobileScreen extends StatefulWidget {
  const ForgotPasswordMobileScreen({super.key});

  @override
  State<ForgotPasswordMobileScreen> createState() =>
      _ForgotPasswordMobileScreenState();
}

class _ForgotPasswordMobileScreenState
    extends State<ForgotPasswordMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  List<LocationNode> _dialCodes = const [];
  LocationNode? _selectedCountry;
  bool _isLoadingDialCodes = false;

  @override
  void initState() {
    super.initState();
    _loadDialCodes();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadDialCodes() async {
    setState(() => _isLoadingDialCodes = true);
    final response = await context.read<CountryServiceBase>().getCountries();
    if (!mounted) return;
    if (response.isSuccess && response.data != null) {
      final countries = response.data!
          .where((c) => (c.dialCode ?? '').isNotEmpty)
          .toList(growable: false);
      setState(() {
        _dialCodes = countries;
        _selectedCountry ??= _defaultCountry(countries);
        _isLoadingDialCodes = false;
      });
    } else {
      setState(() => _isLoadingDialCodes = false);
    }
  }

  static LocationNode? _defaultCountry(List<LocationNode> countries) {
    for (final country in countries) {
      if (country.dialCode == '+91') return country;
    }
    return countries.isEmpty ? null : countries.first;
  }

  Future<void> _handleSendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final countryCode = _selectedCountry?.dialCode;
    if (countryCode == null) {
      CustomSnackbar.error(context, 'Please select a country code.');
      return;
    }

    context.hideKeyboard();
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final mobileNumber = _mobileController.text.trim();
    final success = await forgotPassword.sendOtp(
      identifier: mobileNumber,
      channel: ForgotPasswordChannel.mobile,
      countryCode: countryCode,
    );
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.forgotPasswordVerifyOtp,
        arguments: ForgotPasswordVerifyOtpScreenArgs(
          identifier: mobileNumber,
          channel: ForgotPasswordChannel.mobile,
        ),
      );
    } else {
      CustomSnackbar.error(
        context,
        forgotPassword.errorMessage ?? 'Failed to send OTP. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final isSendingOtp = context.watch<ForgotPasswordProvider>().isSendingOtp;

    return PopScope(
      canPop: !isSendingOtp,
      child: FigmaHeaderScaffold(
        title: 'Forgot Password',
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
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    context.gapSm,
                    const Text(
                      "Enter your registered mobile number and we'll send you an "
                      'OTP to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: context.rs(28)),
                    FigmaCard(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryCodeSelector(
                              countries: _dialCodes,
                              selected: _selectedCountry,
                              isLoading: _isLoadingDialCodes,
                              onSelected: (country) =>
                                  setState(() => _selectedCountry = country),
                            ),
                            SizedBox(width: context.rs(8)),
                            Expanded(
                              child: CustomTextField(
                                controller: _mobileController,
                                hint: 'Enter Mobile Number',
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: FormValidators.mobileNumber,
                                onFieldSubmitted: (_) => _handleSendOtp(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.rs(20)),
                    FigmaButton(
                      label: 'Send OTP',
                      showArrow: true,
                      isLoading: isSendingOtp,
                      onPressed: isSendingOtp ? null : _handleSendOtp,
                    ),
                    SizedBox(height: context.rs(12)),
                    TextButton(
                      onPressed: isSendingOtp ? null : () => Navigator.pop(context),
                      child: const Text(
                        'Back to Options',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
