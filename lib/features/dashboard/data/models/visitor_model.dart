class VisitorModel {
  final String visitorId;
  final String visitorName;
  final String flat;
  final String visitorType;
  final String time;

  const VisitorModel({
    required this.visitorId,
    required this.visitorName,
    required this.flat,
    required this.visitorType,
    required this.time,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      visitorId: json['visitorId'] as String,
      visitorName: json['visitorName'] as String,
      flat: json['flat'] as String,
      visitorType: json['visitorType'] as String? ?? 'Visitor',
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitorId': visitorId,
      'visitorName': visitorName,
      'flat': flat,
      'visitorType': visitorType,
      'time': time,
    };
  }
}