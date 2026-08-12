import '../../../core/network/api_response.dart';
import '../models/active_society_model.dart';
import '../models/profile_address_model.dart';
import '../models/user_profile_model.dart';
import 'profile_service_base.dart';

/// Canned data matching the API contract's exact §2.2/§2.3 example
/// responses. No `ApiClient`/Dio dependency — selected via `useMockProfileApi`
/// in `profile_config.dart` until the real backend/base URL is published.
class MockProfileService implements ProfileServiceBase {
  @override
  Future<ApiResponse<UserProfileModel>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return ApiResponse.success(
      const UserProfileModel(
        userId: 'user_123',
        fullName: 'User 1',
        mobileNumber: '+919876543210',
        email: 'User1@gmail.com',
        address: ProfileAddressModel(
          flatHouseNo: 'B-402',
          societyBuildingName: 'Golden Residency',
          city: 'Mumbai',
          state: 'Maharashtra',
          pinCode: '400053',
        ),
      ),
    );
  }

  @override
  Future<ApiResponse<ActiveSocietyModel>> getActiveSociety() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ApiResponse.success(
      const ActiveSocietyModel(
        societyId: 'soc_123',
        name: 'Golden Residency',
        fullAddress: 'B-402 Golden Residency',
        city: 'Mumbai',
        state: 'Maharashtra',
      ),
    );
  }
}
