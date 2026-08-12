import 'profile_address_model.dart';

/// Maps `GET /users/profile`'s `data` object (API contract §2.2).
class UserProfileModel {
  const UserProfileModel({
    required this.userId,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.address,
  });

  final String userId;
  final String fullName;
  final String mobileNumber;
  final String email;
  final ProfileAddressModel address;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        userId: json['userId'] as String? ?? '',
        fullName: json['fullName'] as String? ?? '',
        mobileNumber: json['mobileNumber'] as String? ?? '',
        email: json['email'] as String? ?? '',
        address: ProfileAddressModel.fromJson(
          json['address'] as Map<String, dynamic>? ?? const {},
        ),
      );
}
