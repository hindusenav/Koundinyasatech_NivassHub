/// The address sub-object returned by `GET /users/profile` — a narrower
/// shape than the address used during onboarding's Create Profile form
/// (no street/landmark/wing fields in the profile-fetch response).
class ProfileAddressModel {
  const ProfileAddressModel({
    required this.flatHouseNo,
    required this.societyBuildingName,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  final String flatHouseNo;
  final String societyBuildingName;
  final String city;
  final String state;
  final String pinCode;

  factory ProfileAddressModel.fromJson(Map<String, dynamic> json) => ProfileAddressModel(
        flatHouseNo: json['flatHouseNo'] as String? ?? '',
        societyBuildingName: json['societyBuildingName'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
        pinCode: json['pinCode'] as String? ?? '',
      );

  /// A 2-line mailing address for display, e.g.
  /// "B-402 Golden Residency\nMumbai, Maharashtra 400053".
  String get displayAddress {
    final line1 = [flatHouseNo, societyBuildingName].where((s) => s.isNotEmpty).join(' ');
    final cityState = [city, state].where((s) => s.isNotEmpty).join(', ');
    final line2 = [cityState, pinCode].where((s) => s.isNotEmpty).join(' ');
    return [line1, line2].where((s) => s.isNotEmpty).join('\n');
  }
}
