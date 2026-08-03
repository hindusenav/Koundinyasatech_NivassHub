class ApproveVisitorRequest {
  final String visitorId;

  const ApproveVisitorRequest({
    required this.visitorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'visitorId': visitorId,
    };
  }
}