import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/family/add_family.dart';
import 'package:flutter_nivasshub/models/family/family_relation.dart';
import 'package:flutter_nivasshub/services/family/family_service_base.dart';

enum FamilyLoadState { initial, loading, ready, error }

/// Drives the Household family section and the Add Family sheet: loads the
/// relation options once, validates and submits new members, and keeps the
/// members added during this session (the API has no "list members" call).
class FamilyProvider extends ChangeNotifier {
  FamilyProvider({required FamilyServiceBase service}) : _service = service;

  final FamilyServiceBase _service;

  FamilyLoadState _state = FamilyLoadState.initial;
  FamilyRelationsData _relations = FamilyRelationsData.empty;
  String? _errorMessage;
  final List<FamilyMember> _members = [];
  bool _isSaving = false;
  String? _saveError;

  FamilyLoadState get state => _state;
  bool get isLoading => _state == FamilyLoadState.loading;
  String? get errorMessage => _errorMessage;
  FamilyRelationsData get relations => _relations;
  List<FamilyMember> get members => List.unmodifiable(_members);
  bool get isSaving => _isSaving;
  String? get saveError => _saveError;

  static final RegExp _mobilePattern = RegExp(r'^\d{10}$');
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidMobile(String value) => _mobilePattern.hasMatch(value);

  static bool isValidEmail(String value) => _emailPattern.hasMatch(value);

  /// Loads relations once; pass [force] to retry after an error.
  Future<void> load({bool force = false}) async {
    if (_state == FamilyLoadState.loading) return;
    if (!force && _state == FamilyLoadState.ready) return;

    _state = FamilyLoadState.loading;
    _errorMessage = null;
    notifyListeners();


///////////////////////////////////////
    final response = await _service.getRelations();
    if (!response.isSuccess || response.data == null) {
      _relations = FamilyRelationsData.empty;
      _errorMessage = response.message ?? 'Unable to load family relations.';
      _state = FamilyLoadState.error;
    } else {
      _relations = response.data!;
      _state = FamilyLoadState.ready;
    }
    notifyListeners();
  }

  /// Submits a new member. Returns the result, or null with [saveError] set.
  Future<AddFamilyResult?> addMember({
    required String name,
    required String mobile,
    required String relation,
    String countryCode = '+91',
    String? email,
  }) async {
    if (_isSaving) return null;

    final trimmedName = name.trim();
    final trimmedMobile = mobile.trim();
    final trimmedEmail = email?.trim();

    if (trimmedName.isEmpty) return _fail('Please enter a name.');
    if (!isValidMobile(trimmedMobile)) {
      return _fail('Enter a valid 10-digit mobile number.');
    }
    if (relation.isEmpty) return _fail('Please select a relation.');
    if (trimmedEmail != null &&
        trimmedEmail.isNotEmpty &&
        !isValidEmail(trimmedEmail)) {
      return _fail('Enter a valid email address.');
    }

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    final response = await _service.addFamily(
      AddFamilyRequest(
        countryCode: countryCode,
        mobile: trimmedMobile,
        name: trimmedName,
        relation: relation,
        email: trimmedEmail,
      ),
    );

    _isSaving = false;
    final result = response.data;
    if (response.isSuccess && result != null) {
      // The API may omit these fields; fall back to what the user entered.
      final m = result.member;
      _members.add(
        FamilyMember(
          name: m.name.trim().isEmpty ? trimmedName : m.name,
          relationship: m.relationship.trim().isEmpty ? relation : m.relationship,
          countryCode: m.countryCode.isEmpty ? countryCode : m.countryCode,
          maskedMobile: m.maskedMobile.isEmpty
              ? '••••••${trimmedMobile.substring(trimmedMobile.length - 4)}'
              : m.maskedMobile,
        ),
      );
      notifyListeners();
      return result;
    }
    _saveError = response.message ?? 'Unable to add the family member.';
    notifyListeners();
    return null;
  }

  void clearSaveError() {
    if (_saveError == null) return;
    _saveError = null;
    notifyListeners();
  }

  AddFamilyResult? _fail(String message) {
    _saveError = message;
    notifyListeners();
    return null;
  }
}
