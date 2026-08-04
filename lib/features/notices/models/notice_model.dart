class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String attachment;
  final String priority;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.attachment,
    this.priority = 'Low',
  });

  bool get hasAttachment => attachment.isNotEmpty;

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      attachment: json['attachment'] ?? '',
      priority: json['priority'] ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
    'attachment': attachment,
    'priority': priority,
  };
}
