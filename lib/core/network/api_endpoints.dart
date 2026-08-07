/// Centralized API endpoint paths matching NivaasHub API Contract (Section 1 to 7).
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:3001/api/v1';

  // ---------------------------------------------------------------------
  // 1. Authentication Screens
  // ---------------------------------------------------------------------
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String sendOtp = '/auth/send-otp';
  static const String resendOtp = '/auth/resend-otp';

  // ---------------------------------------------------------------------
  // 2. Profile & Onboarding Screens
  // ---------------------------------------------------------------------
  static const String userProfile = '/api/v1/users/profile';
  static const String activeSociety = '/api/v1/users/active-society';

  // ---------------------------------------------------------------------
  // 3. Society Management Screens
  // ---------------------------------------------------------------------
  static const String societies = '/api/v1/societies';
  static String societyById(String id) => '/api/v1/societies/$id';

  // ---------------------------------------------------------------------
  // 4. Roles & Permissions Screens
  // ---------------------------------------------------------------------
  static const String roles = '/api/v1/roles';
  static String roleById(String id) => '/api/v1/roles/$id';
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
  // 6. Home & Dashboard Screens (Community Feed)
  // ---------------------------------------------------------------------
  static const String home = '/home';
  static const String homeDashboard = '/api/v1/dashboard/home';
  static const String dashboardSummary = '/dashboard/summary';
  static const String userAddresses = '/user/addresses';
  static const String addAddress = '/user/address';
  static const String visitorsPending = '/visitors/pending';
  static const String emergencySos = '/emergency/sos';
  static const String approvals = '/api/v1/approvals';
  static String visitorAction(String visitorId) =>
      '/api/v1/visitors/$visitorId/action';
  static String visitorDetails(String visitorId) =>
      '/api/v1/visitors/$visitorId';

  // ---------------------------------------------------------------------
  // 7. Community Features Screens (Posts, Likes & Comments)
  // ---------------------------------------------------------------------
  static const String posts = '/api/v1/posts';
  static String postById(String postId) => '/api/v1/posts/$postId';
  static String postLike(String postId) => '/api/v1/posts/$postId/like';
  static String postComments(String postId) => '/api/v1/posts/$postId/comments';
  static String postCommentById(String postId, String commentId) =>
      '/api/v1/posts/$postId/comments/$commentId';

  // Legacy / fallback endpoints
  static const String banners = '/banners';
  static const String notices = '/notices';
  static const String communityPosts = '/community/posts';

  // Creation & Interaction Endpoints
  static const String createPost = '/api/v1/posts';
  static const String createPoll = '/api/v1/posts/poll';
  static const String createEvent = '/api/v1/posts/event';
  static const String uploadMedia = '/api/v1/media/upload';
  static const String likePost = '/api/v1/posts/like';
  static const String commentPost = '/api/v1/posts/comment';
  static const String deletePost = '/api/v1/posts';
}
