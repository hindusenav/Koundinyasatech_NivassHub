import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';

enum RegistrationDataState { initial, loading, success, error }

/// Loads `GET /country-codes/user-registration` once and serves the
/// State and Society pickers on the User Details screen from the cached
/// result — no further network calls for either.
class RegistrationMasterDataProvider extends ChangeNotifier {
  RegistrationMasterDataProvider(this._service);

  final RegistrationServiceBase _service;

  RegistrationDataState _state = RegistrationDataState.initial;
  RegistrationMasterData _data = RegistrationMasterData.empty;
  String? _errorMessage;

  String? _selectedCountryCode;
  RegistrationState? _selectedState;
  String? _selectedCity;
  RegistrationSociety? _selectedSociety;

  RegistrationDataState get state => _state;
  bool get isLoading => _state == RegistrationDataState.loading;
  String? get errorMessage => _errorMessage;

  /// Societies in the selected city only — `[]` until a city is chosen,
  /// same as every other level of this cascade.
  List<RegistrationSociety> get societies {
    final city = _selectedCity;
    if (city == null) return const [];
    return _data.societies
        .where((s) => s.city.toLowerCase() == city.toLowerCase())
        .toList(growable: false);
  }

  RegistrationSociety? get selectedSociety => _selectedSociety;

  RegistrationState? get selectedState => _selectedState;
  String? get selectedCity => _selectedCity;

  /// The states of whichever country was last passed to [selectCountry] —
  /// `[]` until a country has been chosen.
  List<RegistrationState> get statesForSelectedCountry {
    final code = _selectedCountryCode;
    if (code == null) return const [];
    for (final country in _data.countries) {
      if (country.countryCode == code) return country.states;
    }
    return const [];
  }

  /// The distinct `city` values of societies in the selected state — the
  /// City picker's only source, since `GET /country-codes/user-registration`
  /// has no dedicated city list; `Societies[].city` is what we have.
  List<String> get citiesForSelectedState {
    final stateName = _selectedState?.provinceName;
    if (stateName == null) return const [];
    final cities = _data.societies
        .where((s) => s.state.toLowerCase() == stateName.toLowerCase())
        .map((s) => s.city)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    cities.sort();
    return cities;
  }

  /// The `Roles[]` entry matching [role]'s wire value ("R" for
  /// [UserRole.owner]/Resident, "T" for [UserRole.tenant]) — `null` until
  /// master data has loaded, or if the backend ever stops sending that
  /// role. Looked up dynamically each call rather than cached by id, so a
  /// backend renumbering of `role_id` is picked up automatically.
  String? roleIdFor(UserRole role) {
    final wireName = role == UserRole.owner ? 'R' : 'T';
    for (final r in _data.roles) {
      if (r.name.toUpperCase() == wireName) return r.roleId;
    }
    return null;
  }

  Future<void> load() async {
    _state = RegistrationDataState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getMasterData();
    if (response.isSuccess && response.data != null) {
      _data = response.data!;
      _state = RegistrationDataState.success;
    } else {
      _data = RegistrationMasterData.empty;
      _errorMessage = response.message;
      _state = RegistrationDataState.error;
    }
    notifyListeners();
  }

  Future<void> retry() => load();

  /// Called whenever the Country picker's selection changes. Clears the
  /// previously chosen State/City/Society, since they belonged to the old
  /// country.
  void selectCountry(String countryCode) {
    if (_selectedCountryCode == countryCode) return;
    _selectedCountryCode = countryCode;
    _selectedState = null;
    _selectedCity = null;
    _selectedSociety = null;
    notifyListeners();
  }

  /// Clears the previously chosen City/Society, since they belonged to the
  /// old state.
  void selectState(RegistrationState state) {
    _selectedState = state;
    _selectedCity = null;
    _selectedSociety = null;
    notifyListeners();
  }

  /// Clears the previously chosen Society, since it belonged to the old
  /// city.
  void selectCity(String city) {
    if (_selectedCity == city) return;
    _selectedCity = city;
    _selectedSociety = null;
    notifyListeners();
  }

  void selectSociety(RegistrationSociety society) {
    _selectedSociety = society;
    notifyListeners();
  }
}
