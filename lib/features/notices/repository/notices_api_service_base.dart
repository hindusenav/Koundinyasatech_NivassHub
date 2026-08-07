abstract class NoticesApiServiceBase {
  Future<Map<String, dynamic>> getBanners();
  Future<Map<String, dynamic>> getNotices();
  Future<Map<String, dynamic>> getNoticeDetails(String id);
  Future<Map<String, dynamic>> markNoticeAsRead(String id);
  Future<Map<String, dynamic>> getCommunityPosts({
    required int page,
    required int limit,
  });
  Future<Map<String, dynamic>> createPost({required Map<String, dynamic> body});
  Future<Map<String, dynamic>> createPoll({required Map<String, dynamic> body});
  Future<Map<String, dynamic>> createEvent({
    required Map<String, dynamic> body,
  });
  Future<Map<String, dynamic>> likePost(String postId);
  Future<Map<String, dynamic>> unlikePost(String postId);
  Future<Map<String, dynamic>> commentPost({
    required String postId,
    required String comment,
  });
  Future<Map<String, dynamic>> getComments(String postId);
  Future<Map<String, dynamic>> deletePost(String postId);
}
