import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/add_user_to_society_request.dart';

/// Add User to Society: form master data and the submit call.
abstract class AddSocietyServiceBase {
  /// `GET /society/add-master-data?user_token=` — countries (with states),
  /// societies and roles, parsed like the registration master data.
  Future<ApiResponse<RegistrationMasterData>> getMasterData({
    required String userToken,
  });

  /// `POST /society/add-user`. The response carries the server's message
  /// (e.g. "Unit added successfully and is pending approval").
  Future<ApiResponse<String>> addUserToSociety(AddUserToSocietyRequest request);
}
