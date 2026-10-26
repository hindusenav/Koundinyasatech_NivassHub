import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/providers/pet/pet_provider.dart';
import 'package:flutter_nivasshub/widgets/household/household_sheet_frame.dart';

/// Opens the Add Pet bottom sheet. Returns true if a pet was added.
Future<bool?> showAddPetSheet(BuildContext context) {
  final provider = context.read<PetProvider>();
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
  static const _types = ['Dog', 'Cat', 'Bird', 'Fish', 'Other'];

  final _name = TextEditingController();
  final _breed = TextEditingController();
  String _type = _types.first;

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = await context.read<PetProvider>().addPet(
      name: _name.text,
      type: _type,
      breed: _breed.text,
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
    return HouseholdSheetFrame(
      title: 'Add Pet',
      actionLabel: 'Add',
      onAction: _submit,
      isBusy: provider.isSaving,
      error: provider.saveError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in _types)
                ChoiceChip(
                  label: Text(t),
                  selected: _type == t,
                  showCheckmark: false,
                  selectedColor: FigmaColors.accentBlue.withValues(alpha: 0.14),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: _type == t
                        ? FigmaColors.accentBlue
                        : const Color(0xFFE8DCC8),
                  ),
                  labelStyle: TextStyle(
                    color: _type == t ? FigmaColors.accentBlue : FigmaColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _type = t),
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
          TextField(
            controller: _breed,
            textCapitalization: TextCapitalization.words,
            decoration: householdFieldDecoration('Breed (optional)'),
          ),
        ],
      ),
    );
  }
}
