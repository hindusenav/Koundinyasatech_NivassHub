/// Body of `POST /country-codes/user-registration`.
class UserRegistrationRequest {
  const UserRegistrationRequest({
    required this.fullName,
    required this.mobileNumber,
    required this.mobileCountryCode,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.socId,
    required this.towerId,
    required this.floorId,
    required this.unitId,
    required this.roleId,
    this.unitBranch,
  });

  final String fullName;

  /// National digits only; [mobileCountryCode] carries the dial code.
  final String mobileNumber;
  final String mobileCountryCode;
  final String email;
  final String country;
  final String state;
  final String city;
  final String socId;
  final String towerId;
  final String floorId;

  /// `SocietyUnit.unitId` (`Units_ID`) — the unit's numeric id, distinct
  /// from `SocietyUnit.unitNumber`'s human-facing label (e.g. `"TE201"`),
  /// which is display-only and never sent.
  final String unitId;

  /// `RegistrationRole.roleId` from `Roles[]` (`GET
  /// /country-codes/user-registration`) — the Owner/Tenant picker's wire
  /// value is resolved to this id before submit; the role label itself is
  /// never sent. Confirmed against a live 400 response: the backend wants
  /// this under the `user_role` key (not `role_id`), as a string.
  final String roleId;

  /// Optional per the documented contract.
  final String? unitBranch;

  Map<String, dynamic> toJson() => {
    'fname': fullName,
    'mobilenumber': mobileNumber,
    'mob_cont_code': mobileCountryCode,
    'email': email,
    'country': country,
    'state': state,
    'city': city,
    'socid': int.tryParse(socId) ?? socId,
    'towerid': int.tryParse(towerId) ?? towerId,
    'floorid': int.tryParse(floorId) ?? floorId,
    'unitnumber': int.tryParse(unitId) ?? unitId,
    'user_role': roleId,
    if (unitBranch != null && unitBranch!.isNotEmpty) 'unit_branch': unitBranch,
  };
}
