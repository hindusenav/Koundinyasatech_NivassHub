class UserModel {
  final String? name;
  final String? flatNumber;

  const UserModel({
    this.name,
    this.flatNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Handles 'name', 'full_name', or 'userName' keys from JSON
      name: json['name'] as String? ??
          json['full_name'] as String? ??
          json['userName'] as String?,
      
      // Handles 'flatNumber', 'flat_number', or 'unitNumber' keys from JSON
      flatNumber: json['flatNumber'] as String? ??
          json['flat_number'] as String? ??
          json['unitNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'flatNumber': flatNumber,
    };
  }
}