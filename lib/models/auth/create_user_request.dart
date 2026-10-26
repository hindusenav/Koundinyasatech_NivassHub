import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';

/// Body of `POST /auth/users` — everything collected on the User Details
/// screen, submitted in one call.
class CreateUserRequest {
  const CreateUserRequest({
    required this.fullName,
    required this.mobileNumber,
    required this.countryCode,
    required this.email,
    required this.role,
    required this.subBranch,
    required this.location,
  });

  final String fullName;

  /// National digits only; [countryCode] carries the dial code.
  final String mobileNumber;
  final String countryCode;
  final String email;
  final UserRole role;
  final String subBranch;
  final LocationSelection location;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'mobileNumber': mobileNumber,
    'countryCode': countryCode,
    'email': email,
    'role': role.wireValue,
    'subBranch': subBranch,
    ...location.toJson(),
  };
}
