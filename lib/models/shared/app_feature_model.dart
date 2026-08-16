/// A single tappable "feature" — one Quick Actions grid tile, one Search
/// result row, or one Popular Search entry. Shared by `features/quick_actions`
/// and `features/search` so both read the same catalog shape instead of two
/// slightly-different ones.
class AppFeatureModel {
  const AppFeatureModel({
    required this.id,
    required this.title,
    required this.iconKey,
    this.routeName,
    bool? isAvailable,
  }) : isAvailable = isAvailable ?? (routeName != null);

  /// Stable slug, e.g. `'invite_guest'` — used for special-case dispatch
  /// (e.g. `'test_notifications'`) and as a `Key`/list identity.
  final String id;

  /// Full display label, e.g. `'Invite Guest'`.
  final String title;

  /// Looked up via `AppFeatureIcons.icon(iconKey)`.
  final String iconKey;

  /// Non-null only for the handful of tiles that navigate somewhere real
  /// today (e.g. `AppRoutes.profile`). Null means either a special local
  /// action (see [id] `'test_notifications'`) or "coming soon".
  final String? routeName;

  /// `false` means tapping this tile shows a "coming soon" message instead
  /// of navigating — the destination module isn't built yet.
  final bool isAvailable;

  factory AppFeatureModel.fromJson(Map<String, dynamic> json) {
    final routeName = json['routeName'] as String?;
    return AppFeatureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? '',
      routeName: routeName,
      isAvailable: json['isAvailable'] as bool? ?? (routeName != null),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'iconKey': iconKey,
        if (routeName != null) 'routeName': routeName,
        'isAvailable': isAvailable,
      };
}
