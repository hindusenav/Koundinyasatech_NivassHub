import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/widgets/auth/country_code_selector.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

/// The mobile-or-email field on the authentication entry screen.
///
/// Composes a [CountryCodeSelector] (mobile only) with a
/// [CustomTextField], and swaps label, hint, keyboard and input
/// formatters as the channel changes — so the caller owns one controller
/// and one validator regardless of which mode is active.
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
    final field = CustomTextField(
      controller: controller,
      label: _isMobile ? KycStrings.mobileLabel : KycStrings.emailLabel,
      hint: _isMobile ? KycStrings.mobileHint : KycStrings.emailHint,
      prefixIcon: _isMobile ? null : AppIcons.email,
      keyboardType: _isMobile
          ? TextInputType.phone
          : TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      // Digits-only keeps the field's contents consistent with what
      // `AuthIdentifier.normalized` will send; an email needs no filter.
      inputFormatters: _isMobile
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ]
          : null,
    );

    if (!_isMobile) return field;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nudged down so the chip aligns with the field's input line
        // rather than with its floating label.
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CountryCodeSelector(
            countries: countries,
            selected: selectedCountry,
            onSelected: onCountrySelected,
            isLoading: isLoadingCountries,
            enabled: enabled,
            onRetry: onRetryCountries,
          ),
        ),
        AppSpacing.gapWSm,
        Expanded(child: field),
      ],
    );
  }
}
