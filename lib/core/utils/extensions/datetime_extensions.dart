import '../date_utils.dart';

/// Common `DateTime` checks used by list/detail screens (visitor logs,
/// complaints, notices). Formatting itself is delegated to
/// [AppDateFormatter] so there is one source of truth for date formats.
extension DateTimeExtensions on DateTime {
  bool get isToday => _isSameDay(this, DateTime.now());

  bool get isYesterday =>
      _isSameDay(this, DateTime.now().subtract(const Duration(days: 1)));

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  String get formattedDate => AppDateFormatter.formatDate(this);
  String get formattedDateTime => AppDateFormatter.formatDateTime(this);
  String get formattedTime => AppDateFormatter.formatTime(this);
  String get timeAgo => AppDateFormatter.timeAgo(this);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
