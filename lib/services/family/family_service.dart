import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/family/add_family.dart';
import 'package:flutter_nivasshub/models/family/family_relation.dart';
import 'package:flutter_nivasshub/services/family/family_service_base.dart';

/// Dio-backed `GET /get-family` and `POST /get-family/add-family`. The Bearer
/// token is added by the auth interceptor.
class FamilyService extends ApiService implements FamilyServiceBase {
  const FamilyService(super.client);

  static Map<String, dynamic> _asMap(dynamic json) =>
      json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};

  @override
  Future<ApiResponse<FamilyRelationsData>> getRelations() {
    return handleRequest(
      () => client.get(ApiEndpoints.getFamily),
      (json) => FamilyRelationsData.fromJson(_asMap(json)),
    );
  }

  @override
  Future<ApiResponse<AddFamilyResult>> addFamily(AddFamilyRequest request) {
    return handleRequest(
      () => client.post(ApiEndpoints.addFamily, data: request.toJson()),
      (json) => AddFamilyResult.fromJson(_asMap(json)),
    );
  }
}
