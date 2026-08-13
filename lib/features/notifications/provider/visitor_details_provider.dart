import 'package:flutter/foundation.dart';

import '../models/visitor_details_model.dart';
import '../repository/visitor_details_repository.dart';

enum VisitorDetailsState { initial, loading, success, error }

/// Owns the "Delivery Details" screen's own fetch state. Scoped to the
/// screen's lifetime — created fresh in `DeliveryDetailsScreen.build` and
/// disposed automatically when its `ChangeNotifierProvider` is removed from
/// the tree (i.e. when the screen is popped).
class VisitorDetailsProvider extends ChangeNotifier {
  VisitorDetailsProvider(this._repository);

  final VisitorDetailsRepository _repository;

  VisitorDetailsState _state = VisitorDetailsState.initial;
  String? _errorMessage;
  VisitorDetailsModel? _details;
  bool _isLeavingAtGate = false;
  String? _visitorId;

  VisitorDetailsState get state => _state;
  String? get errorMessage => _errorMessage;
  VisitorDetailsModel? get details => _details;
  bool get isLoading =>
      _state == VisitorDetailsState.initial || _state == VisitorDetailsState.loading;
  bool get hasError => _state == VisitorDetailsState.error;
  bool get isLeavingAtGate => _isLeavingAtGate;

  Future<void> loadDetails(String visitorId) async {
    _visitorId = visitorId;
    _state = VisitorDetailsState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getVisitorDetails(visitorId);
    if (response.isSuccess && response.data != null) {
      _details = response.data;
      _state = VisitorDetailsState.success;
    } else {
      _errorMessage = response.message ?? 'Unable to load visitor details right now.';
      _state = VisitorDetailsState.error;
    }
    notifyListeners();
  }

  /// Retries the last fetch — wired to `CustomErrorWidget.onRetry`.
  Future<void> retry() {
    final visitorId = _visitorId;
    if (visitorId == null) return Future.value();
    return loadDetails(visitorId);
  }

  /// "Leave at Gate" — mock-only (see `VisitorDetailsServiceBase.leaveAtGate`
  /// doc comment). Returns success/failure so the sheet can show the right
  /// snackbar. Deliberately does not touch `DashboardProvider`/Approval
  /// Queue — there is no spec for that yet, and overreaching here would
  /// duplicate/guess at behavior nobody has asked for.
  Future<bool> leaveAtGate() async {
    final current = _details;
    if (current == null || _isLeavingAtGate) return false;

    _isLeavingAtGate = true;
    notifyListeners();

    final response = await _repository.leaveAtGate(current.id);

    _isLeavingAtGate = false;
    if (!response.isSuccess) {
      _errorMessage = response.message ?? 'Something went wrong. Please try again.';
    }
    notifyListeners();

    return response.isSuccess;
  }
}
