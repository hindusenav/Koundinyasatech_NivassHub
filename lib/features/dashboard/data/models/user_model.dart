class UserModel {
  final String userId;
  final String name;
  final String flatNumber;
  final String profileImage;

  const UserModel({
    required this.userId,
    required this.name,
    required this.flatNumber,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? json['fullName'] as String? ?? '',
      flatNumber: json['flatNumber'] as String? ?? json['flatAddress'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'flatNumber': flatNumber,
      'profileImage': profileImage,
    };
  }
}