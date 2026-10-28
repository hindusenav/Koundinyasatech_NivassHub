import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/vehicle/add_vehicle.dart';
import 'package:flutter_nivasshub/models/vehicle/vehicle_brand.dart';
import 'package:flutter_nivasshub/services/vehicle/vehicle_service_base.dart';

enum VehicleState { initial, loading, ready, error }

/// Drives the vehicles screen: loads `GET /vehicle-brands` once and holds the
/// 2W/4W toggle, search query and the selected brand.
class VehicleProvider extends ChangeNotifier {
  VehicleProvider({
    required VehicleServiceBase service,
    required Future<String?> Function() readToken,
  }) : _service = service,
       _readToken = readToken;

  final VehicleServiceBase _service;
  final Future<String?> Function() _readToken;

  bool _isSaving = false;
  String? _saveError;

  VehicleState _state = VehicleState.initial;
  VehicleBrandsData _data = VehicleBrandsData.empty;
  String? _errorMessage;
  VehicleType _type = VehicleType.twoWheeler;
  String _query = '';
  VehicleBrand? _selected;

  VehicleState get state => _state;
  bool get isLoading => _state == VehicleState.loading;
  String? get errorMessage => _errorMessage;
  VehicleType get type => _type;
  VehicleBrand? get selected => _selected;
  VehicleBrandsData get data => _data;

  /// Brands of the active type matching the search, sorted A-Z.
  List<VehicleBrand> get brands {
    final q = _query.trim().toLowerCase();
    final list = _data
        .brandsOf(_type)
        .where((b) => q.isEmpty || b.vehicleBrand.toLowerCase().contains(q))
        .toList();
    list.sort(
      (a, b) =>
          a.vehicleBrand.toLowerCase().compareTo(b.vehicleBrand.toLowerCase()),
    );
    return list;
  }

  Future<void> load() async {
    _state = VehicleState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getVehicleBrands();
    if (!response.isSuccess || response.data == null) {
      _data = VehicleBrandsData.empty;
      _errorMessage = response.message ?? 'Unable to load vehicle brands.';
      _state = VehicleState.error;
    } else {
      _data = response.data!;
      _state = VehicleState.ready;
    }
    notifyListeners();
  }

  Future<void> retry() => load();

  void selectType(VehicleType type) {
    if (_type == type) return;
    _type = type;
    notifyListeners();
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void select(VehicleBrand brand) {
    _selected = _selected == brand ? null : brand;
    notifyListeners();
  }

  bool get isSaving => _isSaving;

  /// Server (or session) message of the last failed [addVehicle].
  String? get saveError => _saveError;

  void clearSaveError() {
    if (_saveError == null) return;
    _saveError = null;
    notifyListeners();
  }

  /// `POST /vehicle/add` for the selected brand. Returns the allotted slot
  /// details on success, or null with [saveError] set.
  Future<AddVehicleResult?> addVehicle({
    required String registrationNumber,
    required String model,
    required String colour,
    required int parkingZoneId,
  }) async {
    final brand = _selected;
    if (brand == null || _isSaving) return null;

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    final token = await _readToken();
    if (token == null || token.isEmpty) {
      _saveError = 'Your session has expired. Please log in again.';
      _isSaving = false;
      notifyListeners();
      return null;
    }

    final response = await _service.addVehicle(
      AddVehicleRequest(
        userToken: token,
        vehicleType: brand.vehicleType,
        registrationNumber: registrationNumber,
        brandId: brand.brandId,
        model: model,
        colour: colour,
        parkingZoneId: parkingZoneId,
      ),
    );

    _isSaving = false;
    if (response.isSuccess && response.data != null) {
      notifyListeners();
      return response.data;
    }
    _saveError = response.message ?? 'Unable to add the vehicle.';
    notifyListeners();
    return null;
  }
}
