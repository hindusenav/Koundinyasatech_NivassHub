import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';

import '../models/advertisement_model.dart';
import '../models/community_post_model.dart';
import '../models/notice_model.dart';
import 'notices_api_service_base.dart';

class NoticesService {
  NoticesService(this._api);

  final NoticesApiServiceBase _api;

  Future<ApiResponse<List<AdvertisementModel>>> getAdvertisements() async {
    try {
      final json = await _api.getBanners();
      final dynamic data = json["data"];
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic> && data["banners"] is List) {
        list = data["banners"];
      }

      return ApiResponse.success(
        list
            .map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<List<NoticeModel>>> getNotices() async {
    try {
      final json = await _api.getNotices();
      final dynamic data = json["data"];
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic> && data["items"] is List) {
        list = data["items"];
      } else if (data is Map<String, dynamic> && data["notices"] is List) {
        list = data["notices"];
      }

      return ApiResponse.success(
        list
            .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<List<CommunityPostModel>>> getCommunityPosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final json = await _api.getCommunityPosts(page: page, limit: limit);
      final dynamic data = json["data"];
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic> && data["posts"] is List) {
        list = data["posts"];
      }

      return ApiResponse.success(
        list
            .map((e) => CommunityPostModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> createPost(Map<String, dynamic> body) async {
    try {
      await _api.createPost(body: body);
      return ApiResponse.success(null, message: "Post Created");
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> createPoll(Map<String, dynamic> body) async {
    try {
      await _api.createPoll(body: body);
      return ApiResponse.success(null, message: "Poll Created");
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> createEvent(Map<String, dynamic> body) async {
    try {
      await _api.createEvent(body: body);
      return ApiResponse.success(null, message: "Event Created");
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> likePost(String id) async {
    try {
      await _api.likePost(id);
      return ApiResponse.success(null);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> unlikePost(String id) async {
    try {
      await _api.unlikePost(id);
      return ApiResponse.success(null);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> commentPost({
    required String postId,
    required String comment,
  }) async {
    try {
      await _api.commentPost(postId: postId, comment: comment);
      return ApiResponse.success(null);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }

  Future<ApiResponse<void>> deletePost(String postId) async {
    try {
      await _api.deletePost(postId);
      return ApiResponse.success(null);
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        ApiException(message: e.toString(), type: ApiExceptionType.unknown),
      );
    }
  }
}
