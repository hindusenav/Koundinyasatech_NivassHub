import 'package:flutter/foundation.dart';

import '../models/activity_type_filter_option.dart';
import '../repository/activity_type_filter_repository.dart';

/// Owns the "Filter Activity by Type" bottom sheet's state: a single-shot
/// load of the filter catalog (mirrors `QuickActionsProvider`'s bool-flag
/// style — no pagination, so a full state-machine enum is overkill) plus the
/// multi-select set the sheet's grid, "X filters active" count, and
/// "Clear All" all read from.
class ActivityTypeFilterProvider extends ChangeNotifier {
  ActivityTypeFilterProvider(this._repository, {Set<String> initialSelectedIds = const {}})
      : _selectedIds = {...initialSelectedIds};

  final ActivityTypeFilterRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<ActivityTypeFilterOption> _options = [];
  final Set<String> _selectedIds;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  List<ActivityTypeFilterOption> get options => List.unmodifiable(_options);
  bool get isEmpty => _options.isEmpty;

  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);
  int get selectedCount => _selectedIds.length;
  bool isSelected(String id) => _selectedIds.contains(id);

  Future<void> loadOptions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getFilterOptions();
    if (response.isSuccess && response.data != null) {
      _options = response.data!;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Unable to load filter options right now.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => loadOptions();

  void toggle(String id) {
    if (!_selectedIds.remove(id)) _selectedIds.add(id);
    notifyListeners();
  }

  void clearAll() {
    if (_selectedIds.isEmpty) return;
    _selectedIds.clear();
    notifyListeners();
  }
}
