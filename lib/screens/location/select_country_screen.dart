import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// One selectable place (country or city) in the Figma pickers.
class FigmaPlace {
  const FigmaPlace({
    required this.id,
    required this.name,
    this.leading,
    this.subtitle,
    this.image,
  });

  final String id;
  final String name;

  /// Flag emoji for countries.
  final String? leading;
  final String? subtitle;

  /// Asset path of a landmark illustration (popular cities).
  final String? image;
}

/// Figma "Select Country": search box, a "Popular countries" card and an
/// "All countries" card. Data and navigation are supplied by the caller —
/// the screen only reports the tapped country through [onSelected].
class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({
    super.key,
    required this.popular,
    required this.all,
    required this.onSelected,
    this.isLoading = false,
  });

  final List<FigmaPlace> popular;
  final List<FigmaPlace> all;
  final ValueChanged<FigmaPlace> onSelected;
  final bool isLoading;

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  String _query = '';

  List<FigmaPlace> _filter(List<FigmaPlace> items) => _query.isEmpty
      ? items
      : items.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final popular = _filter(widget.popular);
    final all = _filter(widget.all);

    return FigmaHeaderScaffold(
      title: 'Select Country',
      body: widget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                FigmaSearchField(
                  hint: 'Search your country...',
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
                if (popular.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const FigmaSectionLabel('Popular countries'),
                  const SizedBox(height: 10),
                  FigmaPlaceList(places: popular, onTap: widget.onSelected),
                ],
                if (all.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const FigmaSectionLabel('All countries'),
                  const SizedBox(height: 10),
                  FigmaPlaceList(places: all, onTap: widget.onSelected),
                ],
                if (popular.isEmpty && all.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'No countries found',
                        style: TextStyle(color: FigmaColors.of(context).body),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Rounded search box used at the top of the pickers.
class FigmaSearchField extends StatelessWidget {
  const FigmaSearchField({super.key, required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder),
        boxShadow: [BoxShadow(color: t.shadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: t.heading, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: t.body, fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 20, color: t.body),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

/// A card of tappable rows (flag/icon, name, chevron) separated by dividers.
class FigmaPlaceList extends StatelessWidget {
  const FigmaPlaceList({
    super.key,
    required this.places,
    required this.onTap,
    this.icon = Icons.public,
    this.showSubtitle = true,
  });

  final List<FigmaPlace> places;
  final ValueChanged<FigmaPlace> onTap;

  /// Shown when a place has no [FigmaPlace.leading] emoji.
  final IconData icon;

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return FigmaCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < places.length; i++) ...[
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTap(places[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: FigmaColors.accentBlue.withValues(alpha: 0.10),
                        shape: places[i].leading != null ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: places[i].leading != null ? BorderRadius.circular(8) : null,
                      ),
                      child: places[i].leading != null
                          ? Text(places[i].leading!, style: const TextStyle(fontSize: 18))
                          : Icon(icon, size: 20, color: FigmaColors.accentBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            places[i].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: t.heading,
                            ),
                          ),
                          if (showSubtitle && places[i].subtitle != null)
                            Text(
                              places[i].subtitle!,
                              style: TextStyle(fontSize: 11, color: t.body),
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 20, color: t.body),
                  ],
                ),
              ),
            ),
            if (i < places.length - 1) Divider(height: 1, color: t.cardBorder),
          ],
        ],
      ),
    );
  }
}
