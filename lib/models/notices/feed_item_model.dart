import 'package:flutter_nivasshub/models/notices/advertisement_model.dart';
import 'package:flutter_nivasshub/models/notices/community_post_model.dart';
import 'package:flutter_nivasshub/models/notices/feed_notice_model.dart';

enum FeedType { advertisement, notice, community }

class FeedItemModel {
  final FeedType type;
  final AdvertisementModel? advertisement;
  final FeedNoticeModel? notice;
  final CommunityPostModel? communityPost;

  const FeedItemModel({
    required this.type,
    this.advertisement,
    this.notice,
    this.communityPost,
  });

  const FeedItemModel.advertisement(AdvertisementModel advertisement)
    : this(type: FeedType.advertisement, advertisement: advertisement);

  const FeedItemModel.notice(FeedNoticeModel notice)
    : this(type: FeedType.notice, notice: notice);

  const FeedItemModel.communityPost(CommunityPostModel communityPost)
    : this(type: FeedType.community, communityPost: communityPost);

  String get id {
    switch (type) {
      case FeedType.advertisement:
        return advertisement!.bannerId;
      case FeedType.notice:
        return notice!.id;
      case FeedType.community:
        return communityPost!.id;
    }
  }
}
