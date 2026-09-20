/// Whether the resident owns the flat or rents it. Drives which three
/// documents KYC asks for — see `KycDocumentCatalog.forRole`.
enum UserRole {
  owner,
  tenant;

  String get wireValue => name;

  String get label => switch (this) {
    UserRole.owner => 'Owner',
    UserRole.tenant => 'Tenant',
  };

  String get description => switch (this) {
    UserRole.owner => 'I own this property',
    UserRole.tenant => 'I rent this property',
  };

  static UserRole? tryFromJson(dynamic value) {
    if (value == null) return null;
    for (final role in UserRole.values) {
      if (role.wireValue == value) return role;
    }
    return null;
  }

  static UserRole fromJson(dynamic value) =>
      tryFromJson(value) ?? UserRole.owner;
}
