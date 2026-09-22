import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_response_data.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';

enum UserDetailsStatus { idle, submitting, success, error }

/// Backs the registration form.
///
/// Holds only what a `Form` cannot — the role choice and the submission
/// status. The text fields stay in `TextEditingController`s owned by the
/// screen's `State`, matching the repo's existing auth screens.
/// Country/State/City/Society/Tower/Floor/Unit selections live in
/// `LocationProvider`/`RegistrationMasterDataProvider`/
/// `SocietyDetailsProvider` respectively — this provider only assembles
/// them into the request at submit time. Unit Sub-Branch is not a
/// separate user choice; `SocietyDetailsProvider.selectedUnitBranch`
/// derives it from the selected unit's `unitTypeBhk`.
class UserDetailsProvider extends ChangeNotifier {
  UserDetailsProvider({required RegistrationServiceBase registrationService})
    : _registrationService = registrationService;

  final RegistrationServiceBase _registrationService;

  UserDetailsStatus _status = UserDetailsStatus.idle;
  UserRole? _role;
  String? _errorMessage;

  /// Set once the form has been submitted, so validation errors on the
  /// role picker appear then rather than while the user is still filling
  /// the form in.
  bool _showValidation = false;

  UserRegistrationResponseData? _result;

  UserDetailsStatus get status => _status;
  UserRole? get role => _role;
  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _status == UserDetailsStatus.submitting;
  bool get showValidation => _showValidation;
  UserRegistrationResponseData? get result => _result;

  String? get roleError =>
      _showValidation && _role == null ? KycStrings.roleRequired : null;

  void setRole(UserRole role) {
    _role = role;
    _errorMessage = null;
    notifyListeners();
  }

  /// Turns on the picker-level error messages. Called when Submit is
  /// tapped, before the form's own validation runs.
  void markValidationVisible() {
    if (_showValidation) return;
    _showValidation = true;
    notifyListeners();
  }

  /// Submits the registration. Unlike the earlier mocked flow, the real
  /// `POST /country-codes/user-registration` response carries no
  /// `kycToken` — that only exists once verify-OTP/kyc-token APIs are
  /// documented — so this deliberately does not touch `AuthStateProvider`
  /// or KYC initialisation. The screen navigates straight to the OTP
  /// screen on success instead.
  Future<UserRegistrationResponseData?> submit({
    required String fullName,
    required String mobileNumber,
    required String mobileCountryCode,
    required String email,
    required String country,
    required String state,
    required String city,
    required String socId,
    required String towerId,
    required String floorId,
    required String unitId,
    required String roleId,
    required String? unitBranch,
  }) async {
    if (_role == null) {
      markValidationVisible();
      return null;
    }

    _status = UserDetailsStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    final response = await _registrationService.submitRegistration(
      UserRegistrationRequest(
        fullName: fullName,
        mobileNumber: mobileNumber,
        mobileCountryCode: mobileCountryCode,
        email: email,
        country: country,
        state: state,
        city: city,
        socId: socId,
        towerId: towerId,
        floorId: floorId,
        unitId: unitId,
        roleId: roleId,
        unitBranch: unitBranch,
      ),
    );

    final data = response.data;
    if (response.isSuccess && data != null && data.isOk) {
      _result = data;
      _status = UserDetailsStatus.success;
      notifyListeners();
      return data;
    }

    _errorMessage = data?.message.isNotEmpty == true
        ? data!.message
        : (response.message ?? KycStrings.genericError);
    _status = UserDetailsStatus.error;
    notifyListeners();
    return null;
  }
}
