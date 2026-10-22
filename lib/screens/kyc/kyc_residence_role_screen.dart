import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/widgets/kyc/move_in_rules_dialog.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Society move-in rules shown by the "I Agree to Move-in Rules" dialog.
const List<String> kDefaultMoveInRules = [
  'Usage of Lifts is Restricted while shifting heavy items/Furniture',
  'Do not litter garbage in corridors, staircase, lifts and any common '
      'area. Dump you garbage in designated garbage area.',
  'Submit all the required Documents before Moving In (ID Proof, NOC, '
      'Sales/Rental agreement)',
];

/// One Owner / Tenant style card.
class ResidenceRoleChoice {
  const ResidenceRoleChoice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

/// Maps an API role onto an Owner / Tenant style card.
ResidenceRoleChoice residenceRoleChoice(RegistrationRole role) {
  return ResidenceRoleChoice(
    id: role.roleId,
    title: role.userRole?.label ?? role.description,
    subtitle: role.userRole?.description ?? '',
    icon: switch (role.userRole) {
      UserRole.owner => Icons.home_outlined,
      UserRole.tenant => Icons.vpn_key_outlined,
      null => Icons.person_outline,
    },
  );
}

/// One dropdown under the role cards (sub-role, category, …).
class ResidenceRoleDropdown {
  const ResidenceRoleDropdown({
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final String? value;
  final List<String> items;

  /// Receives the index into [items].
  final ValueChanged<int> onChanged;
  final bool enabled;
}

/// Figma "Choose Residence Role": progress strip, Owner/Tenant cards,
/// dropdowns, the move-in rules agreement and a Continue button.
///
/// Presentation only. The role cards and dropdowns are supplied by the
/// caller (registration and Add Property each feed their own provider
/// data), the screen reports taps through callbacks, and [onContinue]
/// fires once the move-in rules have been agreed. Whatever validation or
/// submission follows stays with the caller.
class KycResidenceRoleScreen extends StatefulWidget {
  const KycResidenceRoleScreen({
    super.key,
    required this.roles,
    required this.selectedRoleId,
    required this.onRoleChanged,
    required this.onContinue,
    this.dropdowns = const [],
    this.moveInRules = kDefaultMoveInRules,
    this.isLoading = false,
    this.isSubmitting = false,
    this.showProgress = true,
    this.currentStep = 1,
    this.totalSteps = 3,
    this.title = 'Complete Your Profile',
    this.continueLabel = 'Continue',
    this.extra,
  });

  final List<ResidenceRoleChoice> roles;
  final String? selectedRoleId;
  final ValueChanged<String> onRoleChanged;
  final List<ResidenceRoleDropdown> dropdowns;
  final List<String> moveInRules;
  final VoidCallback onContinue;

  /// Role options are still being fetched.
  final bool isLoading;
  final bool isSubmitting;
  final bool showProgress;
  final int currentStep;
  final int totalSteps;
  final String title;
  final String continueLabel;

  /// Optional extra widget placed above the rules checkbox.
  final Widget? extra;

  @override
  State<KycResidenceRoleScreen> createState() => _KycResidenceRoleScreenState();
}

class _KycResidenceRoleScreenState extends State<KycResidenceRoleScreen> {
  bool _agreed = false;

  Future<void> _openRules() async {
    final agreed = await MoveInRulesDialog.show(
      context,
      rules: widget.moveInRules,
    );
    if (agreed == true && mounted) setState(() => _agreed = true);
  }

  void _continue() {
    if (!_agreed) {
      CustomSnackbar.warning(
        context,
        'Please agree to the Move-in Rules to continue.',
      );
      return;
    }
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);

    return FigmaHeaderScaffold(
      title: widget.title,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showProgress) ...[
                FigmaProgressStrip(
                  label: 'Onboarding Progress',
                  current: widget.currentStep,
                  total: widget.totalSteps,
                ),
                const SizedBox(height: 20),
              ],
              Text(
                'Choose Residence Role',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: t.heading,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Are you a property Owner or a Tenant in this community?',
                style: TextStyle(fontSize: 14, color: t.heading),
              ),
              const SizedBox(height: 24),
              if (widget.isLoading && widget.roles.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                _RoleGrid(
                  roles: widget.roles,
                  selectedId: widget.selectedRoleId,
                  onChanged: widget.onRoleChanged,
                ),
              for (final dropdown in widget.dropdowns) ...[
                const SizedBox(height: 18),
                _FieldLabel(dropdown.label),
                _Dropdown(spec: dropdown),
              ],
              if (widget.extra != null) ...[
                const SizedBox(height: 14),
                widget.extra!,
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreed,
                      activeColor: FigmaColors.orange,
                      onChanged: (v) {
                        if (v == true) {
                          _openRules();
                        } else {
                          setState(() => _agreed = false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _openRules,
                    child: Text(
                      'I Agree to Move-in Rules',
                      style: TextStyle(
                        fontSize: 14,
                        color: t.heading,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FigmaButton(
                label: widget.continueLabel,
                navy: true,
                isLoading: widget.isSubmitting,
                onPressed: widget.isSubmitting ? null : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleGrid extends StatelessWidget {
  const _RoleGrid({
    required this.roles,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ResidenceRoleChoice> roles;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // Two cards per row, as in the Figma; a third role simply wraps.
    final rows = <Widget>[];
    for (var i = 0; i < roles.length; i += 2) {
      final pair = roles.skip(i).take(2).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < 2; j++) ...[
                  if (j == 1) const SizedBox(width: 12),
                  Expanded(
                    child: j < pair.length
                        ? _RoleCard(
                            choice: pair[j],
                            selected: pair[j].id == selectedId,
                            onTap: () => onChanged(pair[j].id),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: FigmaColors.of(context).heading,
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.spec});

  final ResidenceRoleDropdown spec;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final value = spec.items.contains(spec.value) ? spec.value : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: spec.enabled ? t.card : t.field,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.fieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(spec.hint, style: TextStyle(fontSize: 14, color: t.body)),
          dropdownColor: t.card,
          icon: Icon(Icons.keyboard_arrow_down, color: t.body),
          style: TextStyle(fontSize: 14, color: t.heading),
          items: [
            for (final i in spec.items)
              DropdownMenuItem(value: i, child: Text(i)),
          ],
          onChanged: spec.enabled
              ? (v) {
                  if (v == null) return;
                  spec.onChanged(spec.items.indexOf(v));
                }
              : null,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final ResidenceRoleChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    const teal = Color(0xFF12A28F);
    final accent = selected ? teal : t.fieldBorder;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent, width: selected ? 2 : 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? FigmaColors.orange.withValues(alpha: 0.12)
                    : t.fieldBorder.withValues(alpha: 0.5),
              ),
              child: Icon(
                choice.icon,
                size: 22,
                color: selected ? FigmaColors.orange : t.heading,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              choice.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: t.heading,
              ),
            ),
            const SizedBox(height: 2),
            Text(choice.subtitle, style: TextStyle(fontSize: 12, color: t.body)),
          ],
        ),
      ),
    );
  }
}
