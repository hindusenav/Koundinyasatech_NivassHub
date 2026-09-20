import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/providers/auth/user_details_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/location/location_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/common/section_title.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/selection_bottom_sheet.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/selection_field.dart';
import 'package:provider/provider.dart';

class UserDetailsScreenArgs {
  const UserDetailsScreenArgs({required this.identifier, this.prefillFullName});

  final AuthIdentifier identifier;
  final String? prefillFullName;
}

/// Registration form for a new user (spec §4 and §5): personal details,
/// the seven-level property cascade, role, and sub-branch.
class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.args});

  final UserDetailsScreenArgs args;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final identifier = widget.args.identifier;

    _nameController = TextEditingController(
      text: widget.args.prefillFullName ?? '',
    );
    // Whichever channel the user signed up with is pre-filled and the
    // other left blank, so nothing has to be re-typed.
    _mobileController = TextEditingController(
      text: identifier.channel == AuthChannel.mobile
          ? identifier.nationalNumber
          : '',
    );
    _emailController = TextEditingController(
      text: identifier.channel == AuthChannel.email ? identifier.raw : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get _countryCode => widget.args.identifier.countryCode ?? '+91';

  Future<void> _handleSubmit() async {
    final details = context.read<UserDetailsProvider>();
    final location = context.read<LocationProvider>();
    final kyc = context.read<KycProvider>();

    // Turn on the picker-level errors before validating, so the role and
    // sub-branch messages appear in the same pass as the field ones.
    details.markValidationVisible();

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (details.role == null || (details.subBranch?.isEmpty ?? true)) return;

    if (!location.isComplete) {
      final missing = location.selection.firstMissingLevel;
      CustomSnackbar.warning(
        context,
        'Please select ${missing?.label.toLowerCase() ?? 'your property'}.',
      );
      return;
    }

    final success = await details.createUser(
      identifier: widget.args.identifier,
      fullName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      countryCode: _countryCode,
      email: _emailController.text.trim(),
      location: location.selection,
    );

    if (!mounted) return;

    if (!success) {
      CustomSnackbar.error(
        context,
        details.errorMessage ?? KycStrings.genericError,
      );
      return;
    }

    final result = details.result!;
    final role = details.role!;

    await kyc.initialise(
      userId: result.userId,
      kycToken: result.kycToken,
      role: role,
    );

    // `pushNamedAndRemoveUntil` rather than `pushNamed`: the account now
    // exists, so backing into a completed registration form would let the
    // user submit it a second time.
    NavigationService.pushNamedAndRemoveUntil(
      AppRoutes.kycDocuments,
      arguments: KycDocumentsScreenArgs(
        userId: result.userId,
        kycToken: result.kycToken,
        role: role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = context.watch<UserDetailsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: const CustomAppBar(title: KycStrings.userDetailsTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  KycStrings.userDetailsSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondary,
                  ),
                ),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionPersonalDetails),
                AppSpacing.gapSm,
                CustomTextField(
                  controller: _nameController,
                  label: KycStrings.fullNameLabel,
                  hint: KycStrings.fullNameHint,
                  prefixIcon: AppIcons.profile,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                  ],
                  validator: FormValidators.fullName,
                ),
                AppSpacing.gapMd,
                CustomTextField(
                  controller: _mobileController,
                  label: '${KycStrings.mobileLabel} ($_countryCode)',
                  hint: KycStrings.mobileHint,
                  prefixIcon: AppIcons.phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  validator: FormValidators.mobileNumberForDialCode(
                    _countryCode,
                  ),
                ),
                AppSpacing.gapMd,
                CustomTextField(
                  controller: _emailController,
                  label: KycStrings.emailLabel,
                  hint: KycStrings.emailHint,
                  prefixIcon: AppIcons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: FormValidators.email,
                ),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionLocationDetails),
                AppSpacing.gapSm,
                // Country/State/City then Society→Flat: one loop over the
                // enum drives all seven, so the screen holds no per-level
                // logic at all.
                ..._buildCascade(LocationLevel.values.take(3)),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionPropertyDetails),
                AppSpacing.gapSm,
                ..._buildCascade(LocationLevel.values.skip(3)),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionRole),
                AppSpacing.gapSm,
                _RoleSelector(
                  selected: details.role,
                  errorText: details.roleError,
                  onSelected: details.setRole,
                ),
                AppSpacing.gapMd,
                _SubBranchField(errorText: details.subBranchError),
                AppSpacing.gapXl,

                PrimaryButton(
                  label: KycStrings.submitDetails,
                  isLoading: details.isSubmitting,
                  size: CustomButtonSize.large,
                  onPressed: details.isSubmitting ? null : _handleSubmit,
                ),
                AppSpacing.gapLg,
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCascade(Iterable<LocationLevel> levels) {
    return [
      for (final level in levels) ...[
        _CascadeField(level: level),
        AppSpacing.gapMd,
      ],
    ];
  }
}

/// One level of the cascade. Enabled only once its parent is chosen, and
/// cleared automatically whenever an ancestor changes.
class _CascadeField extends StatelessWidget {
  const _CascadeField({required this.level});

  final LocationLevel level;

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();
    final isEnabled = location.isEnabled(level);
    final selected = location.selectedFor(level);

    return SelectionField(
      label: level.label,
      value: selected?.name,
      hint: isEnabled ? level.hint : KycStrings.selectParentFirst,
      isLoading: location.isLoading(level),
      onTap: isEnabled ? () => _openPicker(context, location) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    LocationProvider location,
  ) async {
    // Options are fetched when the parent is chosen, so an untouched level
    // may never have loaded — e.g. Country on first open.
    if (location.stateFor(level) == LocationLoadState.initial) {
      await location.load(level);
      if (!context.mounted) return;
    }

    final choice = await SelectionBottomSheet.show<LocationNode>(
      context,
      title: level.sheetTitle,
      items: location.optionsFor(level),
      selected: location.selectedFor(level),
      labelOf: (node) => node.name,
      subtitleOf: (node) => node.subtitle,
      leadingOf: (node) => node.leadingText == null
          ? null
          : Text(node.leadingText!, style: AppTextStyles.titleMedium),
      searchHint: 'Search ${level.label.toLowerCase()}',
      isLoading: location.isLoading(level),
      errorMessage: location.errorFor(level),
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
      onRetry: () => location.retry(level),
    );

    if (choice != null) await location.select(level, choice);
  }
}

/// Owner / Tenant. A pair of cards rather than a picker, because the
/// choice changes which documents KYC will ask for and deserves to be
/// visible rather than hidden behind a tap.
class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selected,
    required this.onSelected,
    this.errorText,
  });

  final UserRole? selected;
  final ValueChanged<UserRole> onSelected;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final role in UserRole.values) ...[
              Expanded(
                child: _RoleCard(
                  role: role,
                  isSelected: selected == role,
                  onTap: () => onSelected(role),
                ),
              ),
              if (role != UserRole.values.last) AppSpacing.gapWSm,
            ],
          ],
        ),
        if (errorText != null) ...[
          AppSpacing.gapXs,
          Text(errorText!, style: AppTextStyles.errorText),
        ],
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: AppSpacing.cardInsets,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              role == UserRole.owner ? AppIcons.society : AppIcons.resident,
              color: isSelected ? AppColors.primary : textSecondary,
            ),
            AppSpacing.gapSm,
            Text(
              role.label,
              style: AppTextStyles.titleSmall.copyWith(
                color: isSelected ? AppColors.primary : textPrimary,
              ),
            ),
            AppSpacing.gapXs,
            Text(
              role.description,
              style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sub-branch is a flat list, not part of the cascade — it qualifies the
/// resident rather than the property.
///
/// Stateless on purpose. Kicking the fetch off from a `State.initState`
/// made `LocationProvider` notify synchronously, and the seven cascade
/// fields above already watch it in the same frame — so they were marked
/// dirty mid-build, tripping the framework's `!_dirty` assertion. The
/// fetch now starts where the provider is created (see `AuthRouter`).
class _SubBranchField extends StatelessWidget {
  const _SubBranchField({this.errorText});

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();
    final details = context.watch<UserDetailsProvider>();

    return SelectionField(
      label: KycStrings.subBranchLabel,
      hint: KycStrings.subBranchHint,
      value: details.subBranch,
      errorText: errorText,
      isLoading: location.isLoadingSubBranches,
      prefixIcon: AppIcons.unit,
      onTap: () => _openPicker(context, location, details),
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    LocationProvider location,
    UserDetailsProvider details,
  ) async {
    final choice = await SelectionBottomSheet.show<String>(
      context,
      title: KycStrings.subBranchSheetTitle,
      items: location.subBranches,
      selected: details.subBranch,
      labelOf: (value) => value,
      errorMessage: location.subBranchError,
      onRetry: location.loadSubBranches,
      emptyTitle: KycStrings.noOptionsAvailable,
    );
    if (choice != null) details.setSubBranch(choice);
  }
}
