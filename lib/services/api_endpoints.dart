// /// API Endpoints for the application
// class ApiEndpoints {
//   /// Authentication endpoints
//   static const String auth = '/auth';
//   static const String login = '$auth/login';
//   static const String logout = '$auth/logout';
//   static const String register = '$auth/register';
//   static const String refreshToken = '$auth/refresh-token';

//   /// Country endpoints
//   static const String countryCodes = '/country-codes';

//   /// User endpoints
//   static const String user = '/user';
//   static const String userProfile = '$user/profile';
//   static const String userUpdate = '$user/update';

//   /// Dashboard endpoints
//   static const String dashboard = '/dashboard';
//   static const String dashboardStats = '$dashboard/stats';
// }

////////////////////////////////////////////////////////////

// lib/core/constants/api_endpoints.dart

/// API Endpoints for the application
class ApiEndpoints {
  /// Authentication endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String logout = '$auth/logout';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh-token';

  /// Forgot Password endpoints
  static const String forgotPassword = '$auth/forgot-password';
  static const String verifyOtp = '$auth/forgot-password/verify-otp';
  static const String updatePassword = '$auth/forgot-password/update-password';

  /// Country endpoints
  static const String countryCodes = '/country-codes';
  static const String userRegistration = '$countryCodes/user-registration';

  /// User endpoints
  static const String user = '/user';
  static const String userProfile = '$user/profile';
  static const String userUpdate = '$user/update';

  /// Dashboard endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '$dashboard/stats';
}
