import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../repository/notices_api_service_base.dart';

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
    final response = await _apiClient.get(ApiEndpoints.notices);
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
    final response = await _apiClient.post(ApiEndpoints.posts, data: body);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createPoll({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(ApiEndpoints.createPoll, data: body);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createEvent({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.createEvent,
      data: body,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> uploadMedia(MultipartFile file) async {
    final form = FormData.fromMap({"file": file});
    final response = await _apiClient.post(
      ApiEndpoints.uploadMedia,
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
  Future<Map<String, dynamic>> deletePost(String postId) async {
    final response = await _apiClient.delete(ApiEndpoints.postById(postId));
    return response.data;
  }
}
