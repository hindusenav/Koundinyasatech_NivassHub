/// Centralized API endpoint paths. Feature services build requests from
/// these constants — no path should ever be hardcoded as a string literal
/// inside a service call.
///
/// NOTE: every path below other than the "Home Screen" section is a
/// placeholder until its real backend API contract is available — update it
/// in one place here once it is. [baseUrl] matches the NivasHub Mobile App
/// Authentication API Contract (v1.0) dev URL.
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
  // Home Screen (NivasHub Mobile App API Contract v1.0)
  // ---------------------------------------------------------------------
  static const String home = '/home';
  static const String userAddresses = '/user/addresses';
  static const String addAddress = '/user/address';
  static const String visitorsPending = '/visitors/pending';
  static const String banners = '/banners';
  static const String emergencySos = '/emergency/sos';

  // ---------------------------------------------------------------------
  // Guard
  // ---------------------------------------------------------------------
  static const String guardContact = '/guard/contact';

  // ---------------------------------------------------------------------
  // Visitor actions (gate approval flow)
  // ---------------------------------------------------------------------
  static const String approveVisitor = '/visitors/approve';
  static const String rejectVisitor = '/visitors/reject';

  // ---------------------------------------------------------------------
  // Community Feed (Placeholder APIs)
  // Replace these when backend APIs are available.
  // ---------------------------------------------------------------------
  static const String communityPosts = '/community/posts';
  static const String notices = '/community/notices';
  static const String communityFeed = '/feed';
  static const String advertisements = '/advertisements';
  static const String latestAnnouncement = '/announcements/latest';

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

  /// Approve/reject a visitor from the Home screen's gate-arrival banner
  /// (NivasHub API Contract §6.3 — `POST /api/v1/visitors/{visitorId}/action`).
  /// Still mock-only — see `MockVisitorNotificationService`.
  static String visitorAction(String visitorId) => '/visitors/$visitorId/action';

  /// Activities screen's gate/delivery log (NivasHub API Contract §6.2).
  /// Still mock-only — see `MockVisitorActivityService`.
  static const String approvals = '/approvals';

  /// "Filter Activity by Type" bottom sheet's option catalog. Not in the
  /// API contract at all yet (no Figma/endpoint published) — still
  /// mock-only, see `MockActivityTypeFilterService`.
  static const String activityTypeFilters = '/activities/type-filters';

  // ---------------------------------------------------------------------
  // Complaints
  // ---------------------------------------------------------------------
  static const String complaints = '/complaints';
  static String complaintById(String id) => '/complaints/$id';

  // ---------------------------------------------------------------------
  // Notices management (CRUD)
  // ---------------------------------------------------------------------
  static const String noticesManagement = '/notices';
  static String noticeById(String id) => '/notices/$id';

  // ---------------------------------------------------------------------
  // Profile / settings
  // ---------------------------------------------------------------------
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';

  // ---------------------------------------------------------------------
  // Profile / Active Society (NivasHub Mobile App API Contract v1.0, §2)
  // ---------------------------------------------------------------------
  static const String userProfile = '/users/profile';
  static const String activeSociety = '/users/active-society';

  // ---------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------
  static const String uploadFile = '/upload';
}
