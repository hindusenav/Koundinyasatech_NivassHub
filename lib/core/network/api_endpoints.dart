// lib/core/network/api_endpoints.dart
//
// Centralized API endpoint definitions.
// Never hardcode endpoint strings anywhere else in the project.

class ApiEndpoints {
  ApiEndpoints._();

  // ===========================================================================
  // Base URLs
  // ===========================================================================

  /// Development
  static const String baseUrl = 'http://localhost:3001/api/v1';

  /// Production
  static const String productionBaseUrl = 'https://api.payo.com/api/v1';

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String sendOtp = '/auth/send-otp';

  static const String verifyOtp = '/auth/verify-otp';

  static const String resendOtp = '/auth/resend-otp';

  static const String register = '/auth/register';

  // ===========================================================================
  // Dashboard / Home
  // ===========================================================================

  static const String dashboardSummary = '/dashboard/summary';

  static const String home = '/home';

  // ===========================================================================
  // User
  // ===========================================================================

  static const String userAddresses = '/user/addresses';

  static const String addAddress = '/user/address';

  // ===========================================================================
  // Visitors
  // ===========================================================================

  static const String pendingVisitors = '/visitors/pending';

  static const String approveVisitor = '/visitors/approve';

  static const String rejectVisitor = '/visitors/reject';

  // ===========================================================================
  // Guard
  // ===========================================================================

  static const String guardContact = '/guard/contact';

  // ===========================================================================
  // Advertisements / Banner
  // ===========================================================================

  static const String banners = '/banners';

  // ===========================================================================
  // Announcements / Notices
  // ===========================================================================

  static const String latestAnnouncement = '/announcements/latest';

  // ===========================================================================
  // Emergency
  // ===========================================================================

  static const String sos = '/emergency/sos';

  // ===========================================================================
  // Community Feed (Placeholder APIs)
  // Replace these when backend APIs are available.
  // ===========================================================================

  // GET /community/posts
  static const String communityPosts = '/community/posts';

  // GET /community/notices
  static const String notices = '/community/notices';

  // GET Complete Feed
  static const String communityFeed = '/feed';

  // GET Advertisements (alternative feed endpoint if provided later)
  static const String advertisements = '/advertisements';
}
