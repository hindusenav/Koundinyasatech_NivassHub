import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_nivasshub/screens/kyc/kyc_residence_role_screen.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_nivasshub/widgets/location/figma_place_picker.dart';
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

  /// `false` until the Country → State → City pages have been walked.
  bool _locationReady = false;

  /// Country, state and city are fixed once chosen on those pages.
  bool _locationLocked = false;

  Route<dynamic>? _route;

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _startLocationFlow());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// New-user entry: Select Country → Select State → Select City pages, then
  /// the form below with those three fields filled and locked.
  ///
  /// Selections go through the same provider calls the old pickers made.
  /// If the country list cannot be loaded the form is shown with its
  /// ordinary editable pickers, as before.
  Future<void> _startLocationFlow() async {
    final location = context.read<LocationProvider>();
    final master = context.read<RegistrationMasterDataProvider>();
    final society = context.read<SocietyDetailsProvider>();

    if (location.stateFor(LocationLevel.country) == LocationLoadState.initial) {
      await location.load(LocationLevel.country);
      if (!mounted) return;
    }

    // The route starts both fetches when it is created, so wait for them.
    await _untilLoaded(location, master);
    if (!mounted) return;

    final countries = location.optionsFor(LocationLevel.country);
    if (countries.isEmpty) {
      setState(() => _locationReady = true);
      return;
    }

    final done =
        await FigmaPlacePicker.locationFlow<LocationNode, RegistrationState>(
          context,
          countries: countries,
          countryLabel: (c) => c.name,
          countryFlag: (c) => c.flagEmoji,
          onCountry: (c) {
            // The selection is recorded synchronously; the follow-up fetch of the
            // next level runs on its own, so the State page need not wait for it.
            unawaited(location.select(LocationLevel.country, c));
            master.selectCountry(c.id);
            society.reset();
          },
          states: () => master.statesForSelectedCountry,
          stateLabel: (s) => s.provinceName,
          onState: (s) {
            master.selectState(s);
            society.reset();
          },
          cities: () => master.citiesForSelectedState,
          onCity: (c) {
            master.selectCity(c);
            society.reset();
          },
          citySubtitle: () => [
            master.selectedState?.provinceName,
            location.selectedFor(LocationLevel.country)?.name,
          ].whereType<String>().join(', '),
        );
    if (!mounted) return;

    if (!done) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _locationReady = true;
      _locationLocked = true;
    });
  }

  /// Completes once the country list and the master data have finished loading.
  Future<void> _untilLoaded(
    LocationProvider location,
    RegistrationMasterDataProvider master,
  ) {
    bool busy() =>
        location.isLoading(LocationLevel.country) || master.isLoading;
    if (!busy()) return Future.value();

    final done = Completer<void>();
    void check() {
      if (busy()) return;
      location.removeListener(check);
      master.removeListener(check);
      done.complete();
    }

    location.addListener(check);
    master.addListener(check);
    return done.future;
  }

  String get _countryCode =>
      context
          .read<LocationProvider>()
          .selectedFor(LocationLevel.country)
          ?.dialCode ??
      widget.args.identifier.countryCode ??
      '+91';

  /// "Submit Details": validates the form, then opens the final role step.
  /// The account is created from that step, with the same request as before.
  Future<void> _handleSubmit() async {
    final location = context.read<LocationProvider>();
    final master = context.read<RegistrationMasterDataProvider>();
    final society = context.read<SocietyDetailsProvider>();

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (location.selectedFor(LocationLevel.country) == null ||
        master.selectedState == null ||
        master.selectedCity == null) {
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

    _route = ModalRoute.of(context);
    final details = context.read<UserDetailsProvider>();
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider<RegistrationMasterDataProvider>.value(
              value: master,
            ),
            ChangeNotifierProvider<UserDetailsProvider>.value(value: details),
          ],
          child: _RoleStepPage(onSubmit: _submitRegistration),
        ),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    final details = context.read<UserDetailsProvider>();
    final location = context.read<LocationProvider>();
    final master = context.read<RegistrationMasterDataProvider>();
    final society = context.read<SocietyDetailsProvider>();

    // Turn on the role error before validating the role choice.
    details.markValidationVisible();

    final selectedRole = master.selectedRole;
    final selectedSubRole = master.selectedSubRole;
    if (selectedRole == null || details.role == null) {
      CustomSnackbar.warning(context, KycStrings.roleRequired);
      return;
    }
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

    // Close the role step so the OTP screen replaces the form, not that page.
    if (_route != null) Navigator.of(context).popUntil((r) => r == _route);

    // `pushReplacement` so a resubmit loop does not grow the stack by two
    // routes per attempt.
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.otpMobileEmailVerification,
      arguments: OtpMobileEmailVerificationScreenArgs(
        userId: result.userId,
        email: result.email.isNotEmpty
            ? result.email
            : _emailController.text.trim(),
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
    final t = FigmaColors.of(context);

    // Blank while the country / state / city pages are on top.
    if (!_locationReady) {
      return Scaffold(
        backgroundColor: t.page,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FigmaHeaderScaffold(
      title: KycStrings.userDetailsTitle,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: context.pageInsets,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        KycStrings.userDetailsSubtitle,
                        style: AppTextStyles.bodyMedium.copyWith(color: t.body),
                      ),
                      context.gapMd,

                      FigmaCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const FigmaSectionLabel(
                              KycStrings.sectionPersonalDetails,
                            ),
                            AppSpacing.gapMd,
                            CustomTextField(
                              controller: _nameController,
                              label: KycStrings.fullNameLabel,
                              hint: KycStrings.fullNameHint,
                              prefixIcon: AppIcons.profile,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Za-z ]'),
                                ),
                              ],
                              validator: FormValidators.fullName,
                            ),
                            AppSpacing.gapMd,
                            CustomTextField(
                              controller: _mobileController,
                              label:
                                  '${KycStrings.mobileLabel} ($_countryCode)',
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
                          ],
                        ),
                      ),
                      context.gapMd,

                      FigmaCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const FigmaSectionLabel(
                              KycStrings.sectionLocationDetails,
                            ),
                            AppSpacing.gapMd,
                            _CountryField(locked: _locationLocked),
                            AppSpacing.gapMd,
                            _StateField(locked: _locationLocked),
                            AppSpacing.gapMd,
                            _CityField(locked: _locationLocked),
                          ],
                        ),
                      ),
                      context.gapMd,

                      FigmaCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const FigmaSectionLabel(
                              KycStrings.sectionPropertyDetails,
                            ),
                            AppSpacing.gapMd,
                            const _SocietyField(),
                            AppSpacing.gapMd,
                            const _TowerField(),
                            AppSpacing.gapMd,
                            const _FloorField(),
                            AppSpacing.gapMd,
                            const _UnitField(),
                            AppSpacing.gapMd,
                            const _UnitBranchField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _StickySubmitBar(
              label: KycStrings.submitDetails,
              isLoading: details.isSubmitting,
              onPressed: details.isSubmitting ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom bar pinned under the scroll area holding the primary CTA.
class _StickySubmitBar extends StatelessWidget {
  const _StickySubmitBar({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: context.rs(12)),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: FigmaButton(
        label: label,
        isLoading: isLoading,
        onPressed: onPressed,
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
  const _CountryField({this.locked = false});

  final bool locked;

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
      prefixIcon: Icons.public_outlined,
      isLoading: location.isLoading(LocationLevel.country),
      onTap: locked ? null : () => _openPicker(context, location),
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    LocationProvider location,
  ) async {
    if (location.stateFor(LocationLevel.country) == LocationLoadState.initial) {
      await location.load(LocationLevel.country);
      if (!context.mounted) return;
    }

    final choice = await FigmaPlacePicker.country<LocationNode>(
      context,
      items: location.optionsFor(LocationLevel.country),
      labelOf: (node) => node.name,
      flagOf: (node) => node.flagEmoji,
      isLoading: location.isLoading(LocationLevel.country),
      errorMessage: location.errorFor(LocationLevel.country),
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
  const _StateField({this.locked = false});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();
    final master = context.watch<RegistrationMasterDataProvider>();
    final countrySelected = location.selectedFor(LocationLevel.country) != null;

    return SelectionField(
      label: KycStrings.stateLabel,
      value: master.selectedState?.provinceName,
      hint: countrySelected
          ? KycStrings.stateHint
          : KycStrings.selectCountryFirst,
      prefixIcon: Icons.map_outlined,
      onTap: countrySelected && !locked
          ? () => _openPicker(context, master)
          : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final choice = await FigmaPlacePicker.state<RegistrationState>(
      context,
      items: master.statesForSelectedCountry,
      labelOf: (state) => state.provinceName,
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
  const _CityField({this.locked = false});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final stateSelected = master.selectedState != null;

    return SelectionField(
      label: KycStrings.cityLabel,
      value: master.selectedCity,
      hint: stateSelected ? KycStrings.cityHint : KycStrings.selectStateFirst,
      prefixIcon: Icons.location_city_outlined,
      onTap: stateSelected && !locked
          ? () => _openPicker(context, master)
          : null,
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    RegistrationMasterDataProvider master,
  ) async {
    final country = context.read<LocationProvider>().selectedFor(
      LocationLevel.country,
    );
    final choice = await FigmaPlacePicker.city<String>(
      context,
      items: master.citiesForSelectedState,
      labelOf: (city) => city,
      subtitle: [
        master.selectedState?.provinceName,
        country?.name,
      ].whereType<String>().join(', '),
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
      onTap: society.isTowerEnabled
          ? () => _openPicker(context, society)
          : null,
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
      onTap: society.isFloorEnabled
          ? () => _openPicker(context, society)
          : null,
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

/// Final registration step: Owner / Tenant, sub-role (and category when the
/// sub-role has one) and the move-in rules. Reads and writes the same
/// `RegistrationMasterDataProvider` / `UserDetailsProvider` state the old
/// Role card did; [onSubmit] runs the unchanged registration request.
class _RoleStepPage extends StatelessWidget {
  const _RoleStepPage({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final master = context.watch<RegistrationMasterDataProvider>();
    final details = context.watch<UserDetailsProvider>();

    final subRoles = master.subRolesForSelectedRole;
    final categories = master.categoriesForSelectedSubRole;
    final roleSelected = master.selectedRole != null;

    return KycResidenceRoleScreen(
      isLoading: master.isLoading,
      isSubmitting: details.isSubmitting,
      selectedRoleId: master.selectedRole?.roleId,
      roles: [
        for (final role in master.roles)
          ResidenceRoleChoice(
            id: role.roleId,
            title: role.userRole?.label ?? role.description,
            subtitle: role.userRole?.description ?? '',
            icon: switch (role.userRole) {
              UserRole.owner => Icons.home_outlined,
              UserRole.tenant => Icons.vpn_key_outlined,
              null => Icons.person_outline,
            },
          ),
      ],
      onRoleChanged: (id) {
        final role = master.roles.firstWhere((r) => r.roleId == id);
        master.selectRole(role);
        final userRole = role.userRole;
        if (userRole != null) details.setRole(userRole);
      },
      dropdowns: [
        ResidenceRoleDropdown(
          label: KycStrings.subRoleLabel,
          hint: roleSelected
              ? KycStrings.subRoleHint
              : KycStrings.selectRoleFirst,
          value: master.selectedSubRole?.description,
          items: [for (final s in subRoles) s.description],
          enabled: roleSelected,
          onChanged: (i) => master.selectSubRole(subRoles[i]),
        ),
        if (master.needsCategory)
          ResidenceRoleDropdown(
            label: KycStrings.categoryLabel,
            hint: KycStrings.categoryHint,
            value: master.selectedCategory?.description,
            items: [for (final c in categories) c.description],
            onChanged: (i) => master.selectCategory(categories[i]),
          ),
      ],
      onContinue: onSubmit,
    );
  }
}
