import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/auth_entry_provider.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/enter_password_screen.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/identifier_input_field.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:provider/provider.dart';

/// Route arguments for [AuthEntryScreen]. Every field is optional — the
/// router substitutes a default instance when the route is pushed with no
/// arguments, which is the common case.
class AuthEntryScreenArgs {
  const AuthEntryScreenArgs({this.prefillIdentifier, this.prefillChannel});

  final String? prefillIdentifier;
  final AuthChannel? prefillChannel;
}

/// The app's front door (spec §1).
///
/// One identifier — mobile or email — plus a country code, validated and
/// checked against the backend, then routed to password login or to
/// registration.
class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key, this.args = const AuthEntryScreenArgs()});

  final AuthEntryScreenArgs args;

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController =
      TextEditingController(text: widget.args.prefillIdentifier ?? '');

  // No `initState` provider work on purpose. Both the initial channel and
  // the dial-code fetch are handled where the provider is created (see
  // `AuthRouter`), because `loadCountryCodes` notifies listeners before
  // its first `await` — doing that from `initState` marks widgets dirty
  // mid-build and trips framework's `!_dirty` assertion.

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _toggleChannel() {
    final provider = context.read<AuthEntryProvider>();
    provider.setChannel(
      provider.isMobileMode ? AuthChannel.email : AuthChannel.mobile,
    );
    // The two channels accept different characters, so carrying the text
    // across would leave a value its own validator rejects.
    _identifierController.clear();
  }

  Future<void> _handleContinue() async {
    final provider = context.read<AuthEntryProvider>();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Validated here rather than in the field's validator: the country
    // code lives in a sibling widget with no `FormField` of its own.
    if (provider.isMobileMode && provider.countryCode == null) {
      _showMessage(KycStrings.countryCodeRequired);
      return;
    }

    final identifier = await provider.checkUserExists(
      _identifierController.text.trim(),
    );
    if (!mounted || identifier == null) return;

    final authState = context.read<AuthStateProvider>();

    if (provider.status == AuthEntryStatus.existingUser) {
      await Navigator.of(context).pushNamed(
        AppRoutes.enterPassword,
        arguments: EnterPasswordScreenArgs(
          identifier: identifier,
          maskedIdentifier: provider.maskedIdentifier ?? identifier.masked,
        ),
      );
      return;
    }

    // New user: record the identifier before leaving, so a restart on the
    // User Details screen resumes with the field already filled in.
    await authState.moveTo(
      AuthFlowState.registration,
      context: authState.context.copyWith(identifier: identifier),
    );
    if (!mounted) return;

    await Navigator.of(context).pushNamed(
      AppRoutes.userDetails,
      arguments: UserDetailsScreenArgs(identifier: identifier),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthEntryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: const CustomAppBar(title: '', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: NivassLogoMark(size: 96)),
                AppSpacing.gapLg,
                Text(
                  KycStrings.authEntryTitle,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapSm,
                Text(
                  KycStrings.authEntrySubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapXl,
                IdentifierInputField(
                  controller: _identifierController,
                  channel: provider.channel,
                  countries: provider.dialCodes,
                  selectedCountry: provider.selectedCountry,
                  isLoadingCountries: provider.isLoadingDialCodes,
                  enabled: !provider.isChecking,
                  onCountrySelected: provider.setCountry,
                  onRetryCountries: provider.loadCountryCodes,
                  onChanged: (_) => provider.clearError(),
                  onSubmitted: (_) => _handleContinue(),
                  validator: _validateIdentifier,
                ),
                if (provider.errorMessage != null) ...[
                  AppSpacing.gapSm,
                  Text(provider.errorMessage!, style: AppTextStyles.errorText),
                ],
                AppSpacing.gapLg,
                PrimaryButton(
                  label: KycStrings.continueLabel,
                  isLoading: provider.isChecking,
                  size: CustomButtonSize.large,
                  onPressed: provider.isChecking ? null : _handleContinue,
                ),
                AppSpacing.gapMd,
                TextButton(
                  onPressed: provider.isChecking ? null : _toggleChannel,
                  child: Text(
                    provider.isMobileMode
                        ? KycStrings.useEmailInstead
                        : KycStrings.useMobileInstead,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Delegates to the shared validators so the rules match the rest of the
  /// app. Mobile length is country-aware, since a `+44` number is not ten
  /// digits starting 6-9.
  String? _validateIdentifier(String? value) {
    final provider = context.read<AuthEntryProvider>();
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return KycStrings.identifierRequired;

    if (provider.isMobileMode) {
      return FormValidators.mobileNumberForDialCode(provider.countryCode)(
        trimmed,
      );
    }
    return FormValidators.email(trimmed);
  }
}
