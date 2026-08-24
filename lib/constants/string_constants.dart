/// Reusable, generic strings shared across features (actions, common error
/// messages, confirmation copy). Feature-specific copy belongs in that
/// feature's own screen/widget, not here.
///
/// If the app later needs multi-language support, this is the file to
/// replace with generated ARB/`intl` lookups — every call site already goes
/// through `StringConstants.xxx` instead of a literal.
class StringConstants {
  StringConstants._();

  // ---------------------------------------------------------------------
  // Generic actions
  // ---------------------------------------------------------------------
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String submit = 'Submit';
  static const String retry = 'Retry';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';
  static const String ok = 'OK';
  static const String exit = 'Exit';

  // ---------------------------------------------------------------------
  // Generic messages
  // ---------------------------------------------------------------------
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String noInternetConnection =
      'No internet connection. Please check your network.';
  static const String noDataFound = 'No data found';
  static const String sessionExpired =
      'Your session has expired. Please log in again.';

  // ---------------------------------------------------------------------
  // Confirmation dialogs
  // ---------------------------------------------------------------------
  static const String deleteConfirmationTitle = 'Delete Confirmation';
  static const String deleteConfirmationMessage =
      'Are you sure you want to delete this item? This action cannot be undone.';
  static const String logoutConfirmationTitle = 'Log Out';
  static const String logoutConfirmationMessage =
      'Are you sure you want to log out?';
  static const String exitConfirmationTitle = 'Exit App';
  static const String exitConfirmationMessage = 'Do you want to exit?';
}
