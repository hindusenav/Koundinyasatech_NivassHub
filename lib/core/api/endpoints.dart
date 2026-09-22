/// Centralized API endpoint paths matching NivaasHub API Contract (Sections 1 to 10).
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.10.10.18:3001';

  // ---------------------------------------------------------------------
  // 1b. Identifier-first authentication entry (mobile OR email)
  //
  // Replaces the OTP entry above as the app's front door: one identifier
  // is checked, then the user is routed to password login or registration.
  //
  // `checkUserExists`/`loginUser` match the documented NivaasHub contract
  // exactly (`POST /country-codes/registration-check`, `POST /auth/login`
  // — neither uses the `/api/v1` prefix). `createUser`/`accessToken` do
  // NOT correspond to any documented endpoint — MISSING API CONTRACT.
  // `AuthEntryService` must never call them; `MockAuthEntryService`
  // continues to back those two methods even once the others go real.
  // See `PartialRealAuthEntryService`.
  // ---------------------------------------------------------------------
  static const String checkUserExists = '/country-codes/registration-check';
  static const String loginUser = '/auth/login';
  static const String createUser = '/api/v1/auth/users'; // MISSING API CONTRACT
  static const String accessToken =
      '/api/v1/auth/access-token'; // MISSING API CONTRACT

  // ---------------------------------------------------------------------
  // 1c. Country list / registration master data (documented)
  // ---------------------------------------------------------------------
  static const String countryCodes = '/country-codes';

  /// `GET` returns registration master data — countries (with each
  /// country's states nested inside), societies, and roles, all in one
  /// response (`ActiveCountries`/`Societies`/`Roles`; confirmed against a
  /// live response, not just the doc). `POST` submits the registration.
  /// See `RegistrationService`.
  static const String userRegistration = '/country-codes/user-registration';

  /// `GET ?socid=<id>` returns one society's full Tower→Floor→Unit tree.
  /// See `SocietyService`.
  static const String societyDetails = '/society/details';

  /// `POST` verifies the OTP sent after registration (`userId`, `otp`,
  /// `identifier` = `"M"`/`"E"`, `otpType` = `"UR"`). See
  /// `OtpVerificationService`.
  static const String userRegistrationVerifyOtp =
      '/country-codes/user-registration/verify-otp';

  /// `POST` resends a registration OTP for an existing encrypted `uid`.
  /// See `OtpVerificationService`.
  static const String otpResend = '/otp/resend';

  // ---------------------------------------------------------------------
  // 2. Cascading property location master data
  //
  // One endpoint for all seven levels — `?level=city&parentId=IN-KA`.
  // See `LocationServiceBase` for why this is not seven endpoints.
  //
  // MISSING API CONTRACT for every level except `country` (served for real
  // via `countryCodes`/`CountryService` instead) — state/city/society/
  // tower/floor/flat have no documented endpoint, so `LocationService`
  // stays mocked for those levels regardless of `KycConfig.useMockKycApi`.
  // ---------------------------------------------------------------------
  static const String locations = '/api/v1/locations';

  // ---------------------------------------------------------------------
  // 2b. KYC (role-based documents)
  // ---------------------------------------------------------------------
  static const String kycUpload = '/api/v1/kyc/documents';
  static const String kycSubmit = '/api/v1/kyc/submit';
  static String kycStatus(String kycId) => '/api/v1/kyc/$kycId/status';
  static String kycDocumentById(String documentId) =>
      '/api/v1/kyc/documents/$documentId';

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
  static String visitorAction(String visitorId) =>
      '/api/v1/visitors/$visitorId/action';

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
  // Forgot Password
  //
  // No `/api/v1` prefix on these three, matching the documented contract.
  // The doc's sample requests show `localhost:3000` purely as an example
  // dev host for these calls, same as every other documented endpoint —
  // not a second production host, so no `baseUrl` override is needed.
  // ---------------------------------------------------------------------
  static const String forgotPassword = '/auth/forgot-password';
  static const String forgotPasswordVerifyOtp =
      '/auth/forgot-password/verify-otp';
  static const String forgotPasswordUpdatePassword =
      '/auth/forgot-password/update-password';

  // ---------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------
  static const String uploadFile = '/upload';

  // Legacy / fallback banner endpoint
  static const String banners = '/banners';
}
