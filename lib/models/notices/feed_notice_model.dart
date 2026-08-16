class FeedNoticeModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String attachment;
  final String priority;
  final String category;
  final String type;
  final String author;
  final String timestamp;
  final String action;

  const FeedNoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.attachment,
    this.priority = 'Low',
    this.category = 'Admin',
    this.type = 'Notice',
    this.author = 'Admin',
    this.timestamp = '',
    this.action = 'Download',
  });

  bool get hasAttachment => attachment.isNotEmpty;

  factory FeedNoticeModel.fromJson(Map<String, dynamic> json) {
    final authorName =
        json['author']?.toString() ?? json['category']?.toString() ?? 'Admin';
    final ts = json['timestamp']?.toString() ?? json['date']?.toString() ?? '';
    return FeedNoticeModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: ts.isNotEmpty ? ts : (json['date']?.toString() ?? ''),
      attachment: json['attachment']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'Low',
      category: authorName,
      type: json['type']?.toString() ?? 'Notice',
      author: authorName,
      timestamp: ts,
      action: json['action']?.toString() ?? 'Download',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
    'attachment': attachment,
    'priority': priority,
    'category': category,
    'type': type,
    'author': author,
    'timestamp': timestamp,
    'action': action,
  };
}
