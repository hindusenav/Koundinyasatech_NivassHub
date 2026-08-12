/// The data shown in the "Delivery Details" bottom sheet opened by tapping
/// the Home screen's gate-arrival notification card (see
/// `VisitorNotificationSection._handleTap` / `DeliveryDetailsSheet`).
///
/// There is no published "GET visitor details" endpoint yet — fetching this
/// is mock-only today (see `MockVisitorDetailsService`). A real
/// implementation would likely call `ApiEndpoints.visitorById(id)` (already
/// defined, currently unused) or a dedicated `/visitors/{id}/details`
/// endpoint once one is published; only `VisitorDetailsServiceBase`'s
/// concrete implementation needs to change.
///
/// [status] mirrors `ApprovalActivityModel`'s convention (`LEFT` | `INSIDE` |
/// `DENIED`) — it is deliberately a different vocabulary from
/// `VisitorNotificationModel.status` (a free-text string like "Awaiting
/// Approval"): this model describes the visitor's current gate status after
/// fetching full details, not the pending-approval banner text.
class VisitorDetailsModel {
  const VisitorDetailsModel({
    required this.id,
    required this.name,
    required this.company,
    required this.status,
    required this.entryTime,
    this.photoUrl,
    this.exitTime,
    this.approvedBy,
    this.phoneNumber,
  });

  final String id;
  final String name;
  final String company;

  /// `LEFT` | `INSIDE` | `DENIED` — see class doc comment.
  final String status;
  final String entryTime;

  /// No real photo asset/CDN exists in this project yet (same situation as
  /// `VisitorNotificationModel.logo`/`.avatar`) — null in the mock fixture,
  /// so the sheet falls back to a colored-initials avatar exactly like
  /// `ActivityCard`/`VisitorNotificationBanner` already do elsewhere.
  final String? photoUrl;

  /// Null while the visitor is still on the premises — the sheet hides the
  /// "Exit Time" row entirely rather than showing a placeholder.
  final String? exitTime;

  /// Null for an ad hoc/guard decision with no named approver — the sheet
  /// hides the "Approved By" row entirely.
  final String? approvedBy;
  final String? phoneNumber;

  factory VisitorDetailsModel.fromJson(Map<String, dynamic> json) {
    return VisitorDetailsModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      company: json['company'] as String? ?? '',
      status: json['status'] as String? ?? '',
      entryTime: json['entryTime'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      exitTime: json['exitTime'] as String?,
      approvedBy: json['approvedBy'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}
