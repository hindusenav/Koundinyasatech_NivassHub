import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/create_user_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';

enum UserDetailsStatus { idle, submitting, success, error }

/// Backs the registration form.
///
/// Holds only what a `Form` cannot — the role and sub-branch choices and
/// the submission status. The text fields stay in `TextEditingController`s
/// owned by the screen's `State`, matching the repo's existing auth
/// screens.
class UserDetailsProvider extends ChangeNotifier {
  UserDetailsProvider({
    required AuthEntryServiceBase authService,
    required AuthStateProvider authState,
  }) : _authService = authService,
       _authState = authState;

  final AuthEntryServiceBase _authService;
  final AuthStateProvider _authState;

  UserDetailsStatus _status = UserDetailsStatus.idle;
  UserRole? _role;
  String? _subBranch;
  String? _errorMessage;

  /// Set once the form has been submitted, so validation errors on the
  /// role and sub-branch pickers appear then rather than while the user
  /// is still filling the form in.
  bool _showValidation = false;

  CreateUserResponseData? _result;

  UserDetailsStatus get status => _status;
  UserRole? get role => _role;
  String? get subBranch => _subBranch;
  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _status == UserDetailsStatus.submitting;
  bool get showValidation => _showValidation;
  CreateUserResponseData? get result => _result;

  String? get roleError =>
      _showValidation && _role == null ? KycStrings.roleRequired : null;

  String? get subBranchError => _showValidation && (_subBranch?.isEmpty ?? true)
      ? KycStrings.subBranchRequired
      : null;

  void setRole(UserRole role) {
    _role = role;
    _errorMessage = null;
    notifyListeners();
  }

  void setSubBranch(String subBranch) {
    _subBranch = subBranch;
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

  /// Submits the registration and, on success, records the returned
  /// `kycToken` and moves the flow to `kycPending` — so a restart before
  /// the KYC screen renders still resumes in the right place.
  Future<bool> createUser({
    required AuthIdentifier identifier,
    required String fullName,
    required String mobileNumber,
    required String countryCode,
    required String email,
    required LocationSelection location,
  }) async {
    final role = _role;
    final subBranch = _subBranch;
    if (role == null || subBranch == null || subBranch.isEmpty) {
      markValidationVisible();
      return false;
    }

    _status = UserDetailsStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.createUser(
      CreateUserRequest(
        fullName: fullName,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
        email: email,
        role: role,
        subBranch: subBranch,
        location: location,
      ),
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      _result = data;

      await _authState.saveKycToken(data.kycToken);
      await _authState.moveTo(
        // `kycRequired: false` is a defensive branch the mock never
        // produces, but a real backend may: such an account has nothing
        // to review, so it is already approved and only needs a token.
        data.kycRequired ? AuthFlowState.kycPending : AuthFlowState.approved,
        context: _authState.context.copyWith(
          identifier: identifier,
          userId: data.userId,
          fullName: fullName,
          email: email,
          role: role,
          subBranch: subBranch,
          location: location,
        ),
      );

      _status = UserDetailsStatus.success;
      notifyListeners();
      return true;
    }

    _errorMessage = response.message ?? KycStrings.genericError;
    _status = UserDetailsStatus.error;
    notifyListeners();
    return false;
  }
}
