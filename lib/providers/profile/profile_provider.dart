import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/models/profile/address_model.dart';
import 'package:flutter_nivasshub/models/profile/profile_model.dart';
import 'package:flutter_nivasshub/services/profile/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileProvider({ProfileRepository? repository})
      : repository = repository ?? ProfileRepository();

  ProfileModel _profile = const ProfileModel();
  bool _isLoading = false;

  ProfileModel get profile => _profile;
  bool get isLoading => _isLoading;

  // Add this method to fix the 'updateUserName' error
  void updateUserName(String name) {
    _profile = _profile.copyWith(userName: name);
    notifyListeners();
  }

  void toggleEnableCalls(bool value) {
    _profile = _profile.copyWith(enableCalls: value);
    notifyListeners();
  }

  void updateBio(String bio) {
    _profile = _profile.copyWith(bio: bio);
    notifyListeners();
  }

  void updateWork(String work) {
    _profile = _profile.copyWith(work: work);
    notifyListeners();
  }

  void addInterest(String interest) {
    if (interest.isNotEmpty && !_profile.interests.contains(interest)) {
      final updatedInterests = List<String>.from(_profile.interests)..add(interest);
      _profile = _profile.copyWith(interests: updatedInterests);
      notifyListeners();
    }
  }

  void updateAddress(AddressModel newAddress) {
    _profile = _profile.copyWith(address: newAddress);
    notifyListeners();
  }

  Future<void> saveProfileData() async {
    _isLoading = true;
    notifyListeners();

    await repository.saveProfile(_profile);

    _isLoading = false;
    notifyListeners();
  }
}