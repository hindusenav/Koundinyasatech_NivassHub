import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/society/society_details_response.dart';

/// `GET /society/details?socid=` — one society's full Tower→Floor→Unit
/// tree, fetched once and sliced client-side by `SocietyDetailsProvider`.
abstract class SocietyServiceBase {
  Future<ApiResponse<SocietyDetailsResponseData>> getSocietyDetails(String socId);
}
