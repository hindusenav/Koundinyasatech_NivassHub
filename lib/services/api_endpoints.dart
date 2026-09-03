/// API Endpoints for the application
class ApiEndpoints {
  /// Authentication endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String logout = '$auth/logout';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh-token';

  /// Country endpoints
  static const String countryCodes = '/country-codes';

  /// User endpoints
  static const String user = '/user';
  static const String userProfile = '$user/profile';
  static const String userUpdate = '$user/update';

  /// Dashboard endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '$dashboard/stats';
}
