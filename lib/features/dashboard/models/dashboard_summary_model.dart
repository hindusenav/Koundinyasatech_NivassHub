/// Response shape for `/dashboard/summary`. Field names/shape are
/// placeholders until the real API contract is available.
class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.totalResidents,
    required this.totalVisitorsToday,
    required this.openComplaints,
    required this.activeNotices,
  });

  final int totalResidents;
  final int totalVisitorsToday;
  final int openComplaints;
  final int activeNotices;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryModel(
        totalResidents: json['total_residents'] as int? ?? 0,
        totalVisitorsToday: json['total_visitors_today'] as int? ?? 0,
        openComplaints: json['open_complaints'] as int? ?? 0,
        activeNotices: json['active_notices'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total_residents': totalResidents,
        'total_visitors_today': totalVisitorsToday,
        'open_complaints': openComplaints,
        'active_notices': activeNotices,
      };
}
