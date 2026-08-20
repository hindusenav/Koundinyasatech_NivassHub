import 'package:flutter_nivasshub/models/dashboard/address_model.dart';
import 'package:flutter_nivasshub/models/dashboard/announcement_model.dart';
import 'package:flutter_nivasshub/models/dashboard/banner_model.dart';
import 'package:flutter_nivasshub/models/dashboard/community_meeting_model.dart';
import 'package:flutter_nivasshub/models/dashboard/guard_contact_model.dart';
import 'package:flutter_nivasshub/models/dashboard/home_response_model.dart';
import 'package:flutter_nivasshub/models/dashboard/notice_model.dart';
import 'package:flutter_nivasshub/models/dashboard/visitor_model.dart';
import 'package:flutter_nivasshub/services/dashboard/dashboard_service.dart';
import 'package:flutter_nivasshub/services/dashboard/home_api_service_base.dart';

class DashboardRepository {
  DashboardRepository(this._service, this._apiService);

  final DashboardService _service;
  final HomeApiServiceBase _apiService;

  Future<HomeResponseModel> getHome() async {
    final json = await _apiService.getHome();

    return HomeResponseModel.fromJson(json);
  }

  Future<List<AddressModel>> getAddresses() async {
    final json = await _apiService.getAddresses();

    final list = json['data'] as List;

    return list
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  Future<List<VisitorModel>> getPendingVisitors() async {
    final json = await _apiService.getPendingVisitors();

    final list = json['data'] as List;

    return list
        .map((e) => VisitorModel.fromJson(e))
        .toList();
  }

  Future<void> triggerSos({
    required double latitude,
    required double longitude,
  }) async {
    await _apiService.triggerSos(latitude: latitude, longitude: longitude);
  }

  Future<AnnouncementModel> getAnnouncement() async {
    final json = await _service.loadJson(
      'assets/json/announcement.json',
    );

    return AnnouncementModel.fromJson(json['data']);
  }

  Future<GuardContactModel> getGuardContact() async {
    final json = await _service.loadJson(
      'assets/json/guard_contact.json',
    );

    return GuardContactModel.fromJson(json['data']);
  }

  Future<List<BannerModel>> getBanners() async {
    final json = await _apiService.getBanners();

    final list = json['data'] as List;

    return list
        .map((e) => BannerModel.fromJson(e))
        .toList();
  }

  Future<CommunityMeetingModel> getCommunityMeeting() async {
    final json = await _service.loadJson(
      'assets/json/community_meeting.json',
    );

    return CommunityMeetingModel.fromJson(json['data']);
  }

  Future<List<NoticeModel>> getNotices() async {
    final json = await _service.loadJson(
      'assets/json/notices.json',
    );

    final list = json['data'] as List;

    return list
        .map((e) => NoticeModel.fromJson(e))
        .toList();
  }
}