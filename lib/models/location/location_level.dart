/// The seven levels of the property cascade, in dependency order.
///
/// The declaration order is load-bearing: `LocationProvider` resets every
/// level *after* the one that changed with
/// `LocationLevel.values.skip(level.index + 1)`, so adding an eighth level
/// here needs no change to the reset logic and no level can be forgotten.
/// Hand-writing six null assignments per parent is exactly the bug this
/// ordering prevents.
enum LocationLevel {
  country,
  state,
  city,
  society,
  tower,
  floor,
  flat;

  /// Key this level's options live under in `location_tree.json` — and the
  /// `?level=` query value the real API will take.
  String get jsonKey => switch (this) {
    LocationLevel.country => 'countries',
    LocationLevel.state => 'states',
    LocationLevel.city => 'cities',
    LocationLevel.society => 'societies',
    LocationLevel.tower => 'towers',
    LocationLevel.floor => 'floors',
    LocationLevel.flat => 'flats',
  };

  String get wireValue => name;

  String get label => switch (this) {
    LocationLevel.country => 'Country',
    LocationLevel.state => 'State',
    LocationLevel.city => 'City',
    LocationLevel.society => 'Society Name',
    LocationLevel.tower => 'Tower / Block',
    LocationLevel.floor => 'Floor',
    LocationLevel.flat => 'Flat Number',
  };

  String get hint => 'Select ${label.toLowerCase()}';

  String get sheetTitle => 'Select $label';

  /// The level that must be chosen before this one becomes selectable.
  /// `null` only for [country].
  LocationLevel? get previous =>
      index == 0 ? null : LocationLevel.values[index - 1];

  /// The level unlocked by choosing this one. `null` only for [flat].
  LocationLevel? get next => index == LocationLevel.values.length - 1
      ? null
      : LocationLevel.values[index + 1];

  static LocationLevel fromJson(dynamic value) {
    return LocationLevel.values.firstWhere(
      (l) => l.wireValue == value,
      orElse: () => LocationLevel.country,
    );
  }
}
