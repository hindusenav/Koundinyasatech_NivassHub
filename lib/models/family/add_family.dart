/// Body of `POST /get-family/add-family`. [mobile] must be exactly 10 digits.
class AddFamilyRequest {
  const AddFamilyRequest({
    required this.countryCode,
    required this.mobile,
    required this.name,
    required this.relation,
    this.email,
  });

  final String countryCode;
  final String mobile;
  final String name;
  final String relation;
  final String? email;

  Map<String, dynamic> toJson() => {
    'res_cont_code': countryCode,
    'res_mob': mobile,
    if (email != null && email!.isNotEmpty) 'res_email': email,
    'res_name': name,
    'res_relation': relation,
  };
}

/// A family member as returned by a successful add (mobile is masked).
class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.relationship,
    required this.countryCode,
    required this.maskedMobile,
  });

  final String name;
  final String relationship;
  final String countryCode;
  final String maskedMobile;

  /// [json] is the whole response body (`success`, `message`, `data`, ...).
  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? raw : const {};
    return FamilyMember(
      name: (data['name']?.toString() ?? '').replaceAll(RegExp(r'\s+'), ' '),
      relationship: data['relationship']?.toString() ?? '',
      countryCode: data['mobile_country_code']?.toString() ?? '',
      maskedMobile: data['mobile_masked']?.toString() ?? '',
    );
  }
}

/// Successful add: the new member plus the server's message.
class AddFamilyResult {
  const AddFamilyResult({required this.message, required this.member});

  final String message;
  final FamilyMember member;

  factory AddFamilyResult.fromJson(Map<String, dynamic> json) {
    return AddFamilyResult(
      message: json['message']?.toString() ?? 'Family member added.',
      member: FamilyMember.fromJson(json),
    );
  }
}
