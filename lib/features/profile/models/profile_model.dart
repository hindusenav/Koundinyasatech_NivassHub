class ProfileModel {
  final String name;
  final String email;
  final String mobile;
  final String profileImage;

  ProfileModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.profileImage,
  });

  /// ✅ FROM JSON (FIX FOR YOUR ERROR)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }

  /// ✅ OPTIONAL (GOOD PRACTICE)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'profile_image': profileImage,
    };
  }

  /// ✅ COPYWITH (YOU ADDED EARLIER)
  ProfileModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? profileImage,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}