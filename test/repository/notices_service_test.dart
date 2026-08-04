import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nivasshub/core/network/api_client.dart';
import 'package:flutter_nivasshub/core/network/api_response.dart';

import 'package:flutter_nivasshub/features/notices/models/advertisement_model.dart';
import 'package:flutter_nivasshub/features/notices/models/community_post_model.dart';
import 'package:flutter_nivasshub/features/notices/models/notice_model.dart';

import 'package:flutter_nivasshub/features/notices/repository/notices_service.dart';

void main() {
  late ApiClient apiClient;
  late NoticesService service;

  setUp(() {
    apiClient = ApiClient();
    service = NoticesService(apiClient);
  });

  group('Advertisement API', () {
    test('Returns ApiResponse<List<AdvertisementModel>>', () async {
      final ApiResponse<List<AdvertisementModel>> response = await service
          .getAdvertisements();

      expect(response, isA<ApiResponse<List<AdvertisementModel>>>());
    });

    test('Response success flag is available', () async {
      final response = await service.getAdvertisements();

      expect(response.isSuccess || response.isFailure, true);
    });
  });

  group('Notice API', () {
    test('Returns ApiResponse<List<NoticeModel>>', () async {
      final ApiResponse<List<NoticeModel>> response = await service
          .getNotices();

      expect(response, isA<ApiResponse<List<NoticeModel>>>());
    });

    test('Response success flag is available', () async {
      final response = await service.getNotices();

      expect(response.isSuccess || response.isFailure, true);
    });
  });

  group('Community API', () {
    test('Returns ApiResponse<List<CommunityPostModel>>', () async {
      final ApiResponse<List<CommunityPostModel>> response = await service
          .getCommunityPosts(page: 1, limit: 10);

      expect(response, isA<ApiResponse<List<CommunityPostModel>>>());
    });

    test('Community list should never be null', () async {
      final response = await service.getCommunityPosts(page: 1, limit: 10);

      expect(response.data, isNotNull);
    });
  });

  group('Repository Validation', () {
    test('Advertisement response type', () async {
      final response = await service.getAdvertisements();

      expect(response.runtimeType, ApiResponse<List<AdvertisementModel>>);
    });

    test('Notice response type', () async {
      final response = await service.getNotices();

      expect(response.runtimeType, ApiResponse<List<NoticeModel>>);
    });

    test('Community response type', () async {
      final response = await service.getCommunityPosts(page: 1, limit: 10);

      expect(response.runtimeType, ApiResponse<List<CommunityPostModel>>);
    });
  });
}
