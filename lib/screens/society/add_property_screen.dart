import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/providers/society/add_property_provider.dart';
import 'package:flutter_nivasshub/providers/society/society_details_provider.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_residence_role_screen.dart';
import 'package:flutter_nivasshub/services/society/add_society_service.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/widgets/location/figma_place_picker.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/selection_bottom_sheet.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/selection_field.dart';
import 'package:provider/provider.dart';

/// "Add Flat/Villa/Office": adds the signed-in user to another society unit
/// via `GET /society/add-master-data` and `POST /society/add-user`. Owns its
/// providers, so nothing about it is global.
class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AddPropertyProvider(
            service: AddSocietyService(context.read<ApiClient>()),
            readToken: context.read<SecureStorageService>().getAccessToken,
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SocietyDetailsProvider(context.read<SocietyServiceBase>()),
        ),
      ],
      child: const _AddPropertyView(),
    );
  }
}

class _AddPropertyView extends StatefulWidget {
  const _AddPropertyView();

  @override
  State<_AddPropertyView> createState() => _AddPropertyViewState();
}

class _AddPropertyViewState extends State<_AddPropertyView> {
  bool _flowStarted = false;

  /// `false` until the Country → State → City pages have been walked.
  bool _locationReady = false;

  /// Country, state and city are fixed once chosen on those pages.
  bool _locationLocked = false;

  Route<dynamic>? _route;

  /// Select Country → Select State → Select City pages, then the form with
  /// those three fields filled and locked. Selections go through the same
  /// provider calls the old pickers made; if the country list is empty the
  /// ordinary editable pickers are shown instead.
  Future<void> _startLocationFlow() async {
    final form = context.read<AddPropertyProvider>();
    final society = context.read<SocietyDetailsProvider>();

    if (form.countries.isEmpty) {
      setState(() => _locationReady = true);
      return;
    }

    final done =
        await FigmaPlacePicker.locationFlow<
          RegistrationCountry,
          RegistrationState
        >(
          context,
          countries: form.countries,
          countryLabel: (c) => c.name,
          onCountry: (c) {
            form.selectCountry(c);
            society.reset();
          },
          states: () => form.states,
          stateLabel: (s) => s.provinceName,
          onState: (s) {
            form.selectState(s);
            society.reset();
          },
          cities: () => form.cities,
          onCity: (c) {
            form.selectCity(c);
            society.reset();
          },
          citySubtitle: () => [
            form.selectedState?.provinceName,
            form.selectedCountry?.name,
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

  /// "Submit Details": checks the property picks, then opens the final role
  /// step, which runs the unchanged validation and request.
  void _continueToRole() {
    final form = context.read<AddPropertyProvider>();
    final society = context.read<SocietyDetailsProvider>();

    if (form.selectedSociety == null ||
        society.selectedTower == null ||
        society.selectedFloor == null ||
        society.selectedUnit == null) {
      CustomSnackbar.warning(
        context,
        'Please select the society, tower, floor and unit.',
      );
      return;
    }

    _route = ModalRoute.of(context);
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<AddPropertyProvider>.value(
          value: form,
          child: _RoleStepPage(onSubmit: _submit),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final form = context.read<AddPropertyProvider>();
    final society = context.read<SocietyDetailsProvider>();

    final problem = form.validate(
      tower: society.selectedTower,
      floor: society.selectedFloor,
      unit: society.selectedUnit,
    );
    if (problem != null) {
      CustomSnackbar.warning(context, problem);
      return;
    }

    final ok = await form.submit(
      tower: society.selectedTower!,
      floor: society.selectedFloor!,
      unit: society.selectedUnit!,
    );
    if (!mounted) return;

    if (ok) {
      CustomSnackbar.success(context, form.resultMessage ?? '');
      // Close the role step first so the result reaches the caller.
      if (_route != null) Navigator.of(context).popUntil((r) => r == _route);
      Navigator.of(context).pop(true);
    } else {
      CustomSnackbar.error(
        context,
        form.errorMessage ?? KycStrings.genericError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();
    final t = FigmaColors.of(context);

    if (!_flowStarted && form.state == AddPropertyState.ready) {
      _flowStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startLocationFlow();
      });
    }
    // Blank while the country / state / city pages are on top.
    if (!_locationReady && form.state == AddPropertyState.ready) {
      return Scaffold(backgroundColor: t.page);
    }

    return FigmaHeaderScaffold(
      title: 'Add Flat/Villa/Office',
      body: SafeArea(
        top: false,
        child: switch (form.state) {
          AddPropertyState.initial || AddPropertyState.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          AddPropertyState.error => _LoadError(
            message: form.errorMessage ?? KycStrings.genericError,
            onRetry: form.retry,
          ),
          _ => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Pick the property you want to add. It will be pending '
                        'approval once submitted.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FigmaCard(
                        child: _LocationSection(locked: _locationLocked),
                      ),
                      const SizedBox(height: 16),
                      const FigmaCard(child: _PropertySection()),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                  label: 'Submit Details',
                  onPressed: _continueToRole,
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FigmaButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

/// Opens a [SelectionBottomSheet] with the shared empty-state copy.
Future<T?> _pick<T>(
  BuildContext context, {
  required String title,
  required List<T> items,
  required T? selected,
  required String Function(T) labelOf,
  String? Function(T)? subtitleOf,
  String searchHint = 'Search',
}) {
  return SelectionBottomSheet.show<T>(
    context,
    title: title,
    items: items,
    selected: selected,
    labelOf: labelOf,
    subtitleOf: subtitleOf,
    searchHint: searchHint,
    emptyTitle: KycStrings.noOptionsAvailable,
    emptyMessage: KycStrings.noOptionsMessage,
  );
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({this.locked = false});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();
    final society = context.read<SocietyDetailsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FigmaSectionLabel(KycStrings.sectionLocationDetails),
        AppSpacing.gapMd,
        SelectionField(
          label: 'Country',
          value: form.selectedCountry?.name,
          hint: 'Select country',
          prefixIcon: Icons.public_outlined,
          onTap: locked
              ? null
              : () async {
                  final c = await FigmaPlacePicker.country<RegistrationCountry>(
                    context,
                    items: form.countries,
                    labelOf: (c) => c.name,
                    flagOf: (c) => FigmaPlacePicker.flagFromCode(c.countryCode),
                  );
                  if (c == null) return;
                  form.selectCountry(c);
                  society.reset();
                },
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.stateLabel,
          value: form.selectedState?.provinceName,
          hint: form.selectedCountry != null
              ? KycStrings.stateHint
              : KycStrings.selectCountryFirst,
          prefixIcon: Icons.map_outlined,
          onTap: form.selectedCountry == null || locked
              ? null
              : () async {
                  final s = await FigmaPlacePicker.state<RegistrationState>(
                    context,
                    items: form.states,
                    labelOf: (s) => s.provinceName,
                  );
                  if (s == null) return;
                  form.selectState(s);
                  society.reset();
                },
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.cityLabel,
          value: form.selectedCity,
          hint: form.selectedState != null
              ? KycStrings.cityHint
              : KycStrings.selectStateFirst,
          prefixIcon: Icons.location_city_outlined,
          onTap: form.selectedState == null || locked
              ? null
              : () async {
                  final c = await FigmaPlacePicker.city<String>(
                    context,
                    items: form.cities,
                    labelOf: (c) => c,
                    subtitle: [
                      form.selectedState?.provinceName,
                      form.selectedCountry?.name,
                    ].whereType<String>().join(', '),
                  );
                  if (c == null) return;
                  form.selectCity(c);
                  society.reset();
                },
        ),
      ],
    );
  }
}

class _PropertySection extends StatelessWidget {
  const _PropertySection();

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();
    final society = context.watch<SocietyDetailsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FigmaSectionLabel(KycStrings.sectionPropertyDetails),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.societyLabel,
          value: form.selectedSociety?.societyName,
          hint: form.selectedCity != null
              ? KycStrings.societyHint
              : KycStrings.selectCityFirst,
          onTap: form.selectedCity == null
              ? null
              : () async {
                  final s = await _pick<RegistrationSociety>(
                    context,
                    title: 'Select ${KycStrings.societyLabel}',
                    items: form.societies,
                    selected: form.selectedSociety,
                    labelOf: (s) => s.societyName,
                    subtitleOf: (s) => s.subtitle,
                    searchHint: 'Search society',
                  );
                  if (s == null || !context.mounted) return;
                  form.selectSociety(s);
                  await society.fetchSociety(s.socId);
                },
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.towerLabel,
          value: society.selectedTower?.towerName,
          hint: society.isTowerEnabled
              ? KycStrings.towerHint
              : KycStrings.selectSocietyFirst,
          isLoading: society.isLoading,
          onTap: society.isTowerEnabled
              ? () async {
                  final t = await _pick<SocietyTower>(
                    context,
                    title: 'Select ${KycStrings.towerLabel}',
                    items: society.towers,
                    selected: society.selectedTower,
                    labelOf: (t) => t.towerName,
                    subtitleOf: (t) => t.towerCode,
                    searchHint: 'Search tower',
                  );
                  if (t != null) society.selectTower(t);
                }
              : null,
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.floorLabel,
          value: society.selectedFloor?.floorName,
          hint: society.isFloorEnabled
              ? KycStrings.floorHint
              : KycStrings.selectTowerFirst,
          onTap: society.isFloorEnabled
              ? () async {
                  final f = await _pick<SocietyFloor>(
                    context,
                    title: 'Select ${KycStrings.floorLabel}',
                    items: society.floors,
                    selected: society.selectedFloor,
                    labelOf: (f) => f.floorName,
                    searchHint: 'Search floor',
                  );
                  if (f != null) society.selectFloor(f);
                }
              : null,
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.unitLabel,
          value: society.selectedUnit?.unitNumber,
          hint: society.isUnitEnabled
              ? KycStrings.unitHint
              : KycStrings.selectFloorFirst,
          onTap: society.isUnitEnabled
              ? () async {
                  final u = await _pick<SocietyUnit>(
                    context,
                    title: 'Select ${KycStrings.unitLabel}',
                    items: society.units,
                    selected: society.selectedUnit,
                    labelOf: (u) => u.unitNumber,
                    subtitleOf: (u) => u.unitTypeBhk,
                    searchHint: 'Search unit',
                  );
                  if (u != null) society.selectUnit(u);
                }
              : null,
        ),
      ],
    );
  }
}

/// Final Add Property step: Owner / Tenant, sub-role, category and document,
/// then the move-in rules. Uses the same `AddPropertyProvider` selections as
/// the old Role card; [onSubmit] runs the unchanged validation and request.
class _RoleStepPage extends StatelessWidget {
  const _RoleStepPage({required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();
    final roleSelected = form.selectedRole != null;

    return KycResidenceRoleScreen(
      title: 'Add Flat/Villa/Office',
      showProgress: false,
      continueLabel: 'Add Property',
      isSubmitting: form.isSubmitting,
      selectedRoleId: form.selectedRole?.roleId,
      roles: [for (final role in form.roles) residenceRoleChoice(role)],
      onRoleChanged: (id) =>
          form.selectRole(form.roles.firstWhere((r) => r.roleId == id)),
      dropdowns: [
        ResidenceRoleDropdown(
          label: KycStrings.subRoleLabel,
          hint: roleSelected
              ? KycStrings.subRoleHint
              : KycStrings.selectRoleFirst,
          value: form.selectedSubRole?.description,
          items: [for (final s in form.subRoles) s.description],
          enabled: roleSelected,
          onChanged: (i) => form.selectSubRole(form.subRoles[i]),
        ),
        if (form.needsCategory)
          ResidenceRoleDropdown(
            label: KycStrings.categoryLabel,
            hint: KycStrings.categoryHint,
            value: form.selectedCategory?.description,
            items: [for (final c in form.categories) c.description],
            onChanged: (i) => form.selectCategory(form.categories[i]),
          ),
        if (form.documents.isNotEmpty)
          ResidenceRoleDropdown(
            label: 'Document',
            hint: 'Select document',
            value: form.selectedDocument?.name,
            items: [for (final d in form.documents) d.name],
            onChanged: (i) => form.selectDocument(form.documents[i]),
          ),
      ],
      onContinue: () => onSubmit(),
    );
  }
}
