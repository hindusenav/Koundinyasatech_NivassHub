import 'package:flutter/foundation.dart';

import 'package:flutter_nivasshub/models/quick_actions/quick_action_section_model.dart';
import 'package:flutter_nivasshub/repositories/quick_actions/quick_actions_repository.dart';

/// Owns the Quick Actions catalog — a single-shot load (no pagination), so
/// bool-flag state is enough (mirrors `NoticesProvider`'s style rather than
/// an enum-status flow) — plus the local, instant search-filter state.
/// Filtering is synchronous and in-memory (no API, no debounce) since it
/// only ever narrows the already-loaded catalog.
class QuickActionsProvider extends ChangeNotifier {
  QuickActionsProvider(this._repository);

  final QuickActionsRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<QuickActionSectionModel> _sections = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  List<QuickActionSectionModel> get sections => List.unmodifiable(_sections);
  bool get isEmpty => _sections.isEmpty;

  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.trim().isNotEmpty;

  /// [sections] filtered to items whose title matches [searchQuery]
  /// (case-insensitive substring match), with any section left empty by the
  /// filter dropped entirely — its header/action-link disappears along with
  /// its items. Returns [sections] unchanged when there's no active query.
  List<QuickActionSectionModel> get filteredSections {
    if (!isSearching) return sections;

    final query = _searchQuery.trim().toLowerCase();
    return _sections
        .map(
          (section) => QuickActionSectionModel(
            id: section.id,
            title: section.title,
            actionLabel: section.actionLabel,
            items: section.items.where((item) => item.title.toLowerCase().contains(query)).toList(),
          ),
        )
        .where((section) => section.items.isNotEmpty)
        .toList();
  }

  Future<void> loadQuickActions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getQuickActions();
    if (response.isSuccess && response.data != null) {
      _sections = response.data!;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Something went wrong. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => loadQuickActions();

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() => setSearchQuery('');
}
