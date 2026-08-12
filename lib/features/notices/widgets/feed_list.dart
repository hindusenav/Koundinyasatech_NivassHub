import 'package:flutter/material.dart';

import '../models/feed_item_model.dart';
import 'advertisement_banner.dart';
import 'community_post_card.dart';
import 'load_more_widget.dart';
import 'notice_card.dart';

/// FeedList component rendering heterogeneous feed items with lazy evaluation,
/// keying, and load-more indicator.
class FeedList extends StatelessWidget {
  const FeedList({
    super.key,
    required this.feedItems,
    this.isLoadingMore = false,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<FeedItemModel> feedItems;
  final bool isLoadingMore;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final itemCount = feedItems.length + (isLoadingMore ? 1 : 0);

    return ListView.builder(
      key: const PageStorageKey("community_feed"),
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= feedItems.length) {
          return const LoadMoreWidget();
        }

        final item = feedItems[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RepaintBoundary(child: _FeedItem(item: item)),
        );
      },
    );
  }
}

class _FeedItem extends StatelessWidget {
  const _FeedItem({required this.item});

  final FeedItemModel item;

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case FeedType.advertisement:
        return AdvertisementBanner(
          key: ValueKey('ad_${item.advertisement!.id}'),
          advertisement: item.advertisement!,
        );

      case FeedType.notice:
        return NoticeCard(
          key: ValueKey('notice_${item.notice!.id}'),
          notice: item.notice!,
        );

      case FeedType.community:
        return CommunityPostCard(
          key: ValueKey('post_${item.communityPost!.id}'),
          post: item.communityPost!,
        );
    }
  }
}
