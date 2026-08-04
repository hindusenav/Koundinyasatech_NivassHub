import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';

import '../models/advertisement_model.dart';
import '../models/community_post_model.dart';
import '../models/notice_model.dart';

class NoticesService {
  NoticesService(this._apiClient);

  final ApiClient _apiClient;

  //==========================================================================
  // Banner API
  //==========================================================================

  Future<ApiResponse<List<AdvertisementModel>>> getAdvertisements() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.banners);

      final List<dynamic> jsonList =
          (response.data['data'] ?? response.data) as List<dynamic>;

      final advertisements = jsonList
          .map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return ApiResponse.success(advertisements);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  //==========================================================================
  // Notice API
  //==========================================================================

  Future<ApiResponse<List<NoticeModel>>> getNotices() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.notices);

      final List<dynamic> jsonList =
          (response.data['data'] ?? response.data) as List<dynamic>;

      final notices = jsonList
          .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return ApiResponse.success(notices);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  //==========================================================================
  // Community Feed API (Pagination)
  //==========================================================================

  Future<ApiResponse<List<CommunityPostModel>>> getCommunityPosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.communityPosts,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> jsonList =
          (response.data['data'] ?? response.data) as List<dynamic>;

      final posts = jsonList
          .map((e) => CommunityPostModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return ApiResponse.success(posts);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }
}
