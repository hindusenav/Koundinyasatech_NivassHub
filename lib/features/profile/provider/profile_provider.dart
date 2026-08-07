import 'package:flutter/material.dart';
import '../repository/profile_repository.dart';
import '../models/profile_model.dart';
import '../models/address_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileProvider(this.repository);

  ProfileModel? profile;
  AddressModel? address;

  bool isLoading = false;
  String? error;

  /// 🔹 Load Profile
  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      profile = await repository.getProfile();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Load Address
  Future<void> loadAddress() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      address = await repository.getAddress();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 UPDATE PROFILE ✅ (FINAL FIX - SAFE & FLEXIBLE)
  Future<void> updateProfile({
    String? name,
    String? mobile,
    String? email,
  }) async {
    if (profile == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updated = profile!.copyWith(
        name: name,
        mobile: mobile,
        email: email,
      );

      await repository.updateProfile(updated);

      /// ✅ Update local state
      profile = updated;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 CLEAR PROFILE
  void clearProfile() {
    profile = null;
    address = null;
    error = null;
    notifyListeners();
  }
}