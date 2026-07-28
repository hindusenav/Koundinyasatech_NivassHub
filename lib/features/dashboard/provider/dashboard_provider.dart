import 'package:flutter/foundation.dart';
import '../models/dashboard_summary_model.dart';
import '../repository/dashboard_service.dart';

enum DashboardLoadStatus { initial, loading, loaded, error }

/// Owns the dashboard summary — loading/error/data/refresh, per the
/// standard provider contract every feature provider follows.
class DashboardProvider extends ChangeNotifier {
  DashboardProvider({required DashboardService dashboardService})
      : _dashboardService = dashboardService;

  final DashboardService _dashboardService;

  DashboardLoadStatus _status = DashboardLoadStatus.initial;
  DashboardSummaryModel? _summary;
  String? _errorMessage;

  DashboardLoadStatus get status => _status;
  DashboardSummaryModel? get summary => _summary;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == DashboardLoadStatus.loading;
  bool get hasError => _status == DashboardLoadStatus.error;

  Future<void> loadSummary() async {
    _status = DashboardLoadStatus.loading;
    notifyListeners();

    final response = await _dashboardService.getSummary();

    if (response.isSuccess && response.data != null) {
      _summary = response.data;
      _status = DashboardLoadStatus.loaded;
    } else {
      _errorMessage = response.message;
      _status = DashboardLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => loadSummary();
}
