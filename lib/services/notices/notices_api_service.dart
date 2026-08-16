import 'package:dio/dio.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/services/core/api_endpoints.dart';
import 'package:flutter_nivasshub/services/notices/notices_api_service_base.dart';

class NoticesApiService implements NoticesApiServiceBase {
  const NoticesApiService(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> getBanners() async {
    final response = await _apiClient.get(ApiEndpoints.banners);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getNotices() async {
    final response = await _apiClient.get(ApiEndpoints.noticeBoard);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getNoticeDetails(String id) async {
    final response = await _apiClient.get(ApiEndpoints.noticeBoardById(id));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> markNoticeAsRead(String id) async {
    final response = await _apiClient.patch(ApiEndpoints.markNoticeRead(id));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getCommunityPosts({
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.posts,
      queryParameters: {"offset": (page - 1) * limit, "limit": limit},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createPost({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.communityCreatePost,
      data: body,
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createPoll({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.communityCreatePoll,
      data: body,
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createEvent({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.communityCreateEvent,
      data: body,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> uploadMedia(MultipartFile file) async {
    final form = FormData.fromMap({"file": file});
    final response = await _apiClient.post(
      ApiEndpoints.profileImages,
      data: form,
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> likePost(String postId) async {
    final response = await _apiClient.post(ApiEndpoints.postLike(postId));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> unlikePost(String postId) async {
    final response = await _apiClient.delete(ApiEndpoints.postUnlike(postId));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> commentPost({
    required String postId,
    required String comment,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.postComments(postId),
      data: {"content": comment},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getComments(String postId) async {
    final response = await _apiClient.get(ApiEndpoints.getPostComments(postId));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> deletePost(String postId) async {
    final response = await _apiClient.delete(ApiEndpoints.postById(postId));
    return response.data;
  }
}
