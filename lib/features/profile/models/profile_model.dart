class ProfileModel {
  final int id;
  final String name;
  final String mobile;
  final String email;
  final String profileImage;
  final String username;

  ProfileModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.profileImage,
    required this.username,
  });

  // ✅ ADD THIS METHOD
  ProfileModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? profileImage,
    String? username,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? json['profileImage'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'profile_image': profileImage,
      'username': username,
    };
  }
}