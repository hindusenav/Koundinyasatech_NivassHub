/// Maps `GET /users/active-society`'s `data` object (API contract §2.3).
class ActiveSocietyModel {
  const ActiveSocietyModel({
    required this.societyId,
    required this.name,
    required this.fullAddress,
    required this.city,
    required this.state,
  });

  final String societyId;
  final String name;
  final String fullAddress;
  final String city;
  final String state;

  factory ActiveSocietyModel.fromJson(Map<String, dynamic> json) => ActiveSocietyModel(
        societyId: json['societyId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        fullAddress: json['fullAddress'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
      );
}
