import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/society/society_details_response.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';

/// Dio-backed implementation of `GET /society/details?socid=` — confirmed
/// real and documented (live sample seen for `socid=33`).
class SocietyService extends ApiService implements SocietyServiceBase {
  const SocietyService(super.client);

  @override
  Future<ApiResponse<SocietyDetailsResponseData>> getSocietyDetails(
    String socId,
  ) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.societyDetails,
        queryParameters: {'socid': socId},
      ),
      (json) {
        final map = json as Map<String, dynamic>;
        final data = map['data'];
        return SocietyDetailsResponseData.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        );
      },
    );
  }
}
