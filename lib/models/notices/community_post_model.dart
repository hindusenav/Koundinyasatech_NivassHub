class CommunityPostModel {
  final String id;
  final String title;
  final String description;
  final String userName;
  final String userFlat;
  final String profileImage;
  final String content;
  final String createdAt;
  final int likes;
  final int comments;
  final String? imageUrl;
  final String? timeAgo;
  final String type; // 'Post', 'Notice', 'Event', 'Poll'
  final String author;
  final String timestamp;
  final String action;
  final String visibility;
  final bool isLiked;
  final List<String> pollOptions;

  const CommunityPostModel({
    required this.id,
    this.title = '',
    this.description = '',
    required this.userName,
    this.userFlat = '',
    this.profileImage = '',
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.timeAgo,
    this.type = 'Post',
    this.author = '',
    this.timestamp = '',
    this.action = 'View Post',
    this.visibility = 'All Residents',
    this.isLiked = false,
    this.pollOptions = const [],
  });

  CommunityPostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? userName,
    String? userFlat,
    String? profileImage,
    String? content,
    String? createdAt,
    int? likes,
    int? comments,
    String? imageUrl,
    String? timeAgo,
    String? type,
    String? author,
    String? timestamp,
    String? action,
    String? visibility,
    bool? isLiked,
    List<String>? pollOptions,
  }) {
    return CommunityPostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userName: userName ?? this.userName,
      userFlat: userFlat ?? this.userFlat,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      timeAgo: timeAgo ?? this.timeAgo,
      type: type ?? this.type,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      visibility: visibility ?? this.visibility,
      isLiked: isLiked ?? this.isLiked,
      pollOptions: pollOptions ?? this.pollOptions,
    );
  }

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    String authorName = '';
    String flatNo = '';

    if (json['author'] is Map<String, dynamic>) {
      final authorMap = json['author'] as Map<String, dynamic>;
      authorName = authorMap['name']?.toString() ?? '';
      flatNo = authorMap['flat']?.toString() ?? '';
    } else if (json['author'] is String) {
      authorName = json['author'] as String;
    }

    if (authorName.isEmpty) {
      authorName = json['userName']?.toString() ?? 'Admin';
    }

    final textContent =
        json['content']?.toString() ?? json['description']?.toString() ?? '';
    final postTitle =
        json['title']?.toString() ??
        (authorName.isNotEmpty ? authorName : 'Community Post');
    final timeStr =
        json['timestamp']?.toString() ??
        json['timeAgo']?.toString() ??
        json['createdAt']?.toString() ??
        '';

    String? mediaUrl = json['imageUrl']?.toString();
    if ((mediaUrl == null || mediaUrl.isEmpty) &&
        json['media'] is List &&
        (json['media'] as List).isNotEmpty) {
      final firstMedia = (json['media'] as List).first;
      if (firstMedia is Map<String, dynamic>) {
        mediaUrl = firstMedia['fileUrl']?.toString();
      } else {
        mediaUrl = firstMedia.toString();
      }
    }

    final likesVal =
        (json['likesCount'] as num?)?.toInt() ??
        (json['likes'] as num?)?.toInt() ??
        0;
    final commentsVal =
        (json['commentsCount'] as num?)?.toInt() ??
        (json['comments'] as num?)?.toInt() ??
        0;

    final parsedPollOptions = <String>[];
    if (json['pollOptions'] is List) {
      for (final opt in json['pollOptions'] as List) {
        parsedPollOptions.add(opt.toString());
      }
    } else if (json['options'] is List) {
      for (final opt in json['options'] as List) {
        parsedPollOptions.add(opt.toString());
      }
    }

    return CommunityPostModel(
      id: json['id']?.toString() ?? json['postId']?.toString() ?? '',
      title: postTitle,
      description: json['description']?.toString() ?? textContent,
      userName: authorName,
      userFlat: flatNo,
      profileImage:
          json['profileImage']?.toString() ??
          'https://dummyimage.com/profile.png',
      content: textContent,
      createdAt: json['createdAt']?.toString() ?? '',
      likes: likesVal,
      comments: commentsVal,
      imageUrl: mediaUrl,
      timeAgo: timeStr,
      type: json['type']?.toString() ?? 'Post',
      author: authorName,
      timestamp: timeStr,
      action: json['action']?.toString() ?? 'View Post',
      visibility: json['visibility']?.toString() ?? 'All Residents',
      isLiked: json['liked'] as bool? ?? json['isLiked'] as bool? ?? false,
      pollOptions: parsedPollOptions,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'userName': userName,
    'userFlat': userFlat,
    'profileImage': profileImage,
    'content': content,
    'createdAt': createdAt,
    'likesCount': likes,
    'commentsCount': comments,
    'imageUrl': imageUrl,
    'timeAgo': timeAgo,
    'type': type,
    'author': {'name': userName, 'flat': userFlat},
    'timestamp': timestamp,
    'action': action,
    'visibility': visibility,
    'liked': isLiked,
    'pollOptions': pollOptions,
  };
}
