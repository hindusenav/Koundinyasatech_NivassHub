import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_user_document.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

enum KycStatusState {
  loading,
  polling,
  approved,
  rejected,
  correctionRequired,
  error,
}

/// Derives the review verdict from the user's stored documents
/// (`GET /kyc/user-documents`, fetched once by the status screen) and, on
/// approval, exchanges it for an access token.
///
/// There is no polling: the screen makes a single call and hands the result
/// to [evaluate].
class KycStatusProvider extends ChangeNotifier {
  KycStatusProvider({
    required AuthEntryServiceBase authService,
    required AuthStateProvider authState,
    required SecureStorageService secureStorage,
  }) : _authService = authService,
       _authState = authState,
       _secureStorage = secureStorage;

  final AuthEntryServiceBase _authService;
  final AuthStateProvider _authState;
  final SecureStorageService _secureStorage;

  bool _disposed = false;

  KycStatusState _state = KycStatusState.loading;
  KycStatusResponseData? _data;
  String? _errorMessage;
  String _token = '';
  bool _isGeneratingToken = false;

  KycStatusState get state => _state;
  KycStatusResponseData? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isGeneratingToken => _isGeneratingToken;

  KycReviewStage get stage => _data?.stage ?? KycReviewStage.submitted;

  KycVerificationStatus get status =>
      _data?.status ?? KycVerificationStatus.submitted;

  bool get isTerminal => status.isTerminal;

  String get reason => _data?.reason ?? KycStrings.genericError;

  /// Marks the screen as loading its one request.
  void setLoading() {
    _state = KycStatusState.loading;
    _errorMessage = null;
    _safeNotify();
  }

  /// Reports a failed load of the stored documents.
  void setError(String message) {
    _errorMessage = message;
    _state = KycStatusState.error;
    _safeNotify();
  }

  /// Computes the status from [documents]: any rejected -> rejected; all
  /// approved -> approved; otherwise under review. [token] is the latest
  /// session token, kept for [completeApproval].
  void evaluate(String token, List<KycUserDocument> documents) {
    _token = token;

    final KycVerificationStatus status;
    if (documents.any((d) => d.isRejected)) {
      status = KycVerificationStatus.rejected;
    } else if (documents.isNotEmpty && documents.every((d) => d.isApproved)) {
      status = KycVerificationStatus.approved;
    } else {
      status = KycVerificationStatus.underReview;
    }

    _data = KycStatusResponseData(
      kycId: token,
      status: status,
      stage: KycReviewStage.fromStatus(status),
    );
    _state = switch (status) {
      KycVerificationStatus.approved => KycStatusState.approved,
      KycVerificationStatus.rejected => KycStatusState.rejected,
      _ => KycStatusState.polling,
    };

    if (status == KycVerificationStatus.approved) {
      _authState.moveTo(AuthFlowState.approved);
      _secureStorage.saveKycApproved();
    }
    _safeNotify();
  }

  /// Mints and stores the access token that finally grants Dashboard
  /// entry. Returns false — leaving the approval intact so the button can
  /// be tapped again — if the call fails.
  Future<bool> completeApproval() async {
    if (_token.isEmpty) {
      _errorMessage = KycStrings.genericError;
      _safeNotify();
      return false;
    }

    _isGeneratingToken = true;
    _errorMessage = null;
    _safeNotify();

    final response = await _authService.generateAccessToken(
      userId: _token,
      kycId: _token,
    );

    if (_disposed) return false;

    if (response.isSuccess &&
        response.data != null &&
        response.data!.userAccess &&
        response.data!.accessToken.isNotEmpty) {
      await _authState.markAuthenticated(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );
      _isGeneratingToken = false;
      _safeNotify();
      return true;
    }

    _errorMessage = response.message ?? KycStrings.genericError;
    _isGeneratingToken = false;
    _safeNotify();
    return false;
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
