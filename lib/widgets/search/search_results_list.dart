import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';
import 'package:flutter_nivasshub/widgets/shared/common/custom_divider.dart';
import 'package:flutter_nivasshub/widgets/search/search_result_tile.dart';

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
