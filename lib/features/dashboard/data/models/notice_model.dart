class NoticeModel {
  final String noticeId;
  final String title;
  final String postedBy;
  final String society;
  final String date;
  final String body;
  final String downloadLabel;

  const NoticeModel({
    required this.noticeId,
    required this.title,
    required this.postedBy,
    required this.society,
    required this.date,
    required this.body,
    required this.downloadLabel,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['noticeId'] as String,
      title: json['title'] as String,
      postedBy: json['postedBy'] as String,
      society: json['society'] as String,
      date: json['date'] as String,
      body: json['body'] as String,
      downloadLabel: json['downloadLabel'] as String? ?? 'Download',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noticeId': noticeId,
      'title': title,
      'postedBy': postedBy,
      'society': society,
      'date': date,
      'body': body,
      'downloadLabel': downloadLabel,
    };
  }
}
