class CommunityMeetingModel {
  final String title;
  final String message;
  final String ctaLabel;

  const CommunityMeetingModel({
    required this.title,
    required this.message,
    required this.ctaLabel,
  });

  factory CommunityMeetingModel.fromJson(Map<String, dynamic> json) {
    return CommunityMeetingModel(
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      ctaLabel: json['ctaLabel'] as String? ?? 'BUY NOW',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'ctaLabel': ctaLabel,
    };
  }
}
