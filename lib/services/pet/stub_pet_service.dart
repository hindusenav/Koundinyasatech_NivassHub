import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/services/pet/pet_service_base.dart';

/// Placeholder until the Pets API exists: succeeds immediately without any
/// network call.
class StubPetService implements PetServiceBase {
  const StubPetService();

  @override
  Future<ApiResponse<Pet>> addPet(Pet pet) async => ApiResponse.success(pet);
}
