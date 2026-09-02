import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';

/// Contract for the Search screen's data needs. No real search endpoint
/// exists yet per the API contract, so [MockSearchService] is the only
/// implementation today — a real implementation can be dropped in later
/// with no changes to the provider or screen.
abstract class SearchServiceBase {
  Future<ApiResponse<List<AppFeatureModel>>> getPopularSearches();

  Future<ApiResponse<List<AppFeatureModel>>> search(String query);
}
