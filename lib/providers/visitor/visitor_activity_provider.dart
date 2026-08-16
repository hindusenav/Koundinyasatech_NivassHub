import 'package:flutter/foundation.dart';

import 'package:flutter_nivasshub/models/visitor/approval_activity_model.dart';
import 'package:flutter_nivasshub/services/visitor/visitor_activity_repository.dart';

enum VisitorActivityState { initial, loading, success, empty, error }

/// The filter-chip options on the Activities screen.
enum ActivityFilter { all, deliveries, visitors, wrong, preApproved }

extension ActivityFilterLabel on ActivityFilter {
  String get label {
    switch (this) {
      case ActivityFilter.all:
        return 'All';
      case ActivityFilter.deliveries:
        return 'Deliveries';
      case ActivityFilter.visitors:
        return 'Visitors';
      case ActivityFilter.wrong:
        return 'Wrong';
      case ActivityFilter.preApproved:
        return 'Pre-approved';
    }
  }
}

/// Owns the Activities screen's data: a single-shot load (no pagination) of
/// the gate/delivery log, plus the local, instant filter-chip and search
/// state layered on top of it — mirrors `QuickActionsProvider`'s style.
class VisitorActivityProvider extends ChangeNotifier {
  VisitorActivityProvider(this._repository);

  final VisitorActivityRepository _repository;

  VisitorActivityState _state = VisitorActivityState.initial;
  String? _errorMessage;
  List<ApprovalActivityModel> _activities = [];
  ActivityFilter _selectedFilter = ActivityFilter.all;
  String _searchQuery = '';

  VisitorActivityState get state => _state;
  String? get errorMessage => _errorMessage;
  ActivityFilter get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.trim().isNotEmpty;

  /// [_activities] narrowed by the selected chip, then by the search query —
  /// both are synchronous, in-memory filters (no API, no debounce).
  List<ApprovalActivityModel> get _filtered {
    Iterable<ApprovalActivityModel> result = _activities;

    switch (_selectedFilter) {
      case ActivityFilter.all:
        break;
      case ActivityFilter.deliveries:
        result = result.where((a) => a.type == 'delivery');
        break;
      case ActivityFilter.visitors:
        result = result.where((a) => a.type == 'visitor' || a.type == 'service');
        break;
      case ActivityFilter.wrong:
        result = result.where((a) => a.isWrongEntry);
        break;
      case ActivityFilter.preApproved:
        result = result.where((a) => a.isPreApproved);
        break;
    }

    if (isSearching) {
      final query = _searchQuery.trim().toLowerCase();
      result = result.where(
        (a) =>
            a.name.toLowerCase().contains(query) ||
            (a.company?.toLowerCase().contains(query) ?? false),
      );
    }

    return result.toList();
  }

  /// The filtered activities grouped by their `date` section label,
  /// preserving load order (today's group before yesterday's, etc.) — a
  /// plain `Map` literal is insertion-ordered in Dart, so no extra
  /// bookkeeping is needed to keep sections in the right sequence.
  Map<String, List<ApprovalActivityModel>> get groupedActivities {
    final grouped = <String, List<ApprovalActivityModel>>{};
    for (final activity in _filtered) {
      grouped.putIfAbsent(activity.date, () => []).add(activity);
    }
    return grouped;
  }

  /// True when the fetch succeeded but the current filter/search leaves
  /// nothing to show — distinct from [VisitorActivityState.empty], which
  /// means the fetch itself returned no records at all.
  bool get hasNoResultsForFilter =>
      _state == VisitorActivityState.success && _filtered.isEmpty;

  Future<void> loadActivities() async {
    _state = VisitorActivityState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getActivities();
    if (response.isSuccess && response.data != null) {
      _activities = response.data!;
      _state = _activities.isEmpty ? VisitorActivityState.empty : VisitorActivityState.success;
    } else {
      _errorMessage = response.message ?? 'Unable to load activities right now.';
      _state = VisitorActivityState.error;
    }

    notifyListeners();
  }

  Future<void> retry() => loadActivities();

  void selectFilter(ActivityFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() => setSearchQuery('');

  /// Toggles the local-only "Wrong Entry" flag for the activity with [id] —
  /// purely client-side until the backend defines a field/endpoint for
  /// flagging incorrect gate entries (see `ApprovalActivityModel.isWrongEntry`).
  void toggleWrongEntry(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return;

    _activities[index] = _activities[index].copyWith(
      isWrongEntry: !_activities[index].isWrongEntry,
    );
    notifyListeners();
  }
}
