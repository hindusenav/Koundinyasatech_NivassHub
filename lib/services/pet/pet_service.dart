import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/pet/pet.dart';
import 'package:flutter_nivasshub/models/pet/pet_type_option.dart';
import 'package:flutter_nivasshub/services/pet/pet_service_base.dart';

/// Dio-backed `GET /pet/add-pet`. The backend takes the client IP and
/// User-Agent from the request itself, so only `user_token` is sent.
///
/// Error responses (400 IP/device, 401 TOKEN_*, 403 RESIDENT_NOT_FOUND,
/// 500 INTERNAL_ERROR) surface as an [ApiResponse.failure] via the shared
/// error interceptor.
class PetService extends ApiService implements PetServiceBase {
  const PetService(super.client);

  @override
  Future<ApiResponse<List<PetTypeOption>>> getReferenceData({
    required String userToken,
  }) {
    return handleRequest(
      () => client.get(
        ApiEndpoints.addPet,
        queryParameters: {'user_token': userToken},
      ),
      PetTypeOption.listFromResponse,
    );
  }

  /// The Add Pet POST API is not specified yet, so the pet is kept locally.
  @override
  Future<ApiResponse<Pet>> addPet(Pet pet) async => ApiResponse.success(pet);
}
