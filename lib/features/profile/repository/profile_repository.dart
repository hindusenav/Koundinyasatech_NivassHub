import '../models/address_model.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  /// Simulates fetching user profile data from a backend API or local database.
  Future<ProfileModel> fetchProfile() async {
    // Simulating network latency
    await Future.delayed(const Duration(milliseconds: 500));

    return const ProfileModel(
      userName: 'John Doe',
      bio: 'Software Engineer & Tech Enthusiast',
      work: 'Lead Frontend Developer',
      enableCalls: true,
      tags: ['B-402', 'Tenant'],
      interests: ['Coding', 'UI/UX Design', 'Flutter'],
      address: AddressModel(
        flatNo: 'B-402',
        societyName: 'Golden Residency',
        wing: 'Tower B',
        street: 'MG Road',
        area: 'Andheri West',
        landmark: 'Near City Mall',
        city: 'Mumbai',
        state: 'Maharashtra',
        pinCode: '400053',
      ),
    );
  }

  /// Simulates persisting updated profile details to the remote API or DB.
  Future<bool> saveProfile(ProfileModel profile) async {
    // Simulating network processing
    await Future.delayed(const Duration(milliseconds: 800));

    // Perform validation or backend call payload creation here
    try {
      // e.g., await apiService.post('/profile', data: profile.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Simulates updating specifically the address details.
  Future<bool> updateAddress(AddressModel address) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // e.g., await apiService.put('/profile/address', data: address.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}