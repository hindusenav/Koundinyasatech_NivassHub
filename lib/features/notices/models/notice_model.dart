class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String attachment;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.attachment,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      attachment: json['attachment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
    'attachment': attachment,
  };
}
