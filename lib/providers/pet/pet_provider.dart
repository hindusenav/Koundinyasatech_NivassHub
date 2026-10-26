import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/services/pet/pet_service_base.dart';

/// Holds the pets added this session and submits new ones via [PetServiceBase].
class PetProvider extends ChangeNotifier {
  PetProvider({required PetServiceBase service}) : _service = service;

  final PetServiceBase _service;

  final List<Pet> _pets = [];
  bool _isSaving = false;
  String? _saveError;

  List<Pet> get pets => List.unmodifiable(_pets);
  bool get isSaving => _isSaving;
  String? get saveError => _saveError;

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
