import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/screens/location/select_city_screen.dart';
import 'package:flutter_nivasshub/screens/location/select_country_screen.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';

/// Opens the Figma "Select Country" / "Select City" pages for the existing
/// country and city fields.
///
/// A drop-in presentation swap for `SelectionBottomSheet.show`: the caller
/// passes the same items and label accessors and gets the chosen item back
/// (or `null` when dismissed), so each screen's own selection logic and
/// provider calls stay exactly as they were.
class FigmaPlacePicker {
  FigmaPlacePicker._();

  static const _popularCountries = [
    'india',
    'kenya',
    'united arab emirates',
    'philippines',
    'canada',
  ];

  static const _cityArt = 'assets/images/kyc/cities/';

  /// Popular-city grid: display order, name aliases and illustration.
  static const _popularCities = <(List<String>, String)>[
    (['bangalore', 'bengaluru'], 'landmark-illustration.png'),
    (['mumbai'], 'landmark-illustration (1).png'),
    (['delhi ncr', 'delhi', 'new delhi'], 'landmark-illustration (2).png'),
    (['pune'], 'landmark-illustration (3).png'),
    (['chennai'], 'landmark-illustration (4).png'),
    (['hyderabad'], 'landmark-illustration (5).png'),
    (['ahmedabad'], 'landmark-illustration (6).png'),
    (['kolkata'], 'landmark-illustration (7).png'),
    (['kochi', 'cochin'], 'landmark-illustration (8).png'),
  ];

  /// ISO 3166 alpha-2 code to its flag emoji; `null` for anything else.
  static String? flagFromCode(String? code) {
    if (code == null || code.length != 2) return null;
    final up = code.toUpperCase().codeUnits;
    if (up.any((c) => c < 65 || c > 90)) return null;
    return String.fromCharCodes([for (final c in up) 0x1F1E6 + c - 65]);
  }

  static Future<T?> country<T>(
    BuildContext context, {
    required List<T> items,
    required String Function(T item) labelOf,
    String? Function(T item)? flagOf,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
    FutureOr<void> Function(T item)? onPicked,
  }) {
    return _push<T>(
      context,
      title: 'Select Country',
      items: items,
      errorMessage: errorMessage,
      onRetry: onRetry,
      onPicked: onPicked,
      builder: (ctx, pop) {
        final byId = <String, T>{};
        final popular = <FigmaPlace>[];
        final all = <FigmaPlace>[];
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          final place = FigmaPlace(
            id: '$i',
            name: labelOf(item),
            leading: flagOf?.call(item) ?? flagFromName(labelOf(item)),
          );
          byId[place.id] = item;
          (_popularCountries.contains(place.name.toLowerCase()) ? popular : all)
              .add(place);
        }
        popular.sort(
          (a, b) => _popularCountries
              .indexOf(a.name.toLowerCase())
              .compareTo(_popularCountries.indexOf(b.name.toLowerCase())),
        );
        return SelectCountryScreen(
          popular: popular,
          all: all,
          isLoading: isLoading,
          onSelected: (p) => pop(byId[p.id] as T),
        );
      },
    );
  }

  static Future<T?> city<T>(
    BuildContext context, {
    required List<T> items,
    required String Function(T item) labelOf,
    String? subtitle,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
    FutureOr<void> Function(T item)? onPicked,
  }) {
    return _push<T>(
      context,
      title: 'Select City',
      items: items,
      errorMessage: errorMessage,
      onRetry: onRetry,
      onPicked: onPicked,
      builder: (ctx, pop) {
        final byId = <String, T>{};
        final popular = <int, FigmaPlace>{};
        final all = <FigmaPlace>[];
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          final name = labelOf(item);
          final slot = _popularCities.indexWhere(
            (c) => c.$1.contains(name.toLowerCase()),
          );
          final place = FigmaPlace(
            id: '$i',
            name: name,
            subtitle: subtitle,
            image: slot >= 0 && !popular.containsKey(slot)
                ? '$_cityArt${_popularCities[slot].$2}'
                : null,
          );
          byId[place.id] = item;
          if (slot >= 0 && !popular.containsKey(slot)) {
            popular[slot] = place;
          } else {
            all.add(place);
          }
        }
        final slots = popular.keys.toList()..sort();
        // A near-empty grid looks broken, so a state with only a couple of
        // well-known cities lists them with the rest instead.
        final showGrid = slots.length >= 3;
        final gridPlaces = showGrid
            ? [for (final s in slots) popular[s]!]
            : <FigmaPlace>[];
        final listPlaces = showGrid
            ? all
            : [for (final s in slots) popular[s]!.withoutImage(), ...all];
        return SelectCityScreen(
          popular: gridPlaces,
          all: listPlaces,
          isLoading: isLoading,
          onConfirmed: (p) => pop(byId[p.id] as T),
        );
      },
    );
  }

  /// Figma-styled full-page list (search + map rows) for the State picker.
  static Future<T?> state<T>(
    BuildContext context, {
    required List<T> items,
    required String Function(T item) labelOf,
    FutureOr<void> Function(T item)? onPicked,
  }) {
    return _push<T>(
      context,
      title: 'Select State',
      items: items,
      errorMessage: null,
      onRetry: null,
      onPicked: onPicked,
      builder: (ctx, pop) => _PlaceListPage<T>(
        title: 'Select State',
        searchHint: 'Search your state...',
        sectionLabel: 'All states',
        emptyText: 'No states found',
        icon: Icons.map_outlined,
        items: items,
        labelOf: labelOf,
        onPicked: pop,
      ),
    );
  }

  /// Flag emoji for a country [name], or `null` when it is not recognised.
  static String? flagFromName(String name) {
    final code = _isoByName[name.trim().toLowerCase()];
    return code == null ? null : flagFromCode(code);
  }

  /// Walks the user through Select Country → Select State → Select City as
  /// stacked full pages (back returns to the previous one).
  ///
  /// The caller supplies the data and applies each choice to its own
  /// providers through [onCountry] / [onState] / [onCity] — exactly what its
  /// old pickers did — so nothing about the selection logic moves here.
  /// Resolves to `true` once a city is confirmed (the pages are closed and
  /// the caller is back on top), or `false` if the user backed out of the
  /// first page.
  static Future<bool> locationFlow<C, S>(
    BuildContext context, {
    required List<C> countries,
    required String Function(C item) countryLabel,
    String? Function(C item)? countryFlag,
    required FutureOr<void> Function(C item) onCountry,
    required List<S> Function() states,
    required String Function(S item) stateLabel,
    required void Function(S item) onState,
    required List<String> Function() cities,
    required void Function(String city) onCity,
    required String? Function() citySubtitle,
  }) {
    final base = ModalRoute.of(context);
    final navigator = Navigator.of(context);
    final done = Completer<bool>();

    void finish(bool ok) {
      if (!done.isCompleted) done.complete(ok);
    }

    void pickCity() {
      city<String>(
        context,
        items: cities(),
        labelOf: (c) => c,
        subtitle: citySubtitle(),
        onPicked: (c) {
          onCity(c);
          finish(true);
          navigator.popUntil((r) => r == base);
        },
      );
    }

    void pickState() {
      state<S>(
        context,
        items: states(),
        labelOf: stateLabel,
        onPicked: (s) {
          onState(s);
          pickCity();
        },
      );
    }

    country<C>(
      context,
      items: countries,
      labelOf: countryLabel,
      flagOf: countryFlag,
      onPicked: (c) async {
        await onCountry(c);
        pickState();
      },
    ).then((_) => finish(false));

    return done.future;
  }

  static Future<T?> _push<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String? errorMessage,
    required VoidCallback? onRetry,
    FutureOr<void> Function(T item)? onPicked,
    required Widget Function(BuildContext, void Function(T)) builder,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (ctx) {
          if (items.isEmpty && errorMessage != null) {
            return FigmaHeaderScaffold(
              title: title,
              body: CustomErrorWidget(
                message: errorMessage,
                onRetry: () {
                  onRetry?.call();
                  Navigator.of(ctx).pop();
                },
              ),
            );
          }
          return builder(ctx, (value) {
            if (onPicked != null) {
              onPicked(value);
            } else {
              Navigator.of(ctx).pop(value);
            }
          });
        },
      ),
    );
  }
}

class _PlaceListPage<T> extends StatefulWidget {
  const _PlaceListPage({
    required this.title,
    required this.searchHint,
    required this.sectionLabel,
    required this.emptyText,
    required this.icon,
    required this.items,
    required this.labelOf,
    required this.onPicked,
  });

  final String title;
  final String searchHint;
  final String sectionLabel;
  final String emptyText;
  final IconData icon;
  final List<T> items;
  final String Function(T item) labelOf;
  final void Function(T item) onPicked;

  @override
  State<_PlaceListPage<T>> createState() => _PlaceListPageState<T>();
}

class _PlaceListPageState<T> extends State<_PlaceListPage<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final byId = <String, T>{};
    final places = <FigmaPlace>[];
    for (var i = 0; i < widget.items.length; i++) {
      final name = widget.labelOf(widget.items[i]);
      if (q.isNotEmpty && !name.toLowerCase().contains(q)) continue;
      byId['$i'] = widget.items[i];
      places.add(FigmaPlace(id: '$i', name: name));
    }

    return FigmaHeaderScaffold(
      title: widget.title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          FigmaSearchField(
            hint: widget.searchHint,
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          const SizedBox(height: 18),
          if (places.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(
                child: Text(
                  widget.emptyText,
                  style: TextStyle(color: FigmaColors.of(context).body),
                ),
              ),
            )
          else ...[
            FigmaSectionLabel(widget.sectionLabel),
            const SizedBox(height: 10),
            FigmaPlaceList(
              places: places,
              icon: widget.icon,
              onTap: (p) => widget.onPicked(byId[p.id] as T),
            ),
          ],
        ],
      ),
    );
  }
}

const _isoData =
    'AF:Afghanistan|AL:Albania|DZ:Algeria|AD:Andorra|AO:Angola|AG:Antigua and Barbuda|AR:Argentina|AM:Armenia|AU:Australia|AT:Austria|AZ:Azerbaijan|BS:Bahamas|BH:Bahrain|BD:Bangladesh|BB:Barbados|BY:Belarus|BE:Belgium|BZ:Belize|BJ:Benin|BT:Bhutan|BO:Bolivia|BA:Bosnia and Herzegovina|BW:Botswana|BR:Brazil|BN:Brunei|BG:Bulgaria|BF:Burkina Faso|BI:Burundi|KH:Cambodia|CM:Cameroon|CA:Canada|CV:Cape Verde|CF:Central African Republic|TD:Chad|CL:Chile|CN:China|CO:Colombia|KM:Comoros|CG:Congo|CD:Democratic Republic of the Congo|CR:Costa Rica|CI:Ivory Coast|HR:Croatia|CU:Cuba|CY:Cyprus|CZ:Czech Republic|CZ:Czechia|DK:Denmark|DJ:Djibouti|DM:Dominica|DO:Dominican Republic|EC:Ecuador|EG:Egypt|SV:El Salvador|GQ:Equatorial Guinea|ER:Eritrea|EE:Estonia|SZ:Eswatini|ET:Ethiopia|FJ:Fiji|FI:Finland|FR:France|GA:Gabon|GM:Gambia|GE:Georgia|DE:Germany|GH:Ghana|GR:Greece|GD:Grenada|GT:Guatemala|GN:Guinea|GW:Guinea-Bissau|GY:Guyana|HT:Haiti|HN:Honduras|HK:Hong Kong|HU:Hungary|IS:Iceland|IN:India|ID:Indonesia|IR:Iran|IQ:Iraq|IE:Ireland|IL:Israel|IT:Italy|JM:Jamaica|JP:Japan|JO:Jordan|KZ:Kazakhstan|KE:Kenya|KI:Kiribati|KW:Kuwait|KG:Kyrgyzstan|LA:Laos|LV:Latvia|LB:Lebanon|LS:Lesotho|LR:Liberia|LY:Libya|LI:Liechtenstein|LT:Lithuania|LU:Luxembourg|MO:Macau|MG:Madagascar|MW:Malawi|MY:Malaysia|MV:Maldives|ML:Mali|MT:Malta|MH:Marshall Islands|MR:Mauritania|MU:Mauritius|MX:Mexico|FM:Micronesia|MD:Moldova|MC:Monaco|MN:Mongolia|ME:Montenegro|MA:Morocco|MZ:Mozambique|MM:Myanmar|NA:Namibia|NR:Nauru|NP:Nepal|NL:Netherlands|NZ:New Zealand|NI:Nicaragua|NE:Niger|NG:Nigeria|KP:North Korea|MK:North Macedonia|NO:Norway|OM:Oman|PK:Pakistan|PW:Palau|PS:Palestine|PA:Panama|PG:Papua New Guinea|PY:Paraguay|PE:Peru|PH:Philippines|PL:Poland|PT:Portugal|PR:Puerto Rico|QA:Qatar|RO:Romania|RU:Russia|RW:Rwanda|KN:Saint Kitts and Nevis|LC:Saint Lucia|VC:Saint Vincent and the Grenadines|WS:Samoa|SM:San Marino|ST:Sao Tome and Principe|SA:Saudi Arabia|SN:Senegal|RS:Serbia|SC:Seychelles|SL:Sierra Leone|SG:Singapore|SK:Slovakia|SI:Slovenia|SB:Solomon Islands|SO:Somalia|ZA:South Africa|KR:South Korea|SS:South Sudan|ES:Spain|LK:Sri Lanka|SD:Sudan|SR:Suriname|SE:Sweden|CH:Switzerland|SY:Syria|TW:Taiwan|TJ:Tajikistan|TZ:Tanzania|TH:Thailand|TL:Timor-Leste|TG:Togo|TO:Tonga|TT:Trinidad and Tobago|TN:Tunisia|TR:Turkey|TM:Turkmenistan|TV:Tuvalu|UG:Uganda|UA:Ukraine|AE:United Arab Emirates|GB:United Kingdom|US:United States|US:United States of America|UY:Uruguay|UZ:Uzbekistan|VU:Vanuatu|VA:Vatican City|VE:Venezuela|VN:Vietnam|YE:Yemen|ZM:Zambia|ZW:Zimbabwe|AE:UAE|GB:UK|US:USA|KR:Korea|RU:Russian Federation';

final Map<String, String> _isoByName = {
  for (final entry in _isoData.split('|'))
    entry.substring(3).toLowerCase(): entry.substring(0, 2),
};

extension on FigmaPlace {
  /// Same place without its illustration, for the plain list rows.
  FigmaPlace withoutImage() =>
      FigmaPlace(id: id, name: name, leading: leading, subtitle: subtitle);
}
