import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/providers/auth/user_details_provider.dart';
import 'package:flutter_nivasshub/providers/location/location_provider.dart';
import 'package:flutter_nivasshub/providers/registration/registration_master_data_provider.dart';
import 'package:flutter_nivasshub/providers/society/society_details_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/otp_mobile_email_verification_screen.dart';
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

/// Registration form for a new user: personal details, Country → State →
/// City, Society → Tower → Floor → Unit, role, and unit branch.
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

  String get _countryCode =>
      context.read<LocationProvider>().selectedFor(LocationLevel.country)?.dialCode ??
      widget.args.identifier.countryCode ??
      '+91';

  Future<void> _handleSubmit() async {
    final details = context.read<UserDetailsProvider>();
    final location = context.read<LocationProvider>();
    final master = context.read<RegistrationMasterDataProvider>();
    final society = context.read<SocietyDetailsProvider>();

    // Turn on the picker-level errors before validating, so the role
    // message appears in the same pass as the field ones.
    details.markValidationVisible();

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    final selectedRole = master.selectedRole;
    final selectedSubRole = master.selectedSubRole;
    if (selectedRole == null || details.role == null) return;
    if (selectedSubRole == null) {
      CustomSnackbar.warning(context, KycStrings.subRoleRequired);
      return;
    }
    if (master.needsCategory && master.selectedCategory == null) {
      CustomSnackbar.warning(context, KycStrings.categoryRequired);
      return;
    }

    final country = location.selectedFor(LocationLevel.country);
    final state = master.selectedState;
    final city = master.selectedCity;
    if (country == null || state == null || city == null) {
      CustomSnackbar.warning(
        context,
        'Please select your country, state and city.',
      );
      return;
    }

    if (society.selectedTower == null ||
        society.selectedFloor == null ||
        society.selectedUnit == null) {
      CustomSnackbar.warning(context, KycStrings.propertySelectionIncomplete);
      return;
    }

    final result = await details.submit(
      fullName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      mobileCountryCode: _countryCode,
      email: _emailController.text.trim(),
      country: country.id,
      state: state.provinceId,
      city: city,
      socId: master.selectedSociety?.socId ?? '',
      towerId: society.selectedTower!.towerId,
      floorId: society.selectedFloor!.floorId,
      unitId: society.selectedUnit!.unitId,
      roleId: selectedRole.roleId,
      subRole: selectedSubRole.subRoleId,
      subRoleCat: master.needsCategory
          ? master.selectedCategory?.categoryId
          : null,
      unitBranch: society.selectedUnitBranch,
    );

    if (!mounted) return;

    if (result == null) {
      CustomSnackbar.error(
        context,
        details.errorMessage ?? KycStrings.genericError,
      );
      return;
    }

    final role = details.role!;

    // Persist the hand-off so a restart resumes on the OTP screen, and drop
    // the form draft now that the account exists.
    final authState = context.read<AuthStateProvider>();
    await authState.saveRegistrationToken(result.userId);
    await authState.moveTo(
      AuthFlowState.otpPending,
      context: authState.context.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: role,
      ),
    );
    if (!mounted) return;

    // `pushReplacement` so a resubmit loop does not grow the stack by two
    // routes per attempt.
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.otpMobileEmailVerification,
      arguments: OtpMobileEmailVerificationScreenArgs(
        userId: result.userId,
        email: result.email.isNotEmpty ? result.email : _emailController.text.trim(),
        mobileNumber: result.mobileNumber.isNotEmpty
            ? result.mobileNumber
            : _mobileController.text.trim(),
        role: role,
        resendIdentifier: widget.args.identifier.channel == AuthChannel.mobile
            ? AuthIdentifier(
                raw: _mobileController.text.trim(),
                channel: AuthChannel.mobile,
                countryCode: _countryCode,
              )
            : AuthIdentifier(
                raw: _emailController.text.trim(),
                channel: AuthChannel.email,
              ),
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
                const _CountryField(),
                AppSpacing.gapMd,
                const _StateField(),
                AppSpacing.gapMd,
                const _CityField(),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionPropertyDetails),
                AppSpacing.gapSm,
                const _SocietyField(),
                AppSpacing.gapMd,
                const _TowerField(),
                AppSpacing.gapMd,
                const _FloorField(),
                AppSpacing.gapMd,
                const _UnitField(),
                AppSpacing.gapMd,
                const _UnitBranchField(),
                AppSpacing.gapLg,

                const SectionTitle(title: KycStrings.sectionRole),
                AppSpacing.gapSm,
                const _RoleField(),
                if (details.roleError != null) ...[
                  AppSpacing.gapXs,
                  Text(details.roleError!, style: AppTextStyles.errorText),
                ],
                AppSpacing.gapMd,
                const _SubRoleField(),
                if (context.watch<RegistrationMasterDataProvider>().needsCategory) ...[
                  AppSpacing.gapMd,
                  const _CategoryField(),
                ],
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
}

/// Country picker — the only field still driven by `LocationProvider`
/// (its `getCountries()` now points at the registration master-data
/// endpoint via `RegistrationServiceBase`). Selecting a country also syncs
/// `RegistrationMasterDataProvider` so the State picker can read that
/// country's nested states.
class _CountryField extends StatelessWidget {
  const _CountryField();

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();
    final selected = location.selectedFor(LocationLevel.country);

    return SelectionField(
      label: LocationLevel.country.label,
      value: selected == null
          ? null
          : [selected.flagEmoji, selected.name].whereType<String>().join(' '),
      hint: LocationLevel.country.hint,
      isLoading: location.isLoading(LocationLevel.country),
      onTap: () => _openPicker(context, location),
    );
  }

  Future<void> _openPicker(BuildContext context, LocationProvider location) async {
    if (location.stateFor(LocationLevel.country) == LocationLoadState.initial) {
      await location.load(LocationLevel.country);
      if (!context.mounted) return;
    }

    final choice = await SelectionBottomSheet.show<LocationNode>(
      context,
      title: LocationLevel.country.sheetTitle,
      items: location.optionsFor(LocationLevel.country),
      selected: location.selectedFor(LocationLevel.country),
      labelOf: (node) => node.name,
      leadingOf: (node) => node.flagEmoji == null
          ? null
          : Text(node.flagEmoji!, style: AppTextStyles.titleMedium),
      searchHint: 'Search country',
      isLoading: location.isLoading(LocationLevel.country),
      errorMessage: location.errorFor(LocationLevel.country),
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
      onRetry: () => location.retry(LocationLevel.country),
    );

    if (choice == null || !context.mounted) return;
    await location.select(LocationLevel.country, choice);
    if (!context.mounted) return;
    context.read<RegistrationMasterDataProvider>().selectCountry(choice.id);
    context.read<SocietyDetailsProvider>().reset();
  }
}

/// State picker — sourced synchronously from the selected country's
/// states already cached by `RegistrationMasterDataProvider`; no network
/// call happens here.
class _StateField extends StatelessWidget {
  const _StateField();

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();
    final master = context.watch<RegistrationMasterDataProvider>();
    final countrySelected =
        location.selectedFor(LocationLevel.country) != null;

    return SelectionField(
      label: KycStrings.stateLabel,
      value: master.selectedState?.provinceName,
      hint: countrySelected ? KycStrings.stateHint : KycStrings.selectCountryFirst,
      onTap: countrySelected ? () => _openPicker(context, master) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<RegistrationState>(
      context,
      title: 'Select ${KycStrings.stateLabel}',
      items: master.statesForSelectedCountry,
      selected: master.selectedState,
      labelOf: (state) => state.provinceName,
      searchHint: 'Search state',
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice == null || !context.mounted) return;
    master.selectState(choice);
    context.read<SocietyDetailsProvider>().reset();
  }
}

/// City picker — sourced from the distinct `city` values of the societies
/// in the selected state (`Societies[].city`; there is no dedicated city
/// list endpoint). Selecting a city narrows the Society picker below to
/// that city.
class _CityField extends StatelessWidget {
  const _CityField();

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final stateSelected = master.selectedState != null;

    return SelectionField(
      label: KycStrings.cityLabel,
      value: master.selectedCity,
      hint: stateSelected ? KycStrings.cityHint : KycStrings.selectStateFirst,
      onTap: stateSelected ? () => _openPicker(context, master) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<String>(
      context,
      title: 'Select ${KycStrings.cityLabel}',
      items: master.citiesForSelectedState,
      selected: master.selectedCity,
      labelOf: (city) => city,
      searchHint: 'Search city',
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice == null || !context.mounted) return;
    master.selectCity(choice);
    context.read<SocietyDetailsProvider>().reset();
  }
}

/// Society picker — sourced from the same cached master-data response,
/// filtered to the selected city. Selecting a society kicks off
/// `GET /society/details?socid=` to load the Tower→Floor→Unit tree.
class _SocietyField extends StatelessWidget {
  const _SocietyField();

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final citySelected = master.selectedCity != null;

    return SelectionField(
      label: KycStrings.societyLabel,
      value: master.selectedSociety?.societyName,
      hint: citySelected ? KycStrings.societyHint : KycStrings.selectCityFirst,
      isLoading: master.isLoading,
      onTap: citySelected ? () => _openPicker(context, master) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<RegistrationSociety>(
      context,
      title: 'Select ${KycStrings.societyLabel}',
      items: master.societies,
      selected: master.selectedSociety,
      labelOf: (society) => society.societyName,
      subtitleOf: (society) => society.subtitle,
      searchHint: 'Search society',
      isLoading: master.isLoading,
      errorMessage: master.errorMessage,
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
      onRetry: master.retry,
    );
    if (choice == null || !context.mounted) return;
    master.selectSociety(choice);
    await context.read<SocietyDetailsProvider>().fetchSociety(choice.socId);
  }
}

class _TowerField extends StatelessWidget {
  const _TowerField();

  @override
  Widget build(BuildContext context) {
    final society = context.watch<SocietyDetailsProvider>();

    return SelectionField(
      label: KycStrings.towerLabel,
      value: society.selectedTower?.towerName,
      hint: society.isTowerEnabled
          ? KycStrings.towerHint
          : KycStrings.selectSocietyFirst,
      isLoading: society.isLoading,
      onTap: society.isTowerEnabled ? () => _openPicker(context, society) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    SocietyDetailsProvider society,
  ) async {
    final choice = await SelectionBottomSheet.show<SocietyTower>(
      context,
      title: 'Select ${KycStrings.towerLabel}',
      items: society.towers,
      selected: society.selectedTower,
      labelOf: (tower) => tower.towerName,
      subtitleOf: (tower) => tower.towerCode,
      searchHint: 'Search tower',
      isLoading: society.isLoading,
      errorMessage: society.errorMessage,
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
      onRetry: society.retry,
    );
    if (choice != null) society.selectTower(choice);
  }
}

class _FloorField extends StatelessWidget {
  const _FloorField();

  @override
  Widget build(BuildContext context) {
    final society = context.watch<SocietyDetailsProvider>();

    return SelectionField(
      label: KycStrings.floorLabel,
      value: society.selectedFloor?.floorName,
      hint: society.isFloorEnabled
          ? KycStrings.floorHint
          : KycStrings.selectTowerFirst,
      onTap: society.isFloorEnabled ? () => _openPicker(context, society) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    SocietyDetailsProvider society,
  ) async {
    final choice = await SelectionBottomSheet.show<SocietyFloor>(
      context,
      title: 'Select ${KycStrings.floorLabel}',
      items: society.floors,
      selected: society.selectedFloor,
      labelOf: (floor) => floor.floorName,
      searchHint: 'Search floor',
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice != null) society.selectFloor(choice);
  }
}

class _UnitField extends StatelessWidget {
  const _UnitField();

  @override
  Widget build(BuildContext context) {
    final society = context.watch<SocietyDetailsProvider>();

    return SelectionField(
      label: KycStrings.unitLabel,
      value: society.selectedUnit?.unitNumber,
      hint: society.isUnitEnabled
          ? KycStrings.unitHint
          : KycStrings.selectFloorFirst,
      onTap: society.isUnitEnabled ? () => _openPicker(context, society) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    SocietyDetailsProvider society,
  ) async {
    final choice = await SelectionBottomSheet.show<SocietyUnit>(
      context,
      title: 'Select ${KycStrings.unitLabel}',
      items: society.units,
      selected: society.selectedUnit,
      labelOf: (unit) => unit.unitNumber,
      subtitleOf: (unit) => unit.unitTypeBhk,
      searchHint: 'Search unit',
      // A floor with no units yet is a genuine empty state, not an error.
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice != null) society.selectUnit(choice);
  }
}

/// Unit Sub-Branch — not an independent choice, there is no API for it.
/// It mirrors the selected unit's `unitTypeBhk` (e.g. `"5bhk"`), so it's
/// read-only and stays disabled until a Unit is picked.
class _UnitBranchField extends StatelessWidget {
  const _UnitBranchField();

  @override
  Widget build(BuildContext context) {
    final society = context.watch<SocietyDetailsProvider>();

    return SelectionField(
      label: KycStrings.subBranchLabel,
      value: society.selectedUnitBranch,
      hint: society.selectedUnit != null
          ? KycStrings.subBranchHint
          : KycStrings.selectUnitFirst,
      onTap: null,
    );
  }
}

/// Role picker — options come from `Roles[]` in the master-data response
/// (User / Tenant). The choice also decides which documents KYC asks for,
/// so it is mapped onto [UserRole] via `RegistrationRole.userRole`.
class _RoleField extends StatelessWidget {
  const _RoleField();

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();

    return SelectionField(
      label: KycStrings.roleLabel,
      value: master.selectedRole?.description,
      hint: KycStrings.roleHint,
      isLoading: master.isLoading,
      onTap: () => _openPicker(context, master),
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<RegistrationRole>(
      context,
      title: 'Select ${KycStrings.roleLabel}',
      items: master.roles,
      selected: master.selectedRole,
      labelOf: (role) => role.description,
      isLoading: master.isLoading,
      errorMessage: master.errorMessage,
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
      onRetry: master.retry,
    );
    if (choice == null || !context.mounted) return;
    master.selectRole(choice);
    final userRole = choice.userRole;
    if (userRole != null) context.read<UserDetailsProvider>().setRole(userRole);
  }
}

/// Sub-role picker — the selected role's `Sub_Role[]`.
class _SubRoleField extends StatelessWidget {
  const _SubRoleField();

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final roleSelected = master.selectedRole != null;

    return SelectionField(
      label: KycStrings.subRoleLabel,
      value: master.selectedSubRole?.description,
      hint: roleSelected ? KycStrings.subRoleHint : KycStrings.selectRoleFirst,
      onTap: roleSelected ? () => _openPicker(context, master) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<RegistrationSubRole>(
      context,
      title: 'Select ${KycStrings.subRoleLabel}',
      items: master.subRolesForSelectedRole,
      selected: master.selectedSubRole,
      labelOf: (subRole) => subRole.description,
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice != null) master.selectSubRole(choice);
  }
}

/// Category picker — shown only when the selected sub-role has
/// `Categories[]`; sent as `sub_role_cat`.
class _CategoryField extends StatelessWidget {
  const _CategoryField();

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final subRoleSelected = master.selectedSubRole != null;

    return SelectionField(
      label: KycStrings.categoryLabel,
      value: master.selectedCategory?.description,
      hint: subRoleSelected
          ? KycStrings.categoryHint
          : KycStrings.selectSubRoleFirst,
      onTap: subRoleSelected ? () => _openPicker(context, master) : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await SelectionBottomSheet.show<RegistrationCategory>(
      context,
      title: 'Select ${KycStrings.categoryLabel}',
      items: master.categoriesForSelectedSubRole,
      selected: master.selectedCategory,
      labelOf: (category) => category.description,
      emptyTitle: KycStrings.noOptionsAvailable,
      emptyMessage: KycStrings.noOptionsMessage,
    );
    if (choice != null) master.selectCategory(choice);
  }
}
