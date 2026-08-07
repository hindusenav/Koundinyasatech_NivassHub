/// One selectable option in the "Filter Activity by Type" bottom sheet
/// (`ActivityTypeFilterSheet`) — e.g. "Cab", "Delivery", "Daily Help". This
/// is a screen-local categorization, distinct from `ApprovalActivityModel`'s
/// `type`/`company` fields and not yet covered by the NivasHub API contract
/// (no Figma/endpoint published for it). Kept as its own tiny model so the
/// eventual real endpoint only needs to be shaped like this — `id`, `label`,
/// `iconKey` — for `MockActivityTypeFilterService` to be swapped for a real
/// one with no changes to the provider/UI above it.
class ActivityTypeFilterOption {
  const ActivityTypeFilterOption({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  /// Stable slug, e.g. `'cab'`, `'daily_help'` — used as the selection key
  /// and as the value returned to the parent screen via `Apply Filter`.
  final String id;

  final String label;

  /// Looked up via `AppFeatureIcons.icon(iconKey)` — reuses the same
  /// icon-key registry the Quick Actions/Search catalog already uses,
  /// rather than introducing a second icon lookup convention.
  final String iconKey;

  factory ActivityTypeFilterOption.fromJson(Map<String, dynamic> json) {
    return ActivityTypeFilterOption(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? '',
    );
  }
}
