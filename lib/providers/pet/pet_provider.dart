import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/models/pet/pet_type_option.dart';
import 'package:flutter_nivasshub/services/pet/pet_service_base.dart';

enum PetReferenceState { initial, loading, ready, error }

/// Holds the pets added this session, the pet types/breeds loaded from
/// `GET /pet/add-pet`, and submits new pets via [PetServiceBase].
class PetProvider extends ChangeNotifier {
  PetProvider({
    required PetServiceBase service,
    Future<String?> Function()? readToken,
  }) : _service = service,
       _readToken = readToken;

  final PetServiceBase _service;
  final Future<String?> Function()? _readToken;

  final List<Pet> _pets = [];
  bool _isSaving = false;
  String? _saveError;

  PetReferenceState _referenceState = PetReferenceState.initial;
  List<PetTypeOption> _petTypes = const [];
  String? _referenceError;

  List<Pet> get pets => List.unmodifiable(_pets);
  bool get isSaving => _isSaving;
  String? get saveError => _saveError;

  PetReferenceState get referenceState => _referenceState;
  bool get isLoadingReference => _referenceState == PetReferenceState.loading;
  String? get referenceError => _referenceError;

  /// Pet types from the API, in the order the backend returned them.
  List<PetTypeOption> get petTypes => List.unmodifiable(_petTypes);

  /// Breeds the backend offers for [petType] (empty if none / unknown).
  List<String> breedsFor(String petType) {
    for (final t in _petTypes) {
      if (t.petType == petType) return t.breeds;
    }
    return const [];
  }

  /// Loads pet types and breeds once; pass [force] to retry after an error.
  Future<void> loadReferenceData({bool force = false}) async {
    if (_referenceState == PetReferenceState.loading) return;
    if (!force && _referenceState == PetReferenceState.ready) return;

    _referenceState = PetReferenceState.loading;
    _referenceError = null;
    notifyListeners();

    final token = await _readToken?.call();
    if (token == null || token.isEmpty) {
      _referenceState = PetReferenceState.error;
      _referenceError = 'Your session has expired. Please log in again.';
      notifyListeners();
      return;
    }

    final response = await _service.getReferenceData(userToken: token);
    final data = response.data;
    if (!response.isSuccess || data == null) {
      _referenceState = PetReferenceState.error;
      _referenceError = response.message ?? 'Unable to load pet types.';
      notifyListeners();
      return;
    }

    _petTypes = data;
    _referenceState = PetReferenceState.ready;
    notifyListeners();
  }

  Future<bool> addPet({
    required String name,
    required String type,
    String breed = '',
  }) async {
    if (_isSaving) return false;
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      _saveError = 'Please enter your pet\'s name.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    final response = await _service.addPet(
      Pet(name: trimmed, type: type, breed: breed.trim()),
    );

    _isSaving = false;
    final saved = response.data;
    if (response.isSuccess && saved != null) {
      _pets.add(saved);
      notifyListeners();
      return true;
    }
    _saveError = response.message ?? 'Unable to add the pet.';
    notifyListeners();
    return false;
  }

  void clearSaveError() {
    if (_saveError == null) return;
    _saveError = null;
    notifyListeners();
  }
}
