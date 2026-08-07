import 'package:flutter/material.dart';

import '../../../shared/models/app_feature_model.dart';
import '../../../shared/widgets/common/section_title.dart';
import '../../../shared/widgets/grids/category_grid.dart';
import '../models/quick_action_section_model.dart';
import 'icon_card.dart';

/// One generic section shell: header (via the shared `SectionTitle`'s
/// `trailing`/`actionLabel` slot — a custom widget such as
/// `RaiseAlertButton`, or a plain "View all" link) + a `CategoryGrid` built
/// via [itemBuilder]. Reused by every headered section on the Quick Actions
/// screen — the default builder renders flat [IconCard]s; Marketplace passes
/// its own `QuickActionCard` builder instead.
class QuickActionSection extends StatelessWidget {
  const QuickActionSection({
    super.key,
    required this.section,
    required this.onItemTap,
    this.columns = 4,
    this.itemBuilder,
    this.headerTrailing,
    this.onActionTap,
  });

  final QuickActionSectionModel section;
  final void Function(AppFeatureModel item) onItemTap;
  final int columns;
  final Widget Function(AppFeatureModel item, VoidCallback onTap)? itemBuilder;
  final Widget? headerTrailing;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          SectionTitle(
            title: section.title!,
            trailing: headerTrailing,
            actionLabel: headerTrailing == null ? section.actionLabel : null,
            onActionTap: onActionTap,
          ),
        CategoryGrid<AppFeatureModel>(
          items: section.items,
          columns: columns,
          itemBuilder: (item) {
            void onTap() => onItemTap(item);
            return itemBuilder != null ? itemBuilder!(item, onTap) : IconCard(item: item, onTap: onTap);
          },
        ),
      ],
    );
  }
}
