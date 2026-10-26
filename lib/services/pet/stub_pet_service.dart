import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/models/pet/pet_type_option.dart';
import 'package:flutter_nivasshub/services/pet/pet_service_base.dart';

/// Offline stand-in (tests / previews): succeeds immediately, no network.
class StubPetService implements PetServiceBase {
  const StubPetService();

  @override
  Future<ApiResponse<List<PetTypeOption>>> getReferenceData({
    required String userToken,
  }) async => ApiResponse.success(const <PetTypeOption>[]);

  @override
  Future<ApiResponse<Pet>> addPet(Pet pet) async => ApiResponse.success(pet);
}
