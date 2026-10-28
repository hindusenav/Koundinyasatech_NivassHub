/// Centralized API endpoint paths matching Nivaas Hub API Contract (Sections 1 to 10).
class ApiEndpoints {
  ApiEndpoints._();

  /// Backend origin. Set it for each environment at build time:
  ///   flutter build apk --release --dart-define=BASE_URL=https://api.yourdomain.com
  /// or change the default below. No trailing slash.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.0.104:3004',
  );

  // ---------------------------------------------------------------------
  // 1b. Identifier-first authentication entry (mobile OR email)
  //
  // One identifier is checked, then the user is routed to password login or
  // registration. Neither endpoint uses the `/api/v1` prefix.
  // ---------------------------------------------------------------------
  static const String checkUserExists = '/country-codes/registration-check';
  static const String loginUser = '/auth/login';

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

  /// `GET ?user_token=<session-token>` — master data for the Add User to
  /// Society form. See `AddSocietyService`.
  static const String addSocietyMasterData = '/society/add-master-data';

  /// `POST` JSON body (see `AddUserToSocietyRequest`) — adds the signed-in
  /// user to another society unit; the unit starts pending approval.
  static const String addUserToSociety = '/society/add-user';

  /// `GET` — vehicle brands grouped under `2W` and `4W`. See `VehicleService`.
  static const String vehicleBrands = '/vehicle-brands';

  /// `POST` JSON body (see `AddVehicleRequest`) — registers a vehicle and
  /// returns its allotted parking slot. See `VehicleService`.
  static const String addVehicle = '/vehicle/add';

  /// `GET` — family relation categories and options. See `FamilyService`.
  static const String getFamily = '/get-family';

  /// `GET ?user_token=<session-token>` — pet types and their breeds for the
  /// Add Pet form. See `PetService`.
  static const String addPet = '/pet/add-pet';

  /// `POST` multipart/form-data (`pettype`, `breedtype`, `petname`,
  /// `petcolour`, `petpicture` file, vaccination fields) — creates a pet.
  /// See `PetService`.
  static const String addPetDetails = '/pet/adding-pet-details';

  /// `POST` JSON body (see `AddFamilyRequest`) — adds a family member for the
  /// signed-in user. See `FamilyService`.
  static const String addFamily = '/get-family/add-family';

  /// `POST` verifies the OTP sent after registration (`userId`, `otp`,
  /// `identifier` = `"M"`/`"E"`, `otpType` = `"UR"`). See
  /// `OtpVerificationService`.
  static const String userRegistrationVerifyOtp =
      '/country-codes/user-registration/verify-otp';

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
  //
  // `kycDocuments` (`GET ?user_token=<encrypted-user-token>`) returns the
  // backend-configured document list for the caller's role — the frontend
  // never hardcodes which documents to ask for. `kycUpload` is the
  // per-document multipart upload (`user_id`, `doc_id`, plus the file),
  // called once per document, same as `kycDocuments` returns them.
  // Neither carries the `/api/v1` prefix, matching every other documented,
  // real (non-`/api/v1`) endpoint in this contract.
  // ---------------------------------------------------------------------
  static const String kycDocuments = '/kyc/documents';
  static const String kycUpload = '/kyc/upload';
  static const String kycReUpload = '/kyc/re-upload';

  /// `GET ?user_token=<session-token>` — the user's stored KYC documents
  /// (distinct from `kycDocuments`, which lists applicable document types).
  static const String kycUserDocuments = '/kyc/user-documents';
  static String kycDocumentById(String documentId) =>
      '/api/v1/kyc/documents/$documentId';

  // ---------------------------------------------------------------------
  // 6. Home & Dashboard Screens
  // ---------------------------------------------------------------------
  static const String home = '/api/v1/dashboard/home';
  static const String userAddresses = '/api/v1/users/profile';
  static const String visitorsPending = '/api/v1/approvals';
  static const String emergencySos = '/api/v1/emergency/sos';

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

  // ---------------------------------------------------------------------
  // 8. Community Posts, Polls & Events Creation
  // ---------------------------------------------------------------------
  static const String communityCreatePost = '/api/v1/community/posts';
  static const String communityCreatePoll = '/api/v1/community/polls';
  static const String communityCreateEvent = '/api/v1/community/events';

  /// Approve/reject a visitor from the Home screen's gate-arrival banner
  /// (Nivaas Hub API Contract §6.3 — `POST /api/v1/visitors/{visitorId}/action`).
  /// Still mock-only — see `MockVisitorNotificationService`.
  static String visitorAction(String visitorId) =>
      '/api/v1/visitors/$visitorId/action';

  // ---------------------------------------------------------------------
  // 9. Profile Screens
  // ---------------------------------------------------------------------
  static const String profileImages = '/api/v1/profile/images';

  // ---------------------------------------------------------------------
  // 10 (Notice Board) Screens
  // ---------------------------------------------------------------------
  static const String noticeBoard = '/api/v1/notice-board';
  static String noticeBoardById(String id) => '/api/v1/notice-board/$id';
  static String markNoticeRead(String id) => '/api/v1/notice-board/$id/read';

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
  // Legacy / fallback banner endpoint
  static const String banners = '/banners';
}
