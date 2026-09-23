/// User-facing copy for the authentication-entry, registration and KYC
/// flow. Mirrors `string_constants.dart`'s role for generic copy — this
/// file holds everything specific to these screens so no literal ships
/// inside a widget, and so an `intl`/ARB migration has one place to look.
class KycStrings {
  KycStrings._();

  // ---------------------------------------------------------------------
  // Authentication entry
  // ---------------------------------------------------------------------
  static const String authEntryTitle = 'Welcome to NivassHub';
  static const String authEntrySubtitle =
      'Enter your mobile number or email to continue.';
  static const String mobileLabel = 'Mobile Number';
  static const String mobileHint = 'Enter mobile number';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'Enter email address';
  static const String countryCodeLabel = 'Country Code';
  static const String countryCodeSheetTitle = 'Select Country Code';
  static const String countryCodeRequired = 'Please select a country code';
  static const String useEmailInstead = 'Use email instead';
  static const String useMobileInstead = 'Use mobile number instead';
  static const String continueLabel = 'Continue';

  // ---------------------------------------------------------------------
  // Password
  // ---------------------------------------------------------------------
  static const String enterPasswordTitle = 'Enter Your Password';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter password';
  static const String loginLabel = 'Login';
  static const String forgotPassword = 'Forgot Password?';

  /// Spec §3 — shown inline, never as a navigation-blocking dialog.
  static const String invalidPassword = 'Invalid password. Please try again.';

  // ---------------------------------------------------------------------
  // User details
  // ---------------------------------------------------------------------
  static const String userDetailsTitle = 'Complete Your Profile';
  static const String userDetailsSubtitle =
      'Tell us about you and your home so we can set up your account.';
  static const String sectionPersonalDetails = 'Personal Details';
  static const String sectionLocationDetails = 'Location Details';
  static const String sectionPropertyDetails = 'Property Details';
  static const String sectionRole = 'Your Role';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Enter your full name';
  static const String roleOwner = 'Owner';
  static const String roleTenant = 'Tenant';
  static const String roleRequired = 'Please select your role';
  static const String subBranchLabel = 'Unit Sub-Branch';
  // Auto-filled from the selected unit's BHK type — not a free choice.
  static const String subBranchHint = 'Auto-filled from the selected unit';
  static const String selectUnitFirst = 'Select unit first';
  static const String subBranchSheetTitle = 'Select Sub-Branch';
  static const String subBranchRequired = 'Please select a sub-branch';
  static const String submitDetails = 'Submit Details';
  static const String selectParentFirst = 'Select the previous field first';

  static const String stateLabel = 'State';
  static const String stateHint = 'Select state';
  static const String selectCountryFirst = 'Select country first';
  static const String cityLabel = 'City';
  static const String cityHint = 'Select city';
  static const String cityRequired = 'Please select your city';
  static const String selectStateFirst = 'Select state first';

  static const String societyLabel = 'Society';
  static const String societyHint = 'Select society';
  static const String towerLabel = 'Tower / Block';
  static const String towerHint = 'Select tower';
  static const String floorLabel = 'Floor';
  static const String floorHint = 'Select floor';
  static const String unitLabel = 'Unit';
  static const String unitHint = 'Select unit';
  static const String selectCityFirst = 'Select city first';
  static const String selectSocietyFirst = 'Select society first';
  static const String selectTowerFirst = 'Select tower first';
  static const String selectFloorFirst = 'Select floor first';
  static const String propertySelectionIncomplete =
      'Please select your society, tower, floor and unit.';

  // ---------------------------------------------------------------------
  // OTP verification (mobile + email)
  // ---------------------------------------------------------------------
  static const String otpVerificationTitle = 'Verify Your Details';
  static const String otpVerificationSubtitle =
      'Enter the codes sent to your mobile number and email address.';
  static const String otpMobileSectionTitle = 'Mobile Verification';
  static const String otpEmailSectionTitle = 'Email Verification';
  static const String otpVerifyLabel = 'Verify';
  static const String otpVerifiedLabel = 'Verified';
  static const String otpIncompleteError = 'Enter the 6-digit code';
  static const String otpVerificationContinue = 'Continue';

  // ---------------------------------------------------------------------
  // KYC documents
  // ---------------------------------------------------------------------
  static const String kycTitle = 'KYC Verification';
  static const String kycSubtitle =
      'Upload the documents below to verify your identity and your home.';
  static const String kycResubmitSubtitle =
      'Replace the documents flagged below, then submit again.';
  static const String uploadDocument = 'Upload Document';
  static const String replaceDocument = 'Replace';
  static const String removeDocument = 'Remove';
  static const String retryUpload = 'Retry';
  static const String uploading = 'Uploading...';
  static const String statusPending = 'Pending';
  static const String statusUploaded = 'Uploaded';
  static const String statusPreserved = 'Previously verified';
  static const String statusFailed = 'Upload failed';
  static const String statusNeedsReplacement = 'Needs replacement';
  static const String submitKyc = 'Submit KYC';
  static const String uploadSourceSheetTitle = 'Add Document';
  static const String uploadSourceFile = 'Choose file';
  static const String uploadSourceCamera = 'Take photo';
  static const String uploadSourceGallery = 'Choose from gallery';
  static const String fileSizeHint = 'PDF, JPG or PNG up to 5 MB';

  /// Emitted by `FilePickerService` when the camera permission has been
  /// permanently denied. Screens compare an upload error against this
  /// exact string to decide whether to offer "Open Settings" instead of a
  /// plain retry.
  static const String cameraPermanentlyDeniedMessage =
      'Camera permission is turned off for this app. '
      'Enable it from Settings to take a photo.';

  // Document card copy
  static const String addressProofOneTitle = 'Address Proof — Document 1';
  static const String addressProofOneSubtitle =
      'Aadhaar, passport or driving licence';
  static const String addressProofTwoTitle = 'Address Proof — Document 2';
  static const String addressProofTwoSubtitle =
      'Utility bill, bank statement or voter ID';
  static const String registrationProofTitle = 'Registration Proof';
  static const String registrationProofSubtitle =
      'Sale deed or property registration certificate';
  static const String rentalAgreementTitle = 'Rental Agreement';
  static const String rentalAgreementSubtitle =
      'Signed lease or rental agreement for this flat';

  // ---------------------------------------------------------------------
  // Verification status
  // ---------------------------------------------------------------------
  static const String verificationTitle = 'KYC Submitted Successfully';
  static const String verificationStatusLabel = 'Status';
  static const String verificationBody =
      'Your documents have been submitted successfully and are currently '
      'being reviewed by the administrator.';
  static const String stageSubmitted = 'Submitted';
  static const String stageUnderReview = 'Under Review';
  static const String stageAdminReview = 'Admin Review';
  static const String stageProcessing = 'Processing';
  static const String verdictApprovedTitle = 'KYC Approved';
  static const String verdictApprovedBody =
      'Your verification is complete. You now have full access to NivassHub.';
  static const String verdictUnsuccessfulTitle =
      'KYC Verification Unsuccessful';
  static const String verdictCorrectionTitle = 'Correction Required';
  static const String reasonLabel = 'Reason';
  static const String correctAndResubmit = 'Correct & Re-submit';
  static const String goToDashboard = 'Go to Dashboard';

  // ---------------------------------------------------------------------
  // Errors (never expose a raw exception — spec §20)
  // ---------------------------------------------------------------------
  static const String identifierRequired =
      'Enter a mobile number or email address';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String uploadFailed =
      'We could not upload that document. Please try again.';
  static const String submitFailed =
      'We could not submit your KYC. Please try again.';
  static const String statusFetchFailed =
      'We could not fetch your verification status. Please try again.';
  static const String locationLoadFailed =
      'We could not load these options. Please try again.';
  static const String noOptionsAvailable = 'No options available';
  static const String noOptionsMessage =
      'There is nothing to choose from here yet. Try a different selection above.';

  static String unsupportedFileType(List<String> allowed) =>
      'Unsupported file type. Allowed: ${allowed.join(', ').toUpperCase()}.';

  static String fileTooLarge(int maxBytes) =>
      'File is too large. Maximum size is ${maxBytes ~/ (1024 * 1024)} MB.';

  // ---------------------------------------------------------------------
  // Mock email notifications (spec §16)
  // ---------------------------------------------------------------------
  static const String notificationLogTitle = 'Notification Log (Mock)';
  static const String notificationLogEmpty = 'No notifications yet';
  static const String notificationLogEmptyMessage =
      'Mock KYC emails will appear here once your verification is reviewed.';

  static const String emailApprovedSubject = 'NivassHub KYC Approved';
  static const String emailRejectedSubject = 'NivassHub KYC Rejected';
  static const String emailCorrectionSubject =
      'NivassHub KYC Correction Required';

  static String emailApprovedBody(String name) =>
      'Hi $name,\n\n'
      'Your KYC verification has been successfully completed. '
      'You can now access your NivassHub account.\n\n'
      '— The NivassHub Team';

  static String emailRejectedBody(String name, String reason) =>
      'Hi $name,\n\n'
      'Your KYC verification could not be completed.\n\n'
      'Reason:\n$reason\n\n'
      '— The NivassHub Team';

  static String emailCorrectionBody(String name, String reason) =>
      'Hi $name,\n\n'
      'Additional information or documents are required to complete your '
      'KYC verification.\n\n'
      'Reason:\n$reason\n\n'
      '— The NivassHub Team';
}
