import '../models/address_model.dart';
import '../models/announcement_model.dart';
import '../models/guard_contact_model.dart';
import '../models/home_response_model.dart';
import '../models/visitor_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  DashboardRepository(this._service);

  final DashboardService _service;

  Future<HomeResponseModel> getHome() async {
    final json =
        await _service.loadJson('assets/json/home.json');

    return HomeResponseModel.fromJson(json);
  }

  Future<List<AddressModel>> getAddresses() async {
    final json =
        await _service.loadJson('assets/json/addresses.json');

    final list = json['data'] as List;

    return list
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  Future<List<VisitorModel>> getPendingVisitors() async {
    final json = await _service.loadJson(
      'assets/json/pending_visitors.json',
    );

    final list = json['data'] as List;

    return list
        .map((e) => VisitorModel.fromJson(e))
        .toList();
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
}