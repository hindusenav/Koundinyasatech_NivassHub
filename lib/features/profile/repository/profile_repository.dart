import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/profile_model.dart';
import '../models/address_model.dart';

class ProfileRepository {

  Future<ProfileModel> getProfile() async {
    final response =
        await rootBundle.loadString('assets/mock/profile/profile.json');

    final data = json.decode(response);

    return ProfileModel.fromJson(data['data']);
  }

  Future<AddressModel> getAddress() async {
    final response =
        await rootBundle.loadString('assets/mock/profile/address.json');

    final data = json.decode(response);

    return AddressModel.fromJson(data['data']);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}