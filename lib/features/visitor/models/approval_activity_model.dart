/// A single row on the Activities screen (visitor/delivery gate log),
/// mirroring the NivasHub API Contract §6.2 `GET /api/v1/approvals` response
/// shape exactly — [id], [company], [type], [name], [status], [timestamp],
/// [date] and [approvedBy] all map 1:1 onto that endpoint's fields, so this
/// model can be built straight from the real response (no UI changes) once
/// the backend ships; only `MockVisitorActivityService` needs to be swapped
/// for a real `VisitorActivityServiceBase` implementation.
///
/// [verificationLabel] and [isWrongEntry] are local-only additions the
/// contract doesn't define yet:
/// - [verificationLabel] lets a mock record pin the exact approval/rejection
///   line shown on the card (e.g. "Allowed by Parmesh") when it differs from
///   the generic wording [approvalNoteText] would otherwise derive from
///   [status]/[approvedBy]. Real API payloads can simply omit it.
/// - [isWrongEntry] is the client-side flag toggled by the card's
///   "Wrong Entry" action; it has no backend field to persist to yet.
class ApprovalActivityModel {
  const ApprovalActivityModel({
    required this.id,
    this.company,
    required this.type,
    required this.name,
    required this.status,
    required this.timestamp,
    required this.date,
    this.approvedBy,
    this.verificationLabel,
    this.isWrongEntry = false,
  });

  final String id;

  /// Display name for the card's avatar/title — a delivery brand ("Zepto",
  /// "Blinkit") or a service/visitor category ("House Help", "Guest").
  final String? company;

  /// `delivery` | `service` | `visitor` — drives the "Deliveries"/"Visitors"
  /// filter chips.
  final String type;

  final String name;

  /// `LEFT` | `INSIDE` | `DENIED` (per the API contract's example values).
  final String status;

  final String timestamp;

  /// Date-section label this activity is grouped under, e.g.
  /// `"TODAY — JUL 29"`.
  final String date;

  final String? approvedBy;

  final String? verificationLabel;

  final bool isWrongEntry;

  bool get isDenied => status.toUpperCase() == 'DENIED';

  /// A resident-approved entry (vs. one decided ad hoc by a guard at the
  /// gate) — used by the "Pre-approved" filter chip. Derived from
  /// [approvedBy] since the contract has no dedicated flag for this yet.
  bool get isPreApproved =>
      !isDenied && approvedBy != null && !approvedBy!.startsWith('Guard');

  /// The full "Pre-approved by Parmesh" / "Rejected by Guard (Gate 2)" line
  /// shown under the visitor name. Prefers [verificationLabel] when the mock
  /// data pins one; otherwise derives sensible wording from [status] and
  /// [approvedBy].
  String get approvalNoteText {
    if (verificationLabel != null && verificationLabel!.isNotEmpty) {
      return verificationLabel!;
    }
    if (approvedBy == null || approvedBy!.isEmpty) return '';
    return isDenied ? 'Rejected by $approvedBy' : 'Pre-approved by $approvedBy';
  }

  factory ApprovalActivityModel.fromJson(Map<String, dynamic> json) {
    return ApprovalActivityModel(
      id: json['id'] as String,
      company: json['company'] as String?,
      type: json['type'] as String? ?? 'visitor',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      date: json['date'] as String? ?? '',
      approvedBy: json['approvedBy'] as String?,
      verificationLabel: json['verificationLabel'] as String?,
      isWrongEntry: json['isWrongEntry'] as bool? ?? false,
    );
  }

  ApprovalActivityModel copyWith({bool? isWrongEntry}) {
    return ApprovalActivityModel(
      id: id,
      company: company,
      type: type,
      name: name,
      status: status,
      timestamp: timestamp,
      date: date,
      approvedBy: approvedBy,
      verificationLabel: verificationLabel,
      isWrongEntry: isWrongEntry ?? this.isWrongEntry,
    );
  }
}
