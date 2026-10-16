import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/providers/society/add_property_provider.dart';
import 'package:flutter_nivasshub/providers/society/society_details_provider.dart';
import 'package:flutter_nivasshub/services/society/add_society_service.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
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

class _AddPropertyView extends StatelessWidget {
  const _AddPropertyView();

  Future<void> _submit(BuildContext context) async {
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
    if (!context.mounted) return;

    if (ok) {
      CustomSnackbar.success(context, form.resultMessage ?? '');
      Navigator.of(context).pop(true);
    } else {
      CustomSnackbar.error(context, form.errorMessage ?? KycStrings.genericError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();
    final t = FigmaColors.of(context);

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
          _ => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pick the property you want to add. It will be pending '
                  'approval once submitted.',
                  style: AppTextStyles.bodyMedium.copyWith(color: t.body),
                ),
                const SizedBox(height: 16),
                const FigmaCard(child: _LocationSection()),
                const SizedBox(height: 16),
                const FigmaCard(child: _PropertySection()),
                const SizedBox(height: 16),
                const FigmaCard(child: _RoleSection()),
                const SizedBox(height: 24),
                FigmaButton(
                  label: 'Add Property',
                  navy: true,
                  isLoading: form.isSubmitting,
                  onPressed: form.isSubmitting ? null : () => _submit(context),
                ),
              ],
            ),
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
  const _LocationSection();

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
          onTap: () async {
            final c = await _pick<RegistrationCountry>(
              context,
              title: 'Select Country',
              items: form.countries,
              selected: form.selectedCountry,
              labelOf: (c) => c.name,
              searchHint: 'Search country',
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
          onTap: form.selectedCountry == null
              ? null
              : () async {
                  final s = await _pick<RegistrationState>(
                    context,
                    title: 'Select ${KycStrings.stateLabel}',
                    items: form.states,
                    selected: form.selectedState,
                    labelOf: (s) => s.provinceName,
                    searchHint: 'Search state',
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
          onTap: form.selectedState == null
              ? null
              : () async {
                  final c = await _pick<String>(
                    context,
                    title: 'Select ${KycStrings.cityLabel}',
                    items: form.cities,
                    selected: form.selectedCity,
                    labelOf: (c) => c,
                    searchHint: 'Search city',
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

class _RoleSection extends StatelessWidget {
  const _RoleSection();

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddPropertyProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FigmaSectionLabel(KycStrings.sectionRole),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.roleLabel,
          value: form.selectedRole?.description,
          hint: KycStrings.roleHint,
          onTap: () async {
            final r = await _pick<RegistrationRole>(
              context,
              title: 'Select ${KycStrings.roleLabel}',
              items: form.roles,
              selected: form.selectedRole,
              labelOf: (r) => r.description,
            );
            if (r != null) form.selectRole(r);
          },
        ),
        AppSpacing.gapMd,
        SelectionField(
          label: KycStrings.subRoleLabel,
          value: form.selectedSubRole?.description,
          hint: form.selectedRole != null
              ? KycStrings.subRoleHint
              : KycStrings.selectRoleFirst,
          onTap: form.selectedRole == null
              ? null
              : () async {
                  final s = await _pick<RegistrationSubRole>(
                    context,
                    title: 'Select ${KycStrings.subRoleLabel}',
                    items: form.subRoles,
                    selected: form.selectedSubRole,
                    labelOf: (s) => s.description,
                  );
                  if (s != null) form.selectSubRole(s);
                },
        ),
        if (form.needsCategory) ...[
          AppSpacing.gapMd,
          SelectionField(
            label: KycStrings.categoryLabel,
            value: form.selectedCategory?.description,
            hint: KycStrings.categoryHint,
            onTap: () async {
              final c = await _pick<RegistrationCategory>(
                context,
                title: 'Select ${KycStrings.categoryLabel}',
                items: form.categories,
                selected: form.selectedCategory,
                labelOf: (c) => c.description,
              );
              if (c != null) form.selectCategory(c);
            },
          ),
        ],
        if (form.documents.isNotEmpty) ...[
          AppSpacing.gapMd,
          SelectionField(
            label: 'Document',
            value: form.selectedDocument?.name,
            hint: 'Select document',
            onTap: () async {
              final d = await _pick<RegistrationKycDocument>(
                context,
                title: 'Select Document',
                items: form.documents,
                selected: form.selectedDocument,
                labelOf: (d) => d.name,
              );
              if (d != null) form.selectDocument(d);
            },
          ),
        ],
      ],
    );
  }
}
