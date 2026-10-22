import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/screens/location/select_country_screen.dart';
import 'package:flutter_nivasshub/widgets/location/confirm_city_sheet.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Figma "Select City" + "Confirm City": a grid of popular cities, a list
/// of the rest, and the navy confirm sheet that slides up after a tap.
///
/// The screen owns only the pick-then-confirm interaction; [onConfirmed]
/// fires with the confirmed city so the caller decides where to go next.
class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({
    super.key,
    required this.popular,
    required this.all,
    required this.onConfirmed,
    this.isLoading = false,
  });

  final List<FigmaPlace> popular;
  final List<FigmaPlace> all;
  final ValueChanged<FigmaPlace> onConfirmed;
  final bool isLoading;

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String _query = '';

  List<FigmaPlace> _filter(List<FigmaPlace> items) => _query.isEmpty
      ? items
      : items.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

  Future<void> _pick(FigmaPlace city) async {
    final confirmed = await ConfirmCitySheet.show(context, city: city);
    if (confirmed == true && mounted) widget.onConfirmed(city);
  }

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final popular = _filter(widget.popular);
    final all = _filter(widget.all);

    return FigmaHeaderScaffold(
      title: 'Select City',
      body: widget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                FigmaSearchField(
                  hint: 'Search your city...',
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
                if (popular.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  FigmaCard(
                    padding: EdgeInsets.zero,
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1.15,
                      children: [
                        for (final city in popular) _CityTile(city: city, onTap: () => _pick(city)),
                      ],
                    ),
                  ),
                ],
                if (all.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const FigmaSectionLabel('All cities'),
                  const SizedBox(height: 10),
                  FigmaPlaceList(
                    places: all,
                    icon: Icons.location_on_outlined,
                    showSubtitle: false,
                    onTap: _pick,
                  ),
                ],
                if (popular.isEmpty && all.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text('No cities found', style: TextStyle(color: t.body)),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({required this.city, required this.onTap});

  final FigmaPlace city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: t.cardBorder),
            bottom: BorderSide(color: t.cardBorder),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            city.image == null
                ? Icon(Icons.location_city_outlined, size: 28, color: FigmaColors.accentBlue)
                : Image.asset(city.image!, height: 34, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              city.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.heading),
            ),
          ],
        ),
      ),
    );
  }
}
