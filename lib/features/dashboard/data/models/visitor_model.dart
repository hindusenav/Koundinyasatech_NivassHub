class VisitorModel {
  final String visitorId;
  final String visitorName;
  final String flat;

  const VisitorModel({
    required this.visitorId,
    required this.visitorName,
    required this.flat,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      visitorId: json['visitorId'] as String,
      visitorName: json['visitorName'] as String,
      flat: json['flat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitorId': visitorId,
      'visitorName': visitorName,
      'flat': flat,
    };
  }
}