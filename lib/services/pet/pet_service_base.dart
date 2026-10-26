import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/models/pet/pet_type_option.dart';

abstract class PetServiceBase {
  /// `GET /pet/add-pet?user_token=<userToken>` — pet types and breeds for
  /// the Add Pet form (`dbo.USP_Add_Pet_GET`).
  Future<ApiResponse<List<PetTypeOption>>> getReferenceData({
    required String userToken,
  });

  /// Saves [pet]. Local-only until the Add Pet POST API is available.
  Future<ApiResponse<Pet>> addPet(Pet pet);
}
