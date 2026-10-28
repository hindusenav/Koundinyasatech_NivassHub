/// A household pet. Built from the Add Pet form, then completed with the
/// backend's `microchipNo`/`status` once `POST /pet/adding-pet-details`
/// succeeds.
class Pet {
  const Pet({
    required this.name,
    required this.type,
    this.breed = '',
    this.petTypeId,
    this.breedId,
    this.colour = '',
    this.picturePath,
    this.vaccinationStatus,
    this.vaccinationDate,
    this.microchipNo,
    this.status,
  });

  final String name;
  final String type;
  final String breed;

  final int? petTypeId;
  final int? breedId;
  final String colour;

  /// Local file path of the picked photo (sent as `petpicture`).
  final String? picturePath;

  /// `V`, `YES` or `NO`.
  final String? vaccinationStatus;
  final DateTime? vaccinationDate;

  /// Returned by the backend on creation.
  final String? microchipNo;
  final String? status;

  Pet copyWith({String? microchipNo, String? status}) => Pet(
    name: name,
    type: type,
    breed: breed,
    petTypeId: petTypeId,
    breedId: breedId,
    colour: colour,
    picturePath: picturePath,
    vaccinationStatus: vaccinationStatus,
    vaccinationDate: vaccinationDate,
    microchipNo: microchipNo ?? this.microchipNo,
    status: status ?? this.status,
  );
}
