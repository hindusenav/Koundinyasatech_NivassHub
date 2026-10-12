import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/kyc/move_in_rules_dialog.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

enum ResidenceRole { owner, tenant }

/// The values the user chose on the Residence Role step.
class ResidenceRoleSelection {
  const ResidenceRoleSelection({
    required this.role,
    required this.block,
    required this.occupancyStatus,
    required this.moveInDate,
  });

  final ResidenceRole role;
  final String block;
  final String occupancyStatus;
  final DateTime moveInDate;
}

/// Figma "KYC Step 1": progress strip, Owner/Tenant cards, block and
/// occupancy dropdowns, move-in rules agreement, move-in date, Continue.
///
/// Options and the rules text come from the caller; the screen reports the
/// final choice through [onContinue].
class KycResidenceRoleScreen extends StatefulWidget {
  const KycResidenceRoleScreen({
    super.key,
    required this.blocks,
    required this.occupancyStatuses,
    required this.moveInRules,
    required this.onContinue,
    this.currentStep = 1,
    this.totalSteps = 3,
  });

  final List<String> blocks;
  final List<String> occupancyStatuses;
  final List<String> moveInRules;
  final ValueChanged<ResidenceRoleSelection> onContinue;
  final int currentStep;
  final int totalSteps;

  @override
  State<KycResidenceRoleScreen> createState() => _KycResidenceRoleScreenState();
}

class _KycResidenceRoleScreenState extends State<KycResidenceRoleScreen> {
  ResidenceRole _role = ResidenceRole.owner;
  String? _block;
  String? _occupancy;
  bool _agreed = false;
  DateTime? _moveIn;

  bool get _canContinue => _block != null && _occupancy != null && _agreed && _moveIn != null;

  Future<void> _openRules() async {
    final agreed = await MoveInRulesDialog.show(context, rules: widget.moveInRules);
    if (agreed == true && mounted) setState(() => _agreed = true);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _moveIn ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && mounted) setState(() => _moveIn = picked);
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);

    return FigmaHeaderScaffold(
      title: 'Complete Your Profile',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FigmaProgressStrip(
                label: 'Onboarding Progress',
                current: widget.currentStep,
                total: widget.totalSteps,
              ),
              const SizedBox(height: 20),
              Text(
                'Choose Residence Role',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.heading),
              ),
              const SizedBox(height: 4),
              Text(
                'Are you a property Owner or a Tenant in this community?',
                style: TextStyle(fontSize: 12, color: t.body),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.home_outlined,
                      title: 'Owner',
                      subtitle: 'I own this property',
                      selected: _role == ResidenceRole.owner,
                      onTap: () => setState(() => _role = ResidenceRole.owner),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.vpn_key_outlined,
                      title: 'Tenant',
                      subtitle: 'I rent this property',
                      selected: _role == ResidenceRole.tenant,
                      onTap: () => setState(() => _role = ResidenceRole.tenant),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _FieldLabel('Select Block / Sub-Branch'),
              _Dropdown(
                value: _block,
                hint: 'Select block',
                items: widget.blocks,
                onChanged: (v) => setState(() => _block = v),
              ),
              const SizedBox(height: 14),
              _FieldLabel('Occupancy Status'),
              _Dropdown(
                value: _occupancy,
                hint: 'Select status',
                items: widget.occupancyStatuses,
                onChanged: (v) => setState(() => _occupancy = v),
              ),
              const SizedBox(height: 14),
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
                        fontSize: 12,
                        color: FigmaColors.accentBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _FieldLabel('Move - In Date'),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: _FieldBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _moveIn == null ? 'Select date' : _format(_moveIn!),
                          style: TextStyle(
                            fontSize: 14,
                            color: _moveIn == null ? t.body : t.heading,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today_outlined, size: 18, color: t.body),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FigmaButton(
                label: 'Continue',
                navy: true,
                onPressed: _canContinue
                    ? () => widget.onContinue(
                        ResidenceRoleSelection(
                          role: _role,
                          block: _block!,
                          occupancyStatus: _occupancy!,
                          moveInDate: _moveIn!,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: FigmaColors.of(context).heading,
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.fieldBorder),
      ),
      child: child,
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.fieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(fontSize: 14, color: t.body)),
          dropdownColor: t.card,
          icon: Icon(Icons.keyboard_arrow_down, color: t.body),
          style: TextStyle(fontSize: 14, color: t.heading),
          items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i))],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final accent = selected ? FigmaColors.orange : t.fieldBorder;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent, width: selected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: selected ? FigmaColors.orange : t.body),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.heading),
            ),
            Text(subtitle, style: TextStyle(fontSize: 11, color: t.body)),
          ],
        ),
      ),
    );
  }
}
