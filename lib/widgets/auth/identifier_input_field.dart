import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/widgets/auth/country_code_selector.dart';

/// The mobile-or-email field on the authentication entry screen.
///
/// Composes a [CountryCodeSelector] (mobile only) with a
/// styled [TextFormField] matching Figma Dev Mode specifications:
/// 52px height, 12px border radius, 1px #E5E7EB border, #F9FAFB background,
/// and 16px DM Sans typography in #0E2543 (BLUE NH).
class IdentifierInputField extends StatelessWidget {
  const IdentifierInputField({
    super.key,
    required this.controller,
    required this.channel,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.isLoadingCountries = false,
    this.enabled = true,
    this.onRetryCountries,
  });

  final TextEditingController controller;
  final AuthChannel channel;
  final List<LocationNode> countries;
  final LocationNode? selectedCountry;
  final ValueChanged<LocationNode> onCountrySelected;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isLoadingCountries;
  final bool enabled;
  final VoidCallback? onRetryCountries;

  bool get _isMobile => channel == AuthChannel.mobile;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AuthColors.inputBorder;
    final bgColor = isDark ? AppColors.surfaceDark : AuthColors.inputBackground;

    final field = TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: _isMobile ? TextInputType.phone : TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      inputFormatters: _isMobile
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ]
          : null,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AuthColors.blueNh,
        height: 1.25,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: bgColor,
        hintText: _isMobile ? '9876543210' : KycStrings.emailHint,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF9CA3AF),
          height: 1.25,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AuthColors.blueNh, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );

    if (!_isMobile) return field;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryCodeSelector(
          countries: countries,
          selected: selectedCountry,
          onSelected: onCountrySelected,
          isLoading: isLoadingCountries,
          enabled: enabled,
          onRetry: onRetryCountries,
        ),
        const SizedBox(width: 8),
        Expanded(child: field),
      ],
    );
  }
}
