/// Centralized named-route constants. Screens navigate via
/// `Navigator.pushNamed(context, AppRoutes.xxx)` — no route path should ever
/// be a string literal at the call site.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  // ---------------------------------------------------------------------
  // Welcome
  // ---------------------------------------------------------------------
  static const String welcome = '/welcome';

  // ---------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------
  static const String onboardingStepTwo = '/onboarding/step-two';

  // ---------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String otpVerification = '/auth/otp-verification';
  static const String otpVerificationSuccess = '/auth/otp-verification-success';
  static const String createProfile = '/auth/create-profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String forgotPasswordMobile = '/auth/forgot-password/mobile';
  static const String forgotPasswordEmail = '/auth/forgot-password/email';
  static const String forgotPasswordVerifyOtp = '/auth/forgot-password/verify-otp';
  static const String updatePassword = '/auth/forgot-password/update-password';

  // ---------------------------------------------------------------------
  // Dashboard
  // ---------------------------------------------------------------------
  static const String dashboard = '/dashboard';

  // ---------------------------------------------------------------------
  // Society management
  // ---------------------------------------------------------------------
  static const String societyList = '/society';
  static const String societyDetail = '/society/detail';
  static const String societyForm = '/society/form';

  // ---------------------------------------------------------------------
  // Tower management
  // ---------------------------------------------------------------------
  static const String towerList = '/tower';
  static const String towerDetail = '/tower/detail';
  static const String towerForm = '/tower/form';

  // ---------------------------------------------------------------------
  // Unit management
  // ---------------------------------------------------------------------
  static const String unitList = '/unit';
  static const String unitDetail = '/unit/detail';
  static const String unitForm = '/unit/form';

  // ---------------------------------------------------------------------
  // Resident management
  // ---------------------------------------------------------------------
  static const String residentList = '/resident';
  static const String residentDetail = '/resident/detail';
  static const String residentForm = '/resident/form';

  // ---------------------------------------------------------------------
  // Visitor management
  // ---------------------------------------------------------------------
  static const String visitorList = '/visitor';
  static const String visitorDetail = '/visitor/detail';
  static const String visitorForm = '/visitor/form';

  /// Full gate/delivery activity log, pushed from Home's Approval Queue
  /// "View all" link (NivasHub API Contract §6.2 — `GET /api/v1/approvals`).
  static const String activities = '/visitor/activities';

  // ---------------------------------------------------------------------
  // Complaints
  // ---------------------------------------------------------------------
  static const String complaintList = '/complaint';
  static const String complaintDetail = '/complaint/detail';
  static const String complaintForm = '/complaint/form';

  // ---------------------------------------------------------------------
  // Notices / Community Feed
  // ---------------------------------------------------------------------
  /// Full Notice Board, pushed from Home's Community Posts section
  /// ("View all" / "New Posts").
  static const String noticeList = '/notice';

  // ---------------------------------------------------------------------
  // Profile / settings
  // ---------------------------------------------------------------------
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addAddressDetails = '/profile/add-address-details';
  static const String settings = '/settings';
  static const String helpSupport = '/settings/help-support';

  // ---------------------------------------------------------------------
  // Search / Quick Actions
  // ---------------------------------------------------------------------
  static const String search = '/search';
  static const String quickActions = '/quick-actions';
}