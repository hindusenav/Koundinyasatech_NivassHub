import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../models/feed_item_model.dart';
import '../repository/notices_service.dart';

/// Owns the community feed — advertisements, notices and community posts
/// combined into a single scrollable [feedItems] list, per the standard
/// provider contract every feature provider follows.
class NoticesProvider extends ChangeNotifier {
  NoticesProvider({required ApiClient apiClient})
      : _service = NoticesService(apiClient);

  final NoticesService _service;

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _postsPage = 1;
  bool _hasMorePosts = true;

  final List<FeedItemModel> _feedItems = [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _feedItems.isEmpty;
  List<FeedItemModel> get feedItems => List.unmodifiable(_feedItems);

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
    if (_isLoadingMore || !_hasMorePosts) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = _postsPage + 1;
    final response = await _service.getCommunityPosts(page: nextPage);

    if (response.isSuccess && response.data != null) {
      if (response.data!.isEmpty) {
        _hasMorePosts = false;
      } else {
        _postsPage = nextPage;
        _feedItems.addAll(response.data!.map(FeedItemModel.communityPost));
      }
    }

    _isLoadingMore = false;
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
        adsResponse.isFailure && noticesResponse.isFailure && postsResponse.isFailure;

    if (allFailed) {
      _errorMessage = adsResponse.message ??
          noticesResponse.message ??
          postsResponse.message ??
          'Something went wrong. Please try again.';
      return;
    }

    _errorMessage = null;
    _postsPage = 1;
    _hasMorePosts = postsResponse.isSuccess && (postsResponse.data?.isNotEmpty ?? false);

    _feedItems
      ..clear()
      ..addAll([
        if (adsResponse.isSuccess)
          ...adsResponse.data!.map(FeedItemModel.advertisement),
        if (noticesResponse.isSuccess)
          ...noticesResponse.data!.map(FeedItemModel.notice),
        if (postsResponse.isSuccess)
          ...postsResponse.data!.map(FeedItemModel.communityPost),
      ]);
  }
}
