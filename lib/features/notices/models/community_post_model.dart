class CommunityPostModel {
  final String id;
  final String userName;
  final String profileImage;
  final String content;
  final String createdAt;
  final int likes;
  final int comments;

  const CommunityPostModel({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'profileImage': profileImage,
    'content': content,
    'createdAt': createdAt,
    'likes': likes,
    'comments': comments,
  };
}
