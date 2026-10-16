import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/society/add_user_to_society_request.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/services/society/add_society_service_base.dart';

enum AddPropertyState { initial, loading, ready, submitting, submitted, error }

/// Drives the Add Flat/Villa/Office form: loads
/// `GET /society/add-master-data` once, holds the Country → State → City →
/// Society and Role → Sub-role → Category selections, and submits
/// `POST /society/add-user`. Tower → Floor → Unit comes from the
/// `SocietyDetailsProvider` passed to [submit].
class AddPropertyProvider extends ChangeNotifier {
  AddPropertyProvider({
    required AddSocietyServiceBase service,
    required Future<String?> Function() readToken,
  }) : _service = service,
       _readToken = readToken;

  final AddSocietyServiceBase _service;
  final Future<String?> Function() _readToken;

  AddPropertyState _state = AddPropertyState.initial;
  RegistrationMasterData _data = RegistrationMasterData.empty;
  String? _errorMessage;
  String? _resultMessage;

  RegistrationCountry? _country;
  RegistrationState? _stateSel;
  String? _city;
  RegistrationSociety? _society;
  RegistrationRole? _role;
  RegistrationSubRole? _subRole;
  RegistrationCategory? _category;
  RegistrationKycDocument? _document;

  AddPropertyState get state => _state;
  bool get isLoading => _state == AddPropertyState.loading;
  bool get isSubmitting => _state == AddPropertyState.submitting;
  String? get errorMessage => _errorMessage;

  /// Server message of the last successful submit.
  String? get resultMessage => _resultMessage;

  List<RegistrationCountry> get countries => _data.countries;
  List<RegistrationRole> get roles => _data.roles;
  List<RegistrationKycDocument> get documents => _data.kycDocuments;

  RegistrationCountry? get selectedCountry => _country;
  RegistrationState? get selectedState => _stateSel;
  String? get selectedCity => _city;
  RegistrationSociety? get selectedSociety => _society;
  RegistrationRole? get selectedRole => _role;
  RegistrationSubRole? get selectedSubRole => _subRole;
  RegistrationCategory? get selectedCategory => _category;
  RegistrationKycDocument? get selectedDocument => _document;

  List<RegistrationState> get states => _country?.states ?? const [];

  /// Distinct `city` values of the societies in the selected state.
  List<String> get cities {
    final name = _stateSel?.provinceName;
    if (name == null) return const [];
    final cities = _data.societies
        .where((s) => s.state.toLowerCase() == name.toLowerCase())
        .map((s) => s.city)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    cities.sort();
    return cities;
  }

  List<RegistrationSociety> get societies {
    final city = _city;
    if (city == null) return const [];
    return _data.societies
        .where((s) => s.city.toLowerCase() == city.toLowerCase())
        .toList(growable: false);
  }

  List<RegistrationSubRole> get subRoles => _role?.subRoles ?? const [];
  List<RegistrationCategory> get categories =>
      _subRole?.categories ?? const [];
  bool get needsCategory => categories.isNotEmpty;

  Future<void> load() async {
    _state = AddPropertyState.loading;
    _errorMessage = null;
    notifyListeners();

    final token = await _readToken();
    if (token == null || token.isEmpty) {
      _fail('Your session has expired. Please log in again.');
      return;
    }

    final response = await _service.getMasterData(userToken: token);
    if (!response.isSuccess || response.data == null) {
      _fail(response.message ?? 'Unable to load property options.');
      return;
    }
    _data = response.data!;
    _state = AddPropertyState.ready;
    notifyListeners();
    // No `/kyc/user-documents` call here: it rejects the login token with a
    // 401, and the auth interceptor treats any 401 as a dead session and
    // logs the user out.
  }

  Future<void> retry() => load();

  void _fail(String message) {
    _data = RegistrationMasterData.empty;
    _errorMessage = message;
    _state = AddPropertyState.error;
    notifyListeners();
  }

  void selectCountry(RegistrationCountry country) {
    if (_country?.countryCode == country.countryCode) return;
    _country = country;
    _stateSel = null;
    _city = null;
    _society = null;
    notifyListeners();
  }

  void selectState(RegistrationState state) {
    _stateSel = state;
    _city = null;
    _society = null;
    notifyListeners();
  }

  void selectCity(String city) {
    if (_city == city) return;
    _city = city;
    _society = null;
    notifyListeners();
  }

  void selectSociety(RegistrationSociety society) {
    _society = society;
    notifyListeners();
  }

  void selectRole(RegistrationRole role) {
    if (_role?.roleId == role.roleId) return;
    _role = role;
    _subRole = null;
    _category = null;
    notifyListeners();
  }

  void selectSubRole(RegistrationSubRole subRole) {
    if (_subRole?.subRoleId == subRole.subRoleId) return;
    _subRole = subRole;
    _category = null;
    notifyListeners();
  }

  void selectCategory(RegistrationCategory category) {
    _category = category;
    notifyListeners();
  }

  void selectDocument(RegistrationKycDocument document) {
    _document = document;
    notifyListeners();
  }

  /// First missing-field message, or `null` when the form is complete.
  String? validate({
    required SocietyTower? tower,
    required SocietyFloor? floor,
    required SocietyUnit? unit,
  }) {
    if (_country == null || _stateSel == null || _city == null) {
      return 'Please select your country, state and city.';
    }
    if (_society == null || tower == null || floor == null || unit == null) {
      return 'Please select the society, tower, floor and unit.';
    }
    if (_role == null) return 'Please select your role.';
    return null;
  }

  /// Returns `true` on success; [resultMessage] / [errorMessage] hold the
  /// server text either way.
  Future<bool> submit({
    required SocietyTower tower,
    required SocietyFloor floor,
    required SocietyUnit unit,
  }) async {
    _state = AddPropertyState.submitting;
    _errorMessage = null;
    notifyListeners();

    final token = await _readToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Your session has expired. Please log in again.';
      _state = AddPropertyState.ready;
      notifyListeners();
      return false;
    }

    final response = await _service.addUserToSociety(
      AddUserToSocietyRequest(
        userToken: token,
        countryCode: _country!.countryCode,
        stateCode: _stateSel!.provinceId,
        city: _city!,
        socId: _society!.socId,
        towerId: tower.towerId,
        floor: floor.floorId,
        unitId: unit.unitId,
        userType: _role!.roleId,
        userSubRole: _subRole?.subRoleId,
        userCat: needsCategory ? _category?.categoryId : null,
        documentId: _document?.id,
      ),
    );

    if (response.isSuccess) {
      _resultMessage = response.data;
      _state = AddPropertyState.submitted;
      notifyListeners();
      return true;
    }
    _errorMessage = response.message ?? 'Unable to add the property.';
    _state = AddPropertyState.ready;
    notifyListeners();
    return false;
  }
}
