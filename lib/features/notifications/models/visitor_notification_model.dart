/// A single gate-arrival alert shown as a banner on the Home screen (e.g.
/// "Blinkit Delivery • Aman — Arrived at Gate Main Gate • Awaiting your
/// approval"). Field names mirror the mock contract the backend team shared
/// verbatim (`id`, `type`, `company`, `visitorName`, `gate`, `message`,
/// `status`, `time`, `logo`, `avatar`) so `MockVisitorNotificationService`
/// can be swapped for a real implementation with no changes to this model,
/// the provider, or the UI.
///
/// [logo]/[avatar] are asset/URL paths reserved for a future real backend —
/// today's mock JSON points at files that don't exist in this project yet
/// (`assets/images/blinkit.png`, `assets/images/delivery_boy.png`), so
/// `VisitorNotificationBanner` deliberately renders a colored-initials
/// avatar instead of `Image.asset(logo)`, exactly like `ActivityCard`
/// already does for delivery companies elsewhere in this app.
class VisitorNotificationModel {
  const VisitorNotificationModel({
    required this.id,
    required this.type,
    required this.company,
    required this.visitorName,
    required this.gate,
    required this.message,
    required this.status,
    required this.time,
    this.logo,
    this.avatar,
  });

  final String id;
  final String type;
  final String company;
  final String visitorName;
  final String gate;
  final String message;
  final String status;
  final String time;
  final String? logo;
  final String? avatar;

  /// "Blinkit Delivery • Aman" — the banner's `Text` truncates this itself
  /// (`maxLines: 1`, ellipsis) to match the Figma's "Blinkit Delivery •
  /// Aman…" rather than baking an ellipsis into the data.
  String get title => '$company Delivery • $visitorName';

  /// "Arrived at Gate Main Gate • Awaiting your approval"
  String get subtitle => '$message $gate • Awaiting your approval';

  factory VisitorNotificationModel.fromJson(Map<String, dynamic> json) {
    return VisitorNotificationModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'visitor',
      company: json['company'] as String? ?? '',
      visitorName: json['visitorName'] as String? ?? '',
      gate: json['gate'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
      time: json['time'] as String? ?? '',
      logo: json['logo'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
