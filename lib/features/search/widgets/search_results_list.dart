import 'package:flutter/material.dart';

import '../../../shared/models/app_feature_model.dart';
import '../../../shared/widgets/cards/custom_card.dart';
import '../../../shared/widgets/common/custom_divider.dart';
import 'search_result_tile.dart';

/// One grouped card of [SearchResultTile] rows with a divider between each —
/// reused for both the Popular Searches list and the live query-results
/// list.
class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.items, required this.onItemTap});

  final List<AppFeatureModel> items;
  final void Function(AppFeatureModel item) onItemTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            SearchResultTile(item: items[i], onTap: () => onItemTap(items[i])),
            if (i != items.length - 1) const CustomDivider(indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}
