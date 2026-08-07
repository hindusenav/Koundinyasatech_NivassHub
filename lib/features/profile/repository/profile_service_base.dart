import '../../../core/network/api_response.dart';
import '../models/active_society_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileServiceBase {
  Future<ApiResponse<UserProfileModel>> getProfile();

  Future<ApiResponse<ActiveSocietyModel>> getActiveSociety();
}
