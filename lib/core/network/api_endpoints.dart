/// Centralized API endpoint paths matching NivaasHub API Contract (Sections 1 to 10).
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:3001';

  // ---------------------------------------------------------------------
  // 1. Authentication Screens
  // ---------------------------------------------------------------------
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String sendOtp = '/api/v1/auth/login';
  static const String resendOtp = '/api/v1/auth/login';

  // ---------------------------------------------------------------------
  // 3. Society Management (Admin) Screens
  // ---------------------------------------------------------------------
  static const String societies = '/api/v1/societies';
  static String societyById(String societyId) => '/api/v1/societies/$societyId';

  // ---------------------------------------------------------------------
  // 4. Roles & Permissions Screens
  // ---------------------------------------------------------------------
  static const String roles = '/api/v1/roles';
  static String roleById(String roleId) => '/api/v1/roles/$roleId';
  static String updateRole(String roleId) => '/api/v1/roles/$roleId';
  static const String permissionsMatrix = '/api/v1/permissions/matrix';
  static const String usersSearch = '/api/v1/users/search';
  static String assignRole(String userId) =>
      '/api/v1/users/$userId/assign-role';

  // ---------------------------------------------------------------------
  // 5. Tower & Unit Management Screens
  // ---------------------------------------------------------------------
  static String towers(String societyId) =>
      '/api/v1/societies/$societyId/towers';
  static String towerById(String societyId, String towerId) =>
      '/api/v1/societies/$societyId/towers/$towerId';

  static String units(String societyId) => '/api/v1/societies/$societyId/units';
  static String unitById(String societyId, String unitId) =>
      '/api/v1/societies/$societyId/units/$unitId';

  // ---------------------------------------------------------------------
  // 6. Home & Dashboard Screens
  // ---------------------------------------------------------------------
  static const String home = '/api/v1/dashboard/home';
  static const String userAddresses = '/api/v1/users/profile';
  static const String visitorsPending = '/api/v1/approvals';
  static const String emergencySos = '/api/v1/emergency/sos';
  static String visitorDetails(String visitorId) =>
      '/api/v1/visitors/$visitorId';

  // ---------------------------------------------------------------------
  // 7. Community Features Screens (Posts, Likes & Comments)
  // ---------------------------------------------------------------------
  static const String posts = '/api/v1/posts';
  static String postById(String postId) => '/api/v1/posts/$postId';
  static String postLike(String postId) => '/api/v1/posts/$postId/like';
  static String postUnlike(String postId) => '/api/v1/posts/$postId/like';
  static String postComments(String postId) => '/api/v1/posts/$postId/comments';
  static String getPostComments(String postId) =>
      '/api/v1/posts/$postId/comments';
  static String postCommentById(String postId, String commentId) =>
      '/api/v1/posts/$postId/comments/$commentId';

  // ---------------------------------------------------------------------
  // 8. Community Posts, Polls & Events Creation
  // ---------------------------------------------------------------------
  static const String communityCreatePost = '/api/v1/community/posts';
  static const String communityCreatePoll = '/api/v1/community/polls';
  static const String communityCreateEvent = '/api/v1/community/events';

  /// Approve/reject a visitor from the Home screen's gate-arrival banner
  /// (NivasHub API Contract §6.3 — `POST /api/v1/visitors/{visitorId}/action`).
  /// Still mock-only — see `MockVisitorNotificationService`.
  static String visitorAction(String visitorId) => '/api/v1/visitors/$visitorId/action';

  /// Activities screen's gate/delivery log (NivasHub API Contract §6.2).
  /// Still mock-only — see `MockVisitorActivityService`.
  static const String approvals = '/api/v1/approvals';

  /// "Filter Activity by Type" bottom sheet's option catalog. Not in the
  /// API contract at all yet (no Figma/endpoint published) — still
  /// mock-only, see `MockActivityTypeFilterService`.
  static const String activityTypeFilters = '/activities/type-filters';

  // ---------------------------------------------------------------------
  // 9. Profile Screens
  // ---------------------------------------------------------------------
  static const String myProfile = '/api/v1/profile';
  static const String updateProfile = '/api/v1/profile';
  static const String profileImages = '/api/v1/profile/images';
  static const String callingPreference = '/api/v1/profile/calling-preference';

  // ---------------------------------------------------------------------
  // 10. Settings & Master Data
  // ---------------------------------------------------------------------
  static const String settings = '/api/v1/settings';
  static const String masterInterests = '/api/v1/master/interests';

  // ---------------------------------------------------------------------
  // 10 (Notice Board) Screens
  // ---------------------------------------------------------------------
  static const String noticeBoard = '/api/v1/notice-board';
  static String noticeBoardById(String id) => '/api/v1/notice-board/$id';
  static String markNoticeRead(String id) => '/api/v1/notice-board/$id/read';

  // ---------------------------------------------------------------------
  // Profile / Active Society (NivasHub Mobile App API Contract v1.0, §2)
  // ---------------------------------------------------------------------
  static const String userProfile = '/api/v1/users/profile';
  static const String activeSociety = '/api/v1/users/active-society';

  // ---------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------
  static const String uploadFile = '/upload';

  // Legacy / fallback banner endpoint
  static const String banners = '/banners';
}
