import '../../../shared/models/app_feature_model.dart';

/// One group of tiles on the Quick Actions screen (e.g. "Visitors &
/// Security"). The top shortcuts row is modeled as a section with a `null`
/// [title] so the screen knows to render it without a header.
class QuickActionSectionModel {
  const QuickActionSectionModel({
    required this.id,
    this.title,
    this.actionLabel,
    required this.items,
  });

  final String id;

  /// `null` means this section renders with no header (the shortcuts row).
  final String? title;

  /// The section-header action link label, e.g. `'View all'`, `'Explore'`,
  /// `'Raise Alert'`. `null` when the section has no such action.
  final String? actionLabel;

  final List<AppFeatureModel> items;

  factory QuickActionSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return QuickActionSectionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      actionLabel: json['actionLabel'] as String?,
      items: rawItems
          .map((e) => AppFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
