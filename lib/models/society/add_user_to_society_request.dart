/// Body of `POST /society/add-user`. Ids are the wire values picked from the
/// master data and the society tree; the token is the signed-in session.
class AddUserToSocietyRequest {
  const AddUserToSocietyRequest({
    required this.userToken,
    required this.countryCode,
    required this.stateCode,
    required this.city,
    required this.socId,
    required this.towerId,
    required this.floor,
    required this.unitId,
    required this.userType,
    this.userSubRole,
    this.userCat,
    this.documentId,
  });

  final String userToken;
  final String countryCode;
  final String stateCode;
  final String city;
  final String socId;
  final String towerId;

  /// `SocietyFloor.floorId`, same value the registration form sends.
  final String floor;

  /// `SocietyUnit.unitId` (the numeric id, not the display number).
  final String unitId;

  /// `RegistrationRole.roleId` (6 owner, 7 tenant).
  final String userType;
  final String? userSubRole;

  /// `RegistrationCategory.categoryId`, only for sub-roles with categories.
  final String? userCat;

  /// `RegistrationKycDocument.id` from the master data's `kycDocuments`.
  final String? documentId;

  static Object _num(String v) => int.tryParse(v) ?? v;

  Map<String, dynamic> toJson() => {
    'user_token': userToken,
    'cont_code': _num(countryCode),
    'state_code': _num(stateCode),
    'city': city,
    'soc_id': _num(socId),
    'tower_id': _num(towerId),
    'floor': _num(floor),
    'unitid': _num(unitId),
    'user_type': _num(userType),
    if (userSubRole != null && userSubRole!.isNotEmpty)
      'user_sub_role': _num(userSubRole!),
    if (userCat != null && userCat!.isNotEmpty) 'user_cat': _num(userCat!),
    if (documentId != null && documentId!.isNotEmpty)
      'documentid': _num(documentId!),
  };
}
