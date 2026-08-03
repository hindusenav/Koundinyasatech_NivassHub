class RejectVisitorRequest {
  final String visitorId;
  final String reason;

  const RejectVisitorRequest({
    required this.visitorId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'visitorId': visitorId,
      'reason': reason,
    };
  }
}