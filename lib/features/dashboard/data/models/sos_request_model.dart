import 'location_model.dart';

class SosRequestModel {
  final LocationModel location;

  const SosRequestModel({
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
    };
  }
}