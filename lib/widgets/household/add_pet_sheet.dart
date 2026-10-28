import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/providers/pet/pet_provider.dart';
import 'package:flutter_nivasshub/screens/camera/app_camera.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/widgets/household/household_sheet_frame.dart';

/// Opens the Add Pet bottom sheet. Returns true if a pet was added.
Future<bool?> showAddPetSheet(BuildContext context) {
  final provider = context.read<PetProvider>();
  // Loaded on tap, not on screen open. Refetched on every open so the
  // pet types/breeds (and their ids) are never stale; no-op if in flight.
  provider.loadReferenceData(force: true);
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider<PetProvider>.value(
      value: provider,
      child: const _AddPetSheet(),
    ),
  );
}

class _AddPetSheet extends StatefulWidget {
  const _AddPetSheet();

  @override
  State<_AddPetSheet> createState() => _AddPetSheetState();
}

class _AddPetSheetState extends State<_AddPetSheet> {
  /// Used only while the API list is unavailable (loading failed/empty), so
  /// the form is never blocked.
  static const _fallbackTypes = ['Dog', 'Cat', 'Bird', 'Fish', 'Other'];

  static const _photoExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const _maxPhotoBytes = 5 * 1024 * 1024;

  final _name = TextEditingController();
  final _colour = TextEditingController();
  final _breedText = TextEditingController();
  String? _type;
  String? _breed;
  PickedFile? _photo;
  String? _photoError;
  String _vaccinated = 'NO';
  DateTime? _vaccinationDate;

  @override
  void dispose() {
    _name.dispose();
    _colour.dispose();
    _breedText.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto() async {
    final source = await showModalBottomSheet<FilePickSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, FilePickSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, FilePickSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    if (source == FilePickSource.camera) {
      final shot = await AppCamera.capture(context);
      if (shot == null || !mounted) return;
      setState(() {
        if (shot.sizeBytes >= _maxPhotoBytes) {
          _photoError = 'Photo must be smaller than 5 MB.';
        } else {
          _photo = shot;
          _photoError = null;
        }
      });
      return;
    }
    final result = await context.read<FilePickerServiceBase>().pick(
      source: source,
      allowedExtensions: _photoExtensions,
      maxSizeBytes: _maxPhotoBytes,
    );
    if (!mounted) return;
    final file = result.data;
    setState(() {
      if (!result.isSuccess) {
        _photoError = result.message ?? 'Unable to pick the photo.';
      } else if (file != null) {
        _photo = file;
        _photoError = null;
      }
    });
  }

  Future<void> _pickVaccinationDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _vaccinationDate ?? now,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && mounted) setState(() => _vaccinationDate = picked);
  }

  List<String> _typeNames(PetProvider provider) {
    final fromApi = [for (final t in provider.petTypes) t.petType];
    return fromApi.isNotEmpty ? fromApi : _fallbackTypes;
  }

  /// The selected type, or the first available one if nothing valid is
  /// selected yet (e.g. the API list arrived after the sheet opened).
  String _effectiveType(List<String> types) =>
      _type != null && types.contains(_type) ? _type! : types.first;

  Future<void> _submit(PetProvider provider) async {
    FocusScope.of(context).unfocus();
    final type = _effectiveType(_typeNames(provider));
    final breeds = provider.breedsFor(type);
    final breed = breeds.isNotEmpty ? (_breed ?? '') : _breedText.text;

    final ok = await provider.addPet(
      name: _name.text,
      type: type,
      breed: breed,
      colour: _colour.text,
      picturePath: _photo?.path,
      vaccinationStatus: _vaccinated,
      vaccinationDate: _vaccinated == 'V' ? _vaccinationDate : null,
    );
    if (!mounted || !ok) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop(true);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Pet added successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    final types = _typeNames(provider);
    final type = _effectiveType(types);
    final breeds = provider.breedsFor(type);
    final selectedBreed = breeds.contains(_breed) ? _breed : null;

    return HouseholdSheetFrame(
      title: 'Add Pet',
      actionLabel: 'Add',
      onAction: () => _submit(provider),
      isBusy: provider.isSaving,
      error: provider.saveError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.isLoadingReference)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: LinearProgressIndicator(
                minHeight: 3,
                color: AppColors.primaryOrange,
                backgroundColor: AppColors.accentTint,
              ),
            ),
          if (provider.referenceState == PetReferenceState.error)
            _ReferenceError(
              message: provider.referenceError ?? 'Unable to load pet types.',
              onRetry: () => provider.loadReferenceData(force: true),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in types)
                ChoiceChip(
                  label: Text(t),
                  selected: type == t,
                  showCheckmark: false,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  selectedColor: AppColors.primaryOrange.withValues(
                    alpha: 0.14,
                  ),
                  backgroundColor: AppColors.cardBg,
                  side: BorderSide(
                    color: type == t
                        ? AppColors.primaryOrange
                        : AppColors.cardBorder,
                  ),
                  labelStyle: TextStyle(
                    color: type == t
                        ? AppColors.primaryOrange
                        : AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() {
                    _type = t;
                    _breed = null;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: (_) => provider.clearSaveError(),
            decoration: householdFieldDecoration('Pet name'),
          ),
          const SizedBox(height: 12),
          if (breeds.isNotEmpty)
            DropdownButtonFormField<String>(
              initialValue: selectedBreed,
              isExpanded: true,
              dropdownColor: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              iconEnabledColor: AppColors.primaryOrange,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              items: [
                for (final b in breeds)
                  DropdownMenuItem(
                    value: b,
                    child: Text(b, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _breed = v),
              decoration: householdFieldDecoration('Breed'),
            )
          else
            TextField(
              controller: _breedText,
              textCapitalization: TextCapitalization.words,
              decoration: householdFieldDecoration('Breed'),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _colour,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onChanged: (_) => provider.clearSaveError(),
            decoration: householdFieldDecoration('Colour'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: provider.isSaving ? null : _choosePhoto,
            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
            label: Text(
              _photo == null ? 'Add pet photo' : _photo!.fileName,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
              side: const BorderSide(color: AppColors.cardBorder),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (_photoError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _photoError!,
                style: const TextStyle(color: AppColors.error, fontSize: 12.5),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Vaccinated?',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final v in const {'V': 'Yes', 'NO': 'No'}.entries)
                ChoiceChip(
                  label: Text(v.value),
                  selected: _vaccinated == v.key,
                  showCheckmark: false,
                  selectedColor: AppColors.primaryOrange.withValues(
                    alpha: 0.14,
                  ),
                  onSelected: (_) => setState(() => _vaccinated = v.key),
                ),
            ],
          ),
          if (_vaccinated == 'V') ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickVaccinationDate,
              icon: const Icon(Icons.event_outlined, size: 18),
              label: Text(
                _vaccinationDate == null
                    ? 'Vaccination date'
                    : '${_vaccinationDate!.day.toString().padLeft(2, '0')}/'
                          '${_vaccinationDate!.month.toString().padLeft(2, '0')}/'
                          '${_vaccinationDate!.year}',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryOrange,
                side: const BorderSide(color: AppColors.cardBorder),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReferenceError extends StatelessWidget {
  const _ReferenceError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 12.5),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
