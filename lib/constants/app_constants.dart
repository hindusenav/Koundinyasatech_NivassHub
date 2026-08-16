/// General app-wide constants that don't belong to any single feature.
class AppConstants {
  AppConstants._();

  static const String appName = 'NivasHub';

  // ---------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------
  static const int defaultPageSize = 20;

  // ---------------------------------------------------------------------
  // Timing
  // ---------------------------------------------------------------------
  static const Duration debounceDuration = Duration(milliseconds: 400);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration splashMinDuration = Duration(seconds: 2);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);

  // ---------------------------------------------------------------------
  // Date/time formats (consumed by core/utils/date_utils.dart)
  // ---------------------------------------------------------------------
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String timeFormat = 'hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // ---------------------------------------------------------------------
  // Uploads
  // ---------------------------------------------------------------------
  static const int maxUploadSizeBytes = 5 * 1024 * 1024;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx'];
}
