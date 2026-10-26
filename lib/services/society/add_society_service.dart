import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/add_user_to_society_request.dart';
import 'package:flutter_nivasshub/services/society/add_society_service_base.dart';

/// Dio-backed `GET /society/add-master-data` and `POST /society/add-user`.
class AddSocietyService extends ApiService implements AddSocietyServiceBase {
  const AddSocietyService(super.client);

  @override
  Future<ApiResponse<RegistrationMasterData>> getMasterData({
    required String userToken,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.addSocietyMasterData,
        queryParameters: {'user_token': userToken},
      ),
      (json) {
        final map = json is Map ? Map<String, dynamic>.from(json) : const {};
        final data = map['data'];
        return RegistrationMasterData.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        );
      },
    );
  }

  @override
  Future<ApiResponse<String>> addUserToSociety(
    AddUserToSocietyRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.addUserToSociety, data: request.toJson()),
      (json) {
        final map = json is Map ? json : const {};
        return map['message']?.toString() ??
            'Unit added successfully and is pending approval';
      },
    );
  }
}
