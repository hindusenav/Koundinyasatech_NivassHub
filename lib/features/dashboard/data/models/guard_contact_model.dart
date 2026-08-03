class GuardContactModel {
  final String guardName;
  final String phoneNumber;

  const GuardContactModel({
    required this.guardName,
    required this.phoneNumber,
  });

  factory GuardContactModel.fromJson(Map<String, dynamic> json) {
    return GuardContactModel(
      guardName: json['guardName'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guardName': guardName,
      'phoneNumber': phoneNumber,
    };
  }
}