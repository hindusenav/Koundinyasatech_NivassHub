import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status_response_data.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

enum KycStatusState {
  loading,
  polling,
  approved,
  rejected,
  correctionRequired,
  error,
}

/// Polls the review status and, on approval, exchanges it for an access
/// token.
///
/// Screen-scoped, and this is the strongest scoping argument in the
/// feature: it owns a `Timer.periodic`, and a route-scoped `dispose()` is
/// the only reliable place to cancel it. A global instance would keep
/// polling behind the Dashboard forever.
class KycStatusProvider extends ChangeNotifier {
  KycStatusProvider({
    required KycServiceBase kycService,
    required AuthEntryServiceBase authService,
    required AuthStateProvider authState,
    required SecureStorageService secureStorage,
  }) : _kycService = kycService,
       _authService = authService,
       _authState = authState,
       _secureStorage = secureStorage;

  final KycServiceBase _kycService;
  final AuthEntryServiceBase _authService;
  final AuthStateProvider _authState;
  final SecureStorageService _secureStorage;

  Timer? _timer;
  bool _disposed = false;

  KycStatusState _state = KycStatusState.loading;
  KycStatusResponseData? _data;
  String? _errorMessage;
  String _kycId = '';
  bool _isGeneratingToken = false;

  KycStatusState get state => _state;
  KycStatusResponseData? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isGeneratingToken => _isGeneratingToken;

  KycReviewStage get stage => _data?.stage ?? KycReviewStage.submitted;

  KycVerificationStatus get status =>
      _data?.status ?? KycVerificationStatus.submitted;

  bool get isTerminal => status.isTerminal;

  bool get canResubmit => _data?.canResubmit ?? false;

  String get reason => _data?.reason ?? KycStrings.genericError;

  /// Fetches once immediately — so a resumed flow shows a frozen verdict
  /// without waiting a poll interval — then repeats until terminal.
  Future<void> startPolling(String kycId) async {
    _kycId = kycId;
    await _fetch();
    if (_disposed || isTerminal) return;

    _timer?.cancel();
    _timer = Timer.periodic(KycConfig.statusPollInterval, (_) => _fetch());
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> retry() => startPolling(_kycId);

  Future<void> _fetch() async {
    final response = await _kycService.getKycStatus(kycId: _kycId);

    // The timer fires across awaits, so the provider may already be gone
    // by the time a response lands.
    if (_disposed) return;

    if (response.isSuccess && response.data != null) {
      _data = response.data;
      _state = switch (_data!.status) {
        KycVerificationStatus.approved => KycStatusState.approved,
        KycVerificationStatus.rejected => KycStatusState.rejected,
        KycVerificationStatus.correctionRequired =>
          KycStatusState.correctionRequired,
        _ => KycStatusState.polling,
      };

      if (_data!.status.isTerminal) {
        stopPolling();
        if (_data!.status == KycVerificationStatus.approved) {
          await _authState.moveTo(AuthFlowState.approved);
          await _secureStorage.saveKycApproved();
        }
      }
    } else {
      // A transient poll failure must not wipe a verdict already shown.
      _errorMessage = response.message ?? KycStrings.statusFetchFailed;
      if (_data == null) _state = KycStatusState.error;
    }

    _safeNotify();
  }

  /// Mints and stores the access token that finally grants Dashboard
  /// entry. Returns false — leaving the approval intact so the button can
  /// be tapped again — if the call fails.
  Future<bool> completeApproval() async {
    final userId = _authState.context.userId;
    if (userId == null || _kycId.isEmpty) {
      _errorMessage = KycStrings.genericError;
      _safeNotify();
      return false;
    }

    _isGeneratingToken = true;
    _errorMessage = null;
    _safeNotify();

    final response = await _authService.generateAccessToken(
      userId: userId,
      kycId: _kycId,
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

  /// Moves the flow back to `kycPending` so a restart during the
  /// correction lands on the document screen rather than back here.
  Future<void> prepareResubmission() =>
      _authState.moveTo(AuthFlowState.kycPending);

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stopPolling();
    super.dispose();
  }
}
