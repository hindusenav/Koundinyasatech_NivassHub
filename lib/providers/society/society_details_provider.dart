import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/society/society_details_response.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';

enum SocietyDetailsState { initial, loading, success, error }

/// Drives the Tower → Floor → Unit cascade for one society, fetched as a
/// single tree from `GET /society/details?socid=` and sliced client-side —
/// unlike `LocationProvider`, no further network call happens per level.
class SocietyDetailsProvider extends ChangeNotifier {
  SocietyDetailsProvider(this._service);

  final SocietyServiceBase _service;

  SocietyDetailsState _state = SocietyDetailsState.initial;
  SocietyDetailsResponseData? _data;
  String? _errorMessage;
  String? _lastSocId;

  SocietyTower? _selectedTower;
  SocietyFloor? _selectedFloor;
  SocietyUnit? _selectedUnit;

  SocietyDetailsState get state => _state;
  bool get isLoading => _state == SocietyDetailsState.loading;
  String? get errorMessage => _errorMessage;

  List<SocietyTower> get towers => _data?.towers ?? const [];
  List<SocietyFloor> get floors => _selectedTower?.floors ?? const [];
  List<SocietyUnit> get units => _selectedFloor?.units ?? const [];

  SocietyTower? get selectedTower => _selectedTower;
  SocietyFloor? get selectedFloor => _selectedFloor;
  SocietyUnit? get selectedUnit => _selectedUnit;

  /// The registration form's "Unit Sub-Branch" — there is no separate API
  /// for it, so it is derived from the selected unit's `unitTypeBhk`
  /// (e.g. `"5bhk"`) rather than a free-text/second picker. Clears itself
  /// automatically whenever the unit selection is cleared, since it's not
  /// separate state.
  String? get selectedUnitBranch => _selectedUnit?.unitTypeBhk;

  bool get isTowerEnabled => _data != null;
  bool get isFloorEnabled => _selectedTower != null;
  bool get isUnitEnabled => _selectedFloor != null;

  Future<void> fetchSociety(String socId) async {
    _lastSocId = socId;
    _state = SocietyDetailsState.loading;
    _errorMessage = null;
    _data = null;
    _selectedTower = null;
    _selectedFloor = null;
    _selectedUnit = null;
    notifyListeners();

    final response = await _service.getSocietyDetails(socId);
    if (response.isSuccess && response.data != null) {
      _data = response.data!;
      _state = SocietyDetailsState.success;
    } else {
      _data = null;
      _errorMessage = response.message;
      _state = SocietyDetailsState.error;
    }
    notifyListeners();
  }

  Future<void> retry() {
    final socId = _lastSocId;
    if (socId == null) return Future.value();
    return fetchSociety(socId);
  }

  /// Called whenever an ancestor of Society (Country/State/City) changes,
  /// so this cascade doesn't keep showing a Tower→Floor→Unit tree that
  /// belonged to a society the user can no longer see selected.
  void reset() {
    _lastSocId = null;
    _state = SocietyDetailsState.initial;
    _data = null;
    _errorMessage = null;
    _selectedTower = null;
    _selectedFloor = null;
    _selectedUnit = null;
    notifyListeners();
  }

  void selectTower(SocietyTower tower) {
    if (_selectedTower == tower) return;
    _selectedTower = tower;
    _selectedFloor = null;
    _selectedUnit = null;
    notifyListeners();
  }

  void selectFloor(SocietyFloor floor) {
    if (_selectedFloor == floor) return;
    _selectedFloor = floor;
    _selectedUnit = null;
    notifyListeners();
  }

  void selectUnit(SocietyUnit unit) {
    _selectedUnit = unit;
    notifyListeners();
  }
}
