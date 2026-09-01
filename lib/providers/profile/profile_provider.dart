import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/models/profile/address_model.dart';
import 'package:flutter_nivasshub/models/profile/profile_model.dart';
import 'package:flutter_nivasshub/services/profile/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileProvider({
    ProfileRepository? repository,
  }) : repository = repository ?? ProfileRepository();

  ProfileModel _profile = const ProfileModel();

  bool _isLoading = false;

  ProfileModel get profile => _profile;

  bool get isLoading => _isLoading;

  // ============================================================
  // USER NAME
  // ============================================================

  void updateUserName(String name) {
    _profile = _profile.copyWith(
      userName: name,
    );

    notifyListeners();
  }

  // ============================================================
  // ENABLE CALLS
  // ============================================================

  void toggleEnableCalls(bool value) {
    _profile = _profile.copyWith(
      enableCalls: value,
    );

    notifyListeners();
  }

  // ============================================================
  // BIO
  // ============================================================

  void updateBio(String bio) {
    _profile = _profile.copyWith(
      bio: bio,
    );

    notifyListeners();
  }

  // ============================================================
  // WORK
  // ============================================================

  void updateWork(String work) {
    _profile = _profile.copyWith(
      work: work,
    );

    notifyListeners();
  }

  // ============================================================
  // ADDRESS
  // ============================================================

  void updateAddress(AddressModel newAddress) {
    _profile = _profile.copyWith(
      address: newAddress,
    );

    notifyListeners();
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  void updateProfileImage(String imagePath) {
    _profile = _profile.copyWith(
      profileImagePath: imagePath,
    );

    notifyListeners();
  }

  // ============================================================
  // COVER IMAGE
  // ============================================================

  void updateCoverImage(String imagePath) {
    _profile = _profile.copyWith(
      coverImagePath: imagePath,
    );

    notifyListeners();
  }

  // ============================================================
  // INTERESTS
  // ============================================================

  void addInterest(String interest) {
    final trimmedInterest = interest.trim();

    if (trimmedInterest.isEmpty) return;

    if (!_profile.interests.contains(trimmedInterest)) {
      final updatedInterests =
          List<String>.from(_profile.interests);

      updatedInterests.add(trimmedInterest);

      _profile = _profile.copyWith(
        interests: updatedInterests,
      );

      notifyListeners();
    }
  }

  void removeInterest(String interest) {
    final updatedInterests =
        List<String>.from(_profile.interests);

    updatedInterests.remove(interest);

    _profile = _profile.copyWith(
      interests: updatedInterests,
    );

    notifyListeners();
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> saveProfileData() async {
    _isLoading = true;

    notifyListeners();

    try {
      await repository.saveProfile(_profile);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}