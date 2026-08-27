import 'package:flutter/foundation.dart';

import 'package:flutter_nivasshub/models/dashboard/address_model.dart';
import 'package:flutter_nivasshub/models/dashboard/announcement_model.dart';
import 'package:flutter_nivasshub/models/dashboard/banner_model.dart';
import 'package:flutter_nivasshub/models/dashboard/community_meeting_model.dart';
import 'package:flutter_nivasshub/models/dashboard/guard_contact_model.dart';
import 'package:flutter_nivasshub/models/dashboard/home_response_model.dart';
import 'package:flutter_nivasshub/models/dashboard/notice_model.dart';
import 'package:flutter_nivasshub/models/dashboard/visitor_model.dart';
import 'package:flutter_nivasshub/services/dashboard/dashboard_repository.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_state.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider(this._repository);

  final DashboardRepository _repository;

  DashboardState _state = DashboardState.initial;

  DashboardState get state => _state;

  // Home
  HomeResponseModel? _home;
  HomeResponseModel? get home => _home;

  // Addresses
  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  // Visitors
  List<VisitorModel> _visitors = [];
  List<VisitorModel> get visitors => _visitors;

  void removeVisitorByCompany(String? company) {
    if (company == null || company.isEmpty) return;

    final query = company.toLowerCase();
    final index = _visitors.indexWhere((v) => v.visitorName.toLowerCase().contains(query));
    if (index == -1) return;

    _visitors = List<VisitorModel>.from(_visitors)..removeAt(index);
    notifyListeners();
  }

  // Announcement
  AnnouncementModel? _announcement;
  AnnouncementModel? get announcement => _announcement;

  // Guard
  GuardContactModel? _guard;
  GuardContactModel? get guard => _guard;

  // Advertisement Banners
  List<BannerModel> _banners = [];
  List<BannerModel> get advertisementBanners => _banners;

  // Community meeting
  CommunityMeetingModel? _communityMeeting;
  CommunityMeetingModel? get communityMeeting => _communityMeeting;

  // Notices
  List<NoticeModel> _notices = [];
  List<NoticeModel> get notices => _notices;

  // Error
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == DashboardState.loading;
  bool get isSuccess => _state == DashboardState.success;
  bool get isError => _state == DashboardState.error;
  bool get isEmpty => _state == DashboardState.empty;

  Future<void> loadDashboard() async {
    debugPrint('[Dashboard] loadDashboard() start');
    _state = DashboardState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getHome(),
        _repository.getAddresses(),
        _repository.getPendingVisitors(),
        _repository.getAnnouncement(),
        _repository.getGuardContact(),
        _repository.getBanners(),
        _repository.getCommunityMeeting(),
        _repository.getNotices(),
      ]);

      _home = results[0] as HomeResponseModel;
      _addresses = results[1] as List<AddressModel>;
      _visitors = results[2] as List<VisitorModel>;
      _announcement = results[3] as AnnouncementModel;
      _guard = results[4] as GuardContactModel;
      _banners = results[5] as List<BannerModel>;
      _communityMeeting = results[6] as CommunityMeetingModel;
      _notices = results[7] as List<NoticeModel>;

      final hasData =
          _home != null &&
          (_home!.data.quickActions.isNotEmpty ||
              _visitors.isNotEmpty ||
              _addresses.isNotEmpty ||
              _banners.isNotEmpty);

      _state = hasData
          ? DashboardState.success
          : DashboardState.empty;
    } catch (e) {
      _errorMessage = e.toString();
      _state = DashboardState.error;
    }

    debugPrint('[Dashboard] loadDashboard() complete, state=$_state');
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Clears all cached dashboard data and returns state to
  /// [DashboardState.initial]. Called on logout so no stale data from the
  /// previous session can ever be shown; a fresh [loadDashboard]/[refresh]
  /// is triggered explicitly once a new session is established (see
  /// `OtpVerificationSuccessScreen`/`CreateProfileScreen`), not from here.
  void reset() {
    _home = null;
    _addresses = [];
    _visitors = [];
    _announcement = null;
    _guard = null;
    _banners = [];
    _communityMeeting = null;
    _notices = [];
    _errorMessage = '';
    _state = DashboardState.initial;
    debugPrint('[Dashboard] reset() - cache cleared, state=initial');
    notifyListeners();
  }

  Future<void> triggerSos({
    required double latitude,
    required double longitude,
  }) {
    return _repository.triggerSos(latitude: latitude, longitude: longitude);
  }

  void clearError() {
    _errorMessage = '';

    if (_state == DashboardState.error) {
      _state = DashboardState.initial;
      notifyListeners();
    }
  }
}