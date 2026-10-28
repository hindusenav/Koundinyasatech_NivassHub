import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/models/family/add_family.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/models/vehicle/add_vehicle.dart';
import 'package:flutter_nivasshub/providers/family/family_provider.dart';
import 'package:flutter_nivasshub/providers/pet/pet_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/services/family/family_service.dart';
import 'package:flutter_nivasshub/services/pet/pet_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/widgets/household/add_family_sheet.dart';
import 'package:flutter_nivasshub/widgets/household/add_pet_sheet.dart';

const _tint = AppColors.accentTint;
const _blue = AppColors.primaryOrange;
const _muted = AppColors.textMuted;

/// Owns the Family/Pet providers for everything below it. Wrap the screen
/// (not the scrolling list) so state survives scrolling.
class HouseholdScope extends StatelessWidget {
  const HouseholdScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FamilyProvider>(
          // No eager load: `showAddFamilySheet` calls `load()` on tap.
          create: (c) =>
              FamilyProvider(service: FamilyService(c.read<ApiClient>())),
        ),
        ChangeNotifierProvider<PetProvider>(
          // No eager load: `showAddPetSheet` loads the reference data on tap.
          create: (c) => PetProvider(
            service: PetService(c.read<ApiClient>()),
            readToken: c.read<SecureStorageService>().getAccessToken,
          ),
        ),
      ],
      child: child,
    );
  }
}

/// Family, Pets, Vehicles and Daily Help — embedded in the Settings screen.
/// Requires a [HouseholdScope] above it.
class HouseholdSections extends StatefulWidget {
  const HouseholdSections({super.key});

  @override
  State<HouseholdSections> createState() => _HouseholdSectionsState();
}

class _HouseholdSectionsState extends State<HouseholdSections> {
  final List<AddVehicleResult> _vehicles = [];

  Future<void> _addVehicle() async {
    final added = await Navigator.of(context).pushNamed(AppRoutes.vehicles);
    if (added is AddVehicleResult && mounted) {
      setState(() => _vehicles.add(added));
    }
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Daily Help is coming soon')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'My Family',
          onAdd: () => showAddFamilySheet(context),
        ),
        const SizedBox(height: 10),
        Selector<FamilyProvider, List<FamilyMember>>(
          selector: (_, p) => p.members,
          builder: (context, members, _) => _Tiles(
            tiles: [
              for (final m in members)
                _Tile(
                  name: m.name,
                  subtitle: m.relationship,
                  detail: m.maskedMobile,
                ),
            ],
            onAdd: () => showAddFamilySheet(context),
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'My Pets',
          onAdd: () => showAddPetSheet(context),
        ),
        const SizedBox(height: 10),
        Selector<PetProvider, List<Pet>>(
          selector: (_, p) => p.pets,
          builder: (context, pets, _) {
            if (pets.isEmpty) {
              return _EmptyPrompt(
                icon: Icons.pets_outlined,
                message:
                    'Create a paw-some profile and meet other pet parents '
                    'in your society',
                actionLabel: 'Add Pet',
                onTap: () => showAddPetSheet(context),
              );
            }
            return _Tiles(
              tiles: [
                for (final p in pets)
                  _Tile(
                    icon: Icons.pets_outlined,
                    name: p.name,
                    subtitle: p.type,
                    detail: p.breed,
                  ),
              ],
              onAdd: () => showAddPetSheet(context),
            );
          },
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'My Vehicles', onAdd: _addVehicle),
        const SizedBox(height: 10),
        _vehicles.isEmpty
            ? _EmptyPrompt(
                icon: Icons.directions_car_outlined,
                message: 'Register your bike or car to get a parking slot',
                actionLabel: 'Add Vehicle',
                onTap: _addVehicle,
              )
            : _Tiles(
                tiles: [
                  for (final v in _vehicles)
                    _Tile(
                      icon: Icons.directions_car_outlined,
                      name: v.registrationNumber,
                      subtitle: v.zoneName.isNotEmpty ? v.zoneName : 'Parking',
                      detail: v.slotNumber.isNotEmpty
                          ? 'Slot ${v.slotNumber}'
                          : '',
                    ),
                ],
                onAdd: _addVehicle,
              ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'My Daily Help', onAdd: _comingSoon),
        const SizedBox(height: 10),
        _EmptyPrompt(
          icon: Icons.person_add_alt_1_outlined,
          message: 'Add your maid, cook or driver for quick entry approvals',
          actionLabel: 'Add Daily Help',
          onTap: _comingSoon,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 16, color: AppColors.primaryOrange),
          label: const Text(
            'Add',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _Tiles extends StatelessWidget {
  const _Tiles({required this.tiles, required this.onAdd});

  final List<Widget> tiles;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    // Swipe left/right through the cards; the scrollbar is hidden and the
    // shadows are not clipped at the list edge.
    return SizedBox(
      height: context.rt(148),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false, overscroll: false),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: tiles.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, i) =>
              i < tiles.length ? tiles[i] : _AddTile(onTap: onAdd),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.name,
    required this.subtitle,
    this.detail = '',
    this.icon = Icons.groups_2_outlined,
  });

  final String name;
  final String subtitle;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.rt(138),
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Accent strip in the theme colour.
          Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, Color(0xFFFFB45E)],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _tint,
                      border: Border.all(color: _blue.withValues(alpha: 0.35)),
                    ),
                    child: Icon(icon, color: _blue, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name.isEmpty ? '—' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _tint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (detail.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: CustomPaint(
          painter: _DashedRRectPainter(),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: _blue, size: 28),
                SizedBox(height: 4),
                Text(
                  "Add",
                  style: TextStyle(
                    color: _blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _tint,
                border: Border.all(color: _blue.withValues(alpha: 0.4)),
              ),
              child: Icon(icon, color: _blue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '+ $actionLabel',
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.cardBg,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: AppColors.cardBorder),
  boxShadow: const [
    BoxShadow(color: AppColors.shadowSoft, blurRadius: 10, offset: Offset(0, 3)),
  ],
);

class _DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _blue.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20)),
      );
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
