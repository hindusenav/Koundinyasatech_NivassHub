import 'package:flutter/foundation.dart';

import '../models/active_society_model.dart';
import '../models/user_profile_model.dart';
import '../repository/profile_service_base.dart';

/// Owns the Profile screen's data — loads the profile and active-society
/// calls concurrently and only surfaces a blocking error if **both** fail;
/// a partial success still renders whatever loaded (mirrors
/// `NoticesProvider._fetchFeed`'s "allFailed" pattern).
class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._service);

  final ProfileServiceBase _service;

  bool _isLoading = false;
  String? _errorMessage;
  UserProfileModel? _profile;
  ActiveSocietyModel? _activeSociety;
  bool _profileFailed = false;
  bool _activeSocietyFailed = false;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  UserProfileModel? get profile => _profile;
  ActiveSocietyModel? get activeSociety => _activeSociety;
  bool get profileFailed => _profileFailed;
  bool get activeSocietyFailed => _activeSocietyFailed;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final profileFuture = _service.getProfile();
    final societyFuture = _service.getActiveSociety();

    final profileResponse = await profileFuture;
    final societyResponse = await societyFuture;

    final allFailed = profileResponse.isFailure && societyResponse.isFailure;
    if (allFailed) {
      _errorMessage = profileResponse.message ??
          societyResponse.message ??
          'Something went wrong. Please try again.';
    } else {
      _errorMessage = null;
      if (profileResponse.isSuccess) _profile = profileResponse.data;
      if (societyResponse.isSuccess) _activeSociety = societyResponse.data;
    }
    _profileFailed = profileResponse.isFailure;
    _activeSocietyFailed = societyResponse.isFailure;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => loadProfile();
}
