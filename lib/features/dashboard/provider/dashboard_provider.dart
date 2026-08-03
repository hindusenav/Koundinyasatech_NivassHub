import 'package:flutter/foundation.dart';

import '../models/dashboard_summary_model.dart';
import '../repository/dashboard_service.dart';

enum DashboardLoadStatus {
  initial,
  loading,
  loaded,
  error,
}

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    required DashboardService dashboardService,
  }) : _dashboardService = dashboardService;

  final DashboardService _dashboardService;

  DashboardLoadStatus _status = DashboardLoadStatus.initial;

  DashboardSummaryModel? _summary;
  String? _errorMessage;

  bool _isLoading = false;

  DashboardLoadStatus get status => _status;

  DashboardSummaryModel? get summary => _summary;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get hasError => _status == DashboardLoadStatus.error;

  Future<void> loadSummary() async {
    _status = DashboardLoadStatus.loading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dashboardService.getSummary();

      if (response.isSuccess && response.data != null) {
        _summary = response.data;
        _status = DashboardLoadStatus.loaded;
      } else {
        _errorMessage = response.message;
        _status = DashboardLoadStatus.error;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = DashboardLoadStatus.error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Compatibility method for the new dashboard widgets.
  Future<void> loadDashboard() async {
    await loadSummary();
  }

  Future<void> refresh() async {
    await loadSummary();
  }
}