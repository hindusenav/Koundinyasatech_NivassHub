import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';

abstract class PetServiceBase {
  /// Saves [pet]. Swap [StubPetService] for the real Dio service once the
  /// Pets GET/POST APIs are available.
  Future<ApiResponse<Pet>> addPet(Pet pet);
}
