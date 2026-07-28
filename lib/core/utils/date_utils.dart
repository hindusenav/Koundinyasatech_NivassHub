import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Date/time formatting helpers, keyed off the formats in [AppConstants].
/// Named `AppDateFormatter` (not `DateUtils`) to avoid clashing with
/// Flutter's own `material.dart` class of that name.
class AppDateFormatter {
  AppDateFormatter._();

  static String formatDate(DateTime date) =>
      DateFormat(AppConstants.dateFormat).format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat(AppConstants.dateTimeFormat).format(date);

  static String formatTime(DateTime date) =>
      DateFormat(AppConstants.timeFormat).format(date);

  static String formatForApi(DateTime date) =>
      DateFormat(AppConstants.apiDateFormat).format(date);

  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Relative time, e.g. "Just now", "5m ago", "3h ago", "2d ago", falling
  /// back to [formatDate] beyond a week.
  static String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return formatDate(date);
  }
}
