import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/family/add_family.dart';
import 'package:flutter_nivasshub/models/family/family_relation.dart';

abstract class FamilyServiceBase {
  /// `GET /get-family` — relation categories for the Add Family form.
  Future<ApiResponse<FamilyRelationsData>> getRelations();

  /// `POST /get-family/add-family`.
  Future<ApiResponse<AddFamilyResult>> addFamily(AddFamilyRequest request);
}
