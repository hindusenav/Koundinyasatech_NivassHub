/// Centralized API endpoint paths. Feature services build requests from
/// these constants — no path should ever be hardcoded as a string literal
/// inside a service call.
///
/// NOTE: [baseUrl] and every path below are placeholders until the real
/// backend API contract is available — update them in one place here once
/// it is.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:3001/api/v1';

  // ---------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // ---------------------------------------------------------------------
  // Dashboard
  // ---------------------------------------------------------------------
  static const String dashboardSummary = '/dashboard/summary';

  // ---------------------------------------------------------------------
  // Society management
  // ---------------------------------------------------------------------
  static const String societies = '/societies';
  static String societyById(String id) => '/societies/$id';

  // ---------------------------------------------------------------------
  // Tower management
  // ---------------------------------------------------------------------
  static String towers(String societyId) => '/societies/$societyId/towers';
  static String towerById(String societyId, String towerId) =>
      '/societies/$societyId/towers/$towerId';

  // ---------------------------------------------------------------------
  // Unit management
  // ---------------------------------------------------------------------
  static String units(String towerId) => '/towers/$towerId/units';
  static String unitById(String unitId) => '/units/$unitId';

  // ---------------------------------------------------------------------
  // Resident management
  // ---------------------------------------------------------------------
  static const String residents = '/residents';
  static String residentById(String id) => '/residents/$id';

  // ---------------------------------------------------------------------
  // Visitor management
  // ---------------------------------------------------------------------
  static const String visitors = '/visitors';
  static String visitorById(String id) => '/visitors/$id';
  static const String visitorCheckIn = '/visitors/check-in';
  static const String visitorCheckOut = '/visitors/check-out';

  // ---------------------------------------------------------------------
  // Complaints
  // ---------------------------------------------------------------------
  static const String complaints = '/complaints';
  static String complaintById(String id) => '/complaints/$id';

  // ---------------------------------------------------------------------
  // Notices
  // ---------------------------------------------------------------------
  static const String notices = '/notices';
  static String noticeById(String id) => '/notices/$id';

  // ---------------------------------------------------------------------
  // Profile / settings
  // ---------------------------------------------------------------------
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';

  // ---------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------
  static const String uploadFile = '/upload';
}
