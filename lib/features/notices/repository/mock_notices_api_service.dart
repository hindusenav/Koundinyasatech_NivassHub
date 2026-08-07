import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'notices_api_service_base.dart';

class MockNoticesApiService implements NoticesApiServiceBase {
  const MockNoticesApiService();

  @override
  Future<Map<String, dynamic>> getBanners() =>
      _loadJson('assets/json/banners.json');

  @override
  Future<Map<String, dynamic>> getNotices() =>
      _loadJson('assets/json/notices/notices.json');

  @override
  Future<Map<String, dynamic>> getNoticeDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'statusCode': 200,
      'message': 'Notice details fetched successfully.',
      'data': {
        'id': int.tryParse(id) ?? 101,
        'type': 'NOTICE',
        'title': 'Expenses report of last quarter Apr-Jun 2026',
        'description':
            'Dear All, Please find the details of expenditure of last quarter Apr-Jun 2026...',
        'content': 'Complete notice content will be available here.',
        'postedBy': 'Association',
        'postedDate': '2026-07-10',
        'hasAttachment': true,
        'attachments': [
          {
            'id': 501,
            'fileName': 'expense-report-apr-jun-2026.pdf',
            'fileUrl': 'https://example.com/files/expense-report.pdf',
            'fileType': 'PDF',
          }
        ],
        'images': [],
      },
    };
  }

  @override
  Future<Map<String, dynamic>> markNoticeAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'statusCode': 200,
      'message': 'Notice marked as read.',
      'data': {'id': int.tryParse(id) ?? 101, 'isRead': true},
    };
  }

  @override
  Future<Map<String, dynamic>> getCommunityPosts({
    required int page,
    required int limit,
  }) {
    if (page == 1) {
      return _loadJson('assets/json/notices/community_posts_page_1.json');
    } else if (page == 2) {
      return _loadJson('assets/json/notices/community_posts_page_2.json');
    }
    return Future.value({
      'status': 'success',
      'message': 'No more community posts available',
      'data': {
        'posts': <dynamic>[],
        'pagination': {'total': 0, 'nextOffset': null},
      },
    });
  }

  @override
  Future<Map<String, dynamic>> createPost({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'status': 'success',
      'message': 'Post created successfully.',
      'data': {
        'postId': 'POST_${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> createPoll({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'status': 'success',
      'message': 'Poll created successfully.',
      'data': {
        'pollId': 'POLL_${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> createEvent({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'status': 'success',
      'message': 'Event created successfully.',
      'data': {
        'eventId': 'EVENT_${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> likePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'status': 'success',
      'message': 'Post liked successfully.',
      'data': {'liked': true, 'likesCount': 6},
    };
  }

  @override
  Future<Map<String, dynamic>> unlikePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'status': 'success',
      'message': 'Post unliked successfully.',
      'data': {'liked': false, 'likesCount': 5},
    };
  }

  @override
  Future<Map<String, dynamic>> commentPost({
    required String postId,
    required String comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'status': 'success',
      'message': 'Comment added successfully.',
      'data': {
        'commentId': 'comm_${DateTime.now().millisecondsSinceEpoch}',
        'content': comment,
        'author': {'name': 'Hindu', 'flat': 'C 104'},
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'status': 'success',
      'data': {
        'comments': [
          {
            'id': 'comm_123',
            'content': 'This is a comment on the post.',
            'author': {'name': 'Hindu', 'flat': 'C 104'},
            'createdAt': DateTime.now().toIso8601String(),
            'likesCount': 2,
          }
        ],
        'pagination': {'total': 1, 'nextOffset': null},
      },
    };
  }

  @override
  Future<Map<String, dynamic>> deletePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'status': 'success',
      'message': 'Post deleted successfully.',
      'data': null,
    };
  }

  Future<Map<String, dynamic>> _loadJson(String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
