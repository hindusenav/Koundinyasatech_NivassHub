import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/models/vehicle/add_vehicle.dart';
import 'package:flutter_nivasshub/models/vehicle/vehicle_brand.dart';
import 'package:flutter_nivasshub/providers/vehicle/vehicle_provider.dart';
import 'package:flutter_nivasshub/services/vehicle/vehicle_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:provider/provider.dart';

const Color _primaryBlue = Color(0xFFFF8A00);
const Color _lightBlue = Color(0xFFFBF1E5);
const Color _headerBlue = Color(0xFFF3E8D9);
const Color _background = Color(0xFFF3E8D9);
const Color _orange = Color(0xFFE88700);
const Color _textDark = Color(0xFF263747);
const Color _textGrey = Color(0xFF6F7C89);

/// Lists vehicle brands from `GET /vehicle-brands` (Two / Four wheeler), then
/// registers the chosen one via `POST /vehicle/add` and confirms with a
/// success popup. Pops with `true` once a vehicle was added. Owns its
/// provider, so nothing about it is global.
class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleProvider(
        service: VehicleService(context.read<ApiClient>()),
        readToken: context.read<SecureStorageService>().getAccessToken,
      )..load(),
      child: const _VehiclesView(),
    );
  }
}

class _VehiclesView extends StatelessWidget {
  const _VehiclesView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: _background,
      body: Column(
        children: [
          _Header(onBack: () => Navigator.of(context).maybePop()),
          Expanded(child: _body(context, provider)),
          _ContinueBar(provider: provider),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, VehicleProvider provider) {
    switch (provider.state) {
      case VehicleState.initial:
      case VehicleState.loading:
        return const Center(
          child: CircularProgressIndicator(color: _primaryBlue),
        );
      case VehicleState.error:
        return _Message(
          icon: Icons.cloud_off_rounded,
          title: 'Could not load vehicles',
          subtitle: provider.errorMessage ?? 'Please try again.',
          actionLabel: 'Retry',
          onAction: provider.retry,
        );
      case VehicleState.ready:
        return _Content(provider: provider);
    }
  }
}

// ============================================================
// HEADER
// ============================================================

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _headerBlue,
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.of(context).padding.top + 8,
        16,
        14,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: _textDark),
          ),
          const SizedBox(width: 4),
          const Text(
            'My Vehicles',
            style: TextStyle(
              color: _textDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CONTENT
// ============================================================

class _Content extends StatelessWidget {
  const _Content({required this.provider});

  final VehicleProvider provider;

  @override
  Widget build(BuildContext context) {
    final brands = provider.brands;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _HeroCard(data: provider.data),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _TypeToggle(provider: provider),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _SearchField(onChanged: provider.setQuery),
          ),
        ),
        if (brands.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _Message(
              icon: Icons.search_off_rounded,
              title: 'No brands found',
              subtitle: 'Try a different name.',
            ),
          )
        else
          SliverList.builder(
            itemCount: brands.length,
            itemBuilder: (context, i) {
              final brand = brands[i];
              final letter = brand.vehicleBrand.isEmpty
                  ? '#'
                  : brand.vehicleBrand[0].toUpperCase();
              final showLetter =
                  i == 0 ||
                  brands[i - 1].vehicleBrand.isEmpty ||
                  brands[i - 1].vehicleBrand[0].toUpperCase() != letter;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLetter)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 6),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            color: _primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    _BrandTile(
                      brand: brand,
                      selected: provider.selected == brand,
                      onTap: () => provider.select(brand),
                    ),
                  ],
                ),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.data});

  final VehicleBrandsData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8A00), Color(0xFF7A4619)],
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register your ride',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pick your bike or car brand for easy gate and parking access.',
                  style: TextStyle(
                    color: Color(0xFFE8DCC8),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                '${data.totalCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'brands',
                style: TextStyle(color: Color(0xFFE8DCC8), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.provider});

  final VehicleProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8DCC8)),
      ),
      child: Row(
        children: [
          for (final type in VehicleType.values)
            Expanded(
              child: _TogglePill(
                label: type.label,
                count: provider.data.brandsOf(type).length,
                icon: type == VehicleType.twoWheeler
                    ? Icons.two_wheeler_rounded
                    : Icons.directions_car_rounded,
                active: provider.type == type,
                onTap: () => provider.selectType(type),
              ),
            ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.label,
    required this.count,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? _primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: active ? Colors.white : _textGrey),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '$label ($count)',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: active ? Colors.white : _textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: _textDark, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search brand',
        hintStyle: const TextStyle(color: _textGrey, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: _textGrey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8DCC8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primaryBlue, width: 1.4),
        ),
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  final VehicleBrand brand;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = brand.vehicleBrand.isEmpty
        ? '?'
        : brand.vehicleBrand[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? _lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? _primaryBlue : const Color(0xFFE8DCC8),
              width: selected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3E2F1C).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? _primaryBlue : _lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: selected ? Colors.white : _primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.vehicleBrand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      brand.vehicleTypeName,
                      style: const TextStyle(color: _textGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: selected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        key: ValueKey('on'),
                        color: _orange,
                        size: 22,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: ValueKey('off'),
                        color: Color(0xFFE8DCC8),
                        size: 22,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM BAR / MESSAGES
// ============================================================

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.provider});

  final VehicleProvider provider;

  /// Collects the vehicle details; on a successful `POST /vehicle/add` shows
  /// the success popup, then leaves the screen.
  Future<void> _addVehicle(BuildContext context) async {
    final result = await showModalBottomSheet<AddVehicleResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const _VehicleDetailsSheet(),
      ),
    );
    if (result == null || !context.mounted) return;

    await _VehicleAddedDialog.show(context, result);
    if (context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final selected = provider.selected;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3E2F1C).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: selected == null ? null : () => _addVehicle(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            disabledBackgroundColor: const Color(0xFFE8DCC8),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            selected == null ? 'Select a brand' : 'Continue with ${selected.vehicleBrand}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: _lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _primaryBlue, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: _textDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textGrey, fontSize: 12),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAILS SHEET (POST /vehicle/add)
// ============================================================

class _VehicleDetailsSheet extends StatefulWidget {
  const _VehicleDetailsSheet();

  @override
  State<_VehicleDetailsSheet> createState() => _VehicleDetailsSheetState();
}

class _VehicleDetailsSheetState extends State<_VehicleDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _model = TextEditingController();
  final _colour = TextEditingController();
  final _zone = TextEditingController(text: '1');

  @override
  void dispose() {
    _number.dispose();
    _model.dispose();
    _colour.dispose();
    _zone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<VehicleProvider>();

    final result = await provider.addVehicle(
      registrationNumber: _number.text.trim().toUpperCase(),
      model: _model.text.trim(),
      colour: _colour.text.trim(),
      parkingZoneId: int.parse(_zone.text.trim()),
    );
    if (!mounted) return;

    if (result != null) {
      Navigator.of(context).pop(result);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(provider.saveError ?? 'Please try again.')),
        );
    }
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? 'Enter $label' : null;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    final brand = provider.selected;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DCC8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vehicle details',
                    style: TextStyle(
                      color: _textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${brand?.vehicleBrand ?? ''} · ${brand?.vehicleTypeName ?? ''}',
                    style: const TextStyle(color: _textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  _field(
                    controller: _number,
                    label: 'Registration number',
                    capitalization: TextCapitalization.characters,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9 -]')),
                    ],
                    validator: (v) => _required(v, 'registration number'),
                  ),
                  _field(
                    controller: _model,
                    label: 'Model',
                    validator: (v) => _required(v, 'vehicle model'),
                  ),
                  _field(
                    controller: _colour,
                    label: 'Colour',
                    validator: (v) => _required(v, 'vehicle colour'),
                  ),
                  _field(
                    controller: _zone,
                    label: 'Parking zone ID',
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => _required(v, 'parking zone ID'),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: provider.isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: provider.isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Add Vehicle',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.words,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        inputFormatters: formatters,
        validator: validator,
        style: const TextStyle(color: _textDark, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _textGrey, fontSize: 13),
          filled: true,
          fillColor: _background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primaryBlue, width: 1.4),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUCCESS POPUP
// ============================================================

class _VehicleAddedDialog extends StatelessWidget {
  const _VehicleAddedDialog({required this.result});

  final AddVehicleResult result;

  static Future<void> show(BuildContext context, AddVehicleResult result) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _VehicleAddedDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slot = [
      result.slotNumber,
      if (result.slotType.isNotEmpty) '(${result.slotType})',
    ].where((s) => s.isNotEmpty).join(' ');

    final rows = <(String, String)>[
      ('Vehicle', result.registrationNumber),
      ('Parking zone', result.zoneName),
      ('Floor', result.parkingFloor),
      ('Slot', slot),
    ].where((r) => r.$2.trim().isNotEmpty).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE6F6EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E9E5B),
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Success',
              style: TextStyle(
                color: _textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              result.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textGrey, fontSize: 13),
            ),
            if (rows.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    for (final r in rows)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              r.$1,
                              style: const TextStyle(
                                color: _textGrey,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                r.$2,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: _textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
