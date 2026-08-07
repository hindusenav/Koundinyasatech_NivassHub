import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/json_asset_loader.dart';
import '../../../shared/models/app_feature_model.dart';
import 'search_service_base.dart';

/// Simulates search over the app's feature catalog. Reads two independent
/// JSON fixtures — `popular_searches.json` for the curated empty-state list,
/// and `quick_actions.json` (the same fixture `quick_actions` reads) as the
/// flattened, filterable corpus, so a renamed tile there doesn't silently
/// drift out of sync with what search finds. No Dart-level dependency on the
/// `quick_actions` feature's classes — just two mocks over shared assets.
class MockSearchService implements SearchServiceBase {
  static const String _popularSearchesAssetPath = 'assets/json/popular_searches.json';
  static const String _catalogAssetPath = 'assets/json/quick_actions.json';

  List<AppFeatureModel>? _cachedCatalog;

  @override
  Future<ApiResponse<List<AppFeatureModel>>> getPopularSearches() async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final rawItems = await JsonAssetLoader.loadList(_popularSearchesAssetPath);
      final items = rawItems
          .map((e) => AppFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(items);
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to load popular searches right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<List<AppFeatureModel>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final catalog = await _loadCatalog();
      final normalized = query.trim().toLowerCase();
      final results = normalized.isEmpty
          ? <AppFeatureModel>[]
          : catalog.where((item) => item.title.toLowerCase().contains(normalized)).toList();
      return ApiResponse.success(results);
    } catch (_) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Unable to search right now.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }

  Future<List<AppFeatureModel>> _loadCatalog() async {
    final cached = _cachedCatalog;
    if (cached != null) return cached;

    final map = await JsonAssetLoader.loadMap(_catalogAssetPath);
    final rawSections = map['sections'] as List<dynamic>? ?? [];
    final items = <AppFeatureModel>[];
    for (final rawSection in rawSections) {
      final rawItems = (rawSection as Map<String, dynamic>)['items'] as List<dynamic>? ?? [];
      items.addAll(rawItems.map((e) => AppFeatureModel.fromJson(e as Map<String, dynamic>)));
    }

    _cachedCatalog = items;
    return items;
  }
}
