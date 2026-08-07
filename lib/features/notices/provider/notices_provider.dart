import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../models/advertisement_model.dart';
import '../models/community_post_model.dart';
import '../models/feed_item_model.dart';
import '../models/notice_model.dart';
import '../notices_config.dart';
import '../repository/mock_notices_api_service.dart';
import '../repository/notices_api_service.dart';
import '../repository/notices_service.dart';

enum FeedCategoryFilter { all, notices, posts }

class NoticesProvider extends ChangeNotifier {
  NoticesProvider({required ApiClient apiClient})
    : _service = NoticesService(
        useMockNoticesApi
            ? const MockNoticesApiService()
            : NoticesApiService(apiClient),
      );

  final NoticesService _service;

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _postsPage = 1;
  bool _hasMorePosts = true;
  FeedCategoryFilter _selectedFilter = FeedCategoryFilter.all;

  final List<FeedItemModel> _feedItems = [];
  final List<NoticeModel> _notices = [];
  final List<AdvertisementModel> _banners = [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => filteredFeedItems.isEmpty;
  bool get hasMorePosts => _hasMorePosts;
  FeedCategoryFilter get selectedFilter => _selectedFilter;

  List<FeedItemModel> get feedItems => List.unmodifiable(_feedItems);
  List<NoticeModel> get notices => List.unmodifiable(_notices);
  List<AdvertisementModel> get banners => List.unmodifiable(_banners);

  List<FeedItemModel> get filteredFeedItems {
    switch (_selectedFilter) {
      case FeedCategoryFilter.notices:
        return _feedItems
            .where(
              (item) =>
                  item.type == FeedType.notice ||
                  (item.type == FeedType.community &&
                      item.communityPost?.type == 'Notice'),
            )
            .toList();
      case FeedCategoryFilter.posts:
        return _feedItems
            .where((item) => item.type == FeedType.community)
            .toList();
      case FeedCategoryFilter.all:
        return List.unmodifiable(_feedItems);
    }
  }

  void setFilter(FeedCategoryFilter filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  Future<void> loadFeed() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _fetchFeed();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshFeed() async {
    _isRefreshing = true;
    notifyListeners();

    await _fetchFeed();

    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> retry() => loadFeed();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMorePosts || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = _postsPage + 1;
    final response = await _service.getCommunityPosts(page: nextPage);

    if (response.isSuccess && response.data != null) {
      if (response.data!.isEmpty) {
        _hasMorePosts = false;
      } else {
        _postsPage = nextPage;
        for (final post in response.data!) {
          _feedItems.add(FeedItemModel.communityPost(post));
        }
      }
    } else {
      _hasMorePosts = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<bool> toggleLike(String postId) async {
    final index = _feedItems.indexWhere(
      (item) => item.type == FeedType.community && item.communityPost?.id == postId,
    );

    if (index == -1) return false;

    final currentPost = _feedItems[index].communityPost!;
    final bool oldLiked = currentPost.isLiked;
    final int oldLikesCount = currentPost.likes;

    final updatedPost = currentPost.copyWith(
      isLiked: !oldLiked,
      likes: oldLiked ? (oldLikesCount - 1) : (oldLikesCount + 1),
    );

    _feedItems[index] = FeedItemModel.communityPost(updatedPost);
    notifyListeners();

    final response = await _service.likePost(postId);
    if (!response.isSuccess) {
      // Rollback optimistic update
      _feedItems[index] = FeedItemModel.communityPost(
        currentPost.copyWith(isLiked: oldLiked, likes: oldLikesCount),
      );
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> createPost({
    required String content,
    String visibility = 'All Residents',
    List<String> media = const [],
  }) async {
    final body = {
      'content': content,
      'visibility': visibility,
      'attachments': media
          .map((url) => {'fileType': 'IMAGE', 'fileUrl': url})
          .toList(),
    };

    final response = await _service.createPost(body);
    if (response.isSuccess) {
      final newPost = CommunityPostModel(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        userName: 'Hindu',
        userFlat: 'C 104',
        profileImage: 'https://dummyimage.com/profile.png',
        content: content,
        createdAt: DateTime.now().toIso8601String(),
        timestamp: 'Just now',
        likes: 0,
        comments: 0,
        visibility: visibility,
        imageUrl: media.isNotEmpty ? media.first : null,
        type: 'Post',
      );
      _feedItems.insert(0, FeedItemModel.communityPost(newPost));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createPoll({
    required String question,
    required List<String> options,
    String visibility = 'All Residents',
  }) async {
    final body = {
      'question': question,
      'options': options,
      'visibility': visibility,
    };

    final response = await _service.createPoll(body);
    if (response.isSuccess) {
      final newPoll = CommunityPostModel(
        id: 'poll_${DateTime.now().millisecondsSinceEpoch}',
        title: question,
        userName: 'Hindu',
        userFlat: 'C 104',
        profileImage: 'https://dummyimage.com/profile.png',
        content: question,
        createdAt: DateTime.now().toIso8601String(),
        timestamp: 'Just now',
        likes: 0,
        comments: 0,
        visibility: visibility,
        type: 'Poll',
        pollOptions: options,
      );
      _feedItems.insert(0, FeedItemModel.communityPost(newPoll));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required String startDateTime,
    required String endDateTime,
    required String venueName,
    String visibility = 'All Residents',
  }) async {
    final body = {
      'title': title,
      'description': description,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'venue': {'name': venueName},
      'visibility': visibility,
    };

    final response = await _service.createEvent(body);
    if (response.isSuccess) {
      final newEvent = CommunityPostModel(
        id: 'event_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        userName: 'Hindu',
        userFlat: 'C 104',
        profileImage: 'https://dummyimage.com/profile.png',
        content: description,
        createdAt: DateTime.now().toIso8601String(),
        timestamp: 'Just now',
        likes: 0,
        comments: 0,
        visibility: visibility,
        type: 'Event',
        action: 'RSVP Now',
      );
      _feedItems.insert(0, FeedItemModel.communityPost(newEvent));
      notifyListeners();
      return true;
    }
    return false;
  }

  void addPost(CommunityPostModel post) {
    _feedItems.insert(0, FeedItemModel.communityPost(post));
    notifyListeners();
  }

  Future<void> _fetchFeed() async {
    final adsFuture = _service.getAdvertisements();
    final noticesFuture = _service.getNotices();
    final postsFuture = _service.getCommunityPosts(page: 1);

    final adsResponse = await adsFuture;
    final noticesResponse = await noticesFuture;
    final postsResponse = await postsFuture;

    final allFailed =
        adsResponse.isFailure &&
        noticesResponse.isFailure &&
        postsResponse.isFailure;

    if (allFailed) {
      _errorMessage =
          adsResponse.message ??
          noticesResponse.message ??
          postsResponse.message ??
          'Something went wrong. Please try again.';
      return;
    }

    _errorMessage = null;
    _postsPage = 1;
    _hasMorePosts =
        postsResponse.isSuccess && (postsResponse.data?.isNotEmpty ?? false);

    _banners
      ..clear()
      ..addAll(adsResponse.data ?? []);

    _notices
      ..clear()
      ..addAll(noticesResponse.data ?? []);

    _feedItems.clear();

    // Interleave Top Hero Ad Banner if available
    if (_banners.isNotEmpty) {
      _feedItems.add(FeedItemModel.advertisement(_banners.first));
    }

    // Add Notices
    if (noticesResponse.isSuccess && noticesResponse.data != null) {
      for (final notice in noticesResponse.data!) {
        _feedItems.add(FeedItemModel.notice(notice));
      }
    }

    // Add Community Posts & interleave second banner if available
    if (postsResponse.isSuccess && postsResponse.data != null) {
      final posts = postsResponse.data!;
      for (int i = 0; i < posts.length; i++) {
        _feedItems.add(FeedItemModel.communityPost(posts[i]));

        if (i == 1 && _banners.length > 1) {
          _feedItems.add(FeedItemModel.advertisement(_banners[1]));
        }
      }
    }
  }
}
