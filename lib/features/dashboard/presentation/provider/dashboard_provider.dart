import 'package:flutter/foundation.dart';

import '../../data/models/address_model.dart';
import '../../data/models/announcement_model.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/guard_contact_model.dart';
import '../../data/models/home_response_model.dart';
import '../../data/models/visitor_model.dart';
import '../../data/repository/dashboard_repository.dart';
import 'dashboard_state.dart';

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

  // Announcement
  AnnouncementModel? _announcement;
  AnnouncementModel? get announcement => _announcement;

  // Guard
  GuardContactModel? _guard;
  GuardContactModel? get guard => _guard;

  // Advertisement Banners
  List<BannerModel> _banners = [];
  List<BannerModel> get advertisementBanners => _banners;

  // Error
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == DashboardState.loading;
  bool get isSuccess => _state == DashboardState.success;
  bool get isError => _state == DashboardState.error;
  bool get isEmpty => _state == DashboardState.empty;

  Future<void> loadDashboard() async {
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
        _repository.getBanners(), // <-- NEW
      ]);

      _home = results[0] as HomeResponseModel;
      _addresses = results[1] as List<AddressModel>;
      _visitors = results[2] as List<VisitorModel>;
      _announcement = results[3] as AnnouncementModel;
      _guard = results[4] as GuardContactModel;
      _banners = results[5] as List<BannerModel>; // <-- NEW

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

    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  void clearError() {
    _errorMessage = '';

    if (_state == DashboardState.error) {
      _state = DashboardState.initial;
      notifyListeners();
    }
  }
}