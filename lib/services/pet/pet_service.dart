import 'package:flutter_nivasshub/core/api/api_exception.dart';
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

  /// `POST /pet/adding-pet-details` as multipart/form-data. Dio generates the
  /// multipart boundary; the Bearer token comes from the auth interceptor.
  /// Responds 201 with `data.{petName, microchipNo, status}`.
  @override
  Future<ApiResponse<Pet>> addPet(Pet pet) {
    final picture = pet.picturePath;
    if (pet.petTypeId == null || pet.breedId == null || picture == null) {
      return Future.value(
        ApiResponse.failure(
          const ApiException(
            message: 'Pet type, breed and picture are required.',
            type: ApiExceptionType.validation,
          ),
        ),
      );
    }
    return handleRequest(
      () => client.uploadFile(
        ApiEndpoints.addPetDetails,
        files: {'petpicture': picture},
        fields: {
          'pettype': pet.petTypeId.toString(),
          'breedtype': pet.breedId.toString(),
          'petname': pet.name,
          'petcolour': pet.colour,
          if (pet.vaccinationStatus != null)
            'petvaccinationstatus': pet.vaccinationStatus,
          if (pet.vaccinationDate != null)
            'petvaccinationdate': pet.vaccinationDate!
                .toUtc()
                .toIso8601String(),
        },
      ),
      (json) {
        final data = json is Map && json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : const <String, dynamic>{};
        return pet.copyWith(
          microchipNo: data['microchipNo']?.toString(),
          status: data['status']?.toString(),
        );
      },
    );
  }
}
