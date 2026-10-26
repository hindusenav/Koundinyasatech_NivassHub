import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/models/family/family_relation.dart';
import 'package:flutter_nivasshub/providers/family/family_provider.dart';
import 'package:flutter_nivasshub/widgets/household/household_sheet_frame.dart';

/// Opens the Add Family bottom sheet. Returns true if a member was added.
Future<bool?> showAddFamilySheet(BuildContext context) {
  final provider = context.read<FamilyProvider>();
  provider.load();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider<FamilyProvider>.value(
      value: provider,
      child: const _AddFamilySheet(),
    ),
  );
}

class _AddFamilySheet extends StatefulWidget {
  const _AddFamilySheet();

  @override
  State<_AddFamilySheet> createState() => _AddFamilySheetState();
}

class _AddFamilySheetState extends State<_AddFamilySheet> {
  static const _kidRelations = {'Son', 'Daughter', 'Brother', 'Sister'};

  final _name = TextEditingController();
  final _mobile = TextEditingController();
  bool _isKid = false;
  String? _relation;

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<FamilyProvider>();
    final result = await provider.addMember(
      name: _name.text,
      mobile: _mobile.text,
      relation: _relation ?? '',
    );
    if (!mounted || result == null) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop(true);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FamilyProvider>();
    return HouseholdSheetFrame(
      title: 'Add Family',
      actionLabel: 'Add',
      onAction: _submit,
      isBusy: provider.isSaving,
      error: provider.saveError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AdultKidTabs(
            isKid: _isKid,
            onChanged: (kid) => setState(() {
              _isKid = kid;
              _relation = null;
            }),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: (_) => provider.clearSaveError(),
            decoration: householdFieldDecoration('Name'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8DCC8)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('+91', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _mobile,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => provider.clearSaveError(),
                  decoration: householdFieldDecoration('Mobile Number'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Relation',
            style: TextStyle(
              color: FigmaColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _RelationPicker(
            provider: provider,
            isKid: _isKid,
            kidRelations: _kidRelations,
            selected: _relation,
            onSelected: (name) => setState(() => _relation = name),
          ),
        ],
      ),
    );
  }
}

class _AdultKidTabs extends StatelessWidget {
  const _AdultKidTabs({required this.isKid, required this.onChanged});

  final bool isKid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, bool kid) {
      final active = kid == isKid;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onChanged(kid),
          child: Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? FigmaColors.navy : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : FigmaColors.navy,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [tab('Adult', false), tab('Kid', true)]),
    );
  }
}

class _RelationPicker extends StatelessWidget {
  const _RelationPicker({
    required this.provider,
    required this.isKid,
    required this.kidRelations,
    required this.selected,
    required this.onSelected,
  });

  final FamilyProvider provider;
  final bool isKid;
  final Set<String> kidRelations;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    switch (provider.state) {
      case FamilyLoadState.initial:
      case FamilyLoadState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: FigmaColors.accentBlue,
            ),
          ),
        );
      case FamilyLoadState.error:
        return Row(
          children: [
            Expanded(
              child: Text(
                provider.errorMessage ?? 'Unable to load relations.',
                style: const TextStyle(color: Color(0xFFD92D20), fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: () => provider.load(force: true),
              child: const Text(
                'Retry',
                style: TextStyle(color: FigmaColors.orange),
              ),
            ),
          ],
        );
      case FamilyLoadState.ready:
        final categories = _visibleCategories();
        if (categories.isEmpty) {
          return const Text(
            'No relations available.',
            style: TextStyle(color: Color(0xFF8A7658)),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final category in categories) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  category.categoryName,
                  style: const TextStyle(
                    color: Color(0xFF8A7658),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in category.relations)
                    _RelationChip(
                      key: ValueKey(r.relationId),
                      label: r.relationName,
                      selected: selected == r.relationName,
                      onTap: () => onSelected(r.relationName),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ],
        );
    }
  }

  List<FamilyRelationCategory> _visibleCategories() {
    final result = <FamilyRelationCategory>[];
    for (final c in provider.relations.categories) {
      final relations = isKid
          ? c.relations.where((r) => kidRelations.contains(r.relationName))
          : c.relations;
      final list = relations.toList();
      if (list.isEmpty) continue;
      result.add(
        FamilyRelationCategory(
          categoryId: c.categoryId,
          categoryName: c.categoryName,
          relations: list,
        ),
      );
    }
    return result;
  }
}

class _RelationChip extends StatelessWidget {
  const _RelationChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? FigmaColors.accentBlue.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? FigmaColors.accentBlue : const Color(0xFFE8DCC8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? FigmaColors.accentBlue : FigmaColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
