import 'package:flutter/foundation.dart';

import '../../../core/utils/debouncer.dart';
import '../../../shared/models/app_feature_model.dart';
import '../repository/search_service_base.dart';

/// Owns the Search screen's state — popular searches (loaded once) and live
/// query results (debounced). Owns its own [Debouncer] rather than relying
/// on `SearchField`'s built-in one, since the debounce belongs to this
/// provider's business logic, not the dumb text-field widget.
class SearchProvider extends ChangeNotifier {
  SearchProvider(this._service);

  final SearchServiceBase _service;
  final Debouncer _debouncer = Debouncer(duration: const Duration(milliseconds: 400));

  bool _isLoadingPopular = false;
  bool _isSearching = false;
  String? _errorMessage;
  List<AppFeatureModel> _popularSearches = [];
  List<AppFeatureModel> _results = [];
  String _query = '';

  bool get isLoadingPopular => _isLoadingPopular;
  bool get isSearching => _isSearching;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  List<AppFeatureModel> get popularSearches => List.unmodifiable(_popularSearches);
  List<AppFeatureModel> get results => List.unmodifiable(_results);
  String get query => _query;
  bool get hasQuery => _query.trim().isNotEmpty;
  bool get isEmpty => hasQuery && !_isSearching && _results.isEmpty;

  Future<void> loadPopularSearches() async {
    _isLoadingPopular = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getPopularSearches();
    if (response.isSuccess && response.data != null) {
      _popularSearches = response.data!;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Something went wrong. Please try again.';
    }

    _isLoadingPopular = false;
    notifyListeners();
  }

  void onQueryChanged(String value) {
    _query = value;
    notifyListeners();

    if (value.trim().isEmpty) {
      _results = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _debouncer.run(() => _search(value));
  }

  Future<void> _search(String value) async {
    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.search(value);
    if (response.isSuccess && response.data != null) {
      _results = response.data!;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Something went wrong. Please try again.';
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> retry() {
    if (hasQuery) return _search(_query);
    return loadPopularSearches();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
