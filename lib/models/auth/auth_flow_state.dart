import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';

/// Where the user is in the sign-up → KYC → access pipeline (spec §21).
///
/// Persisted across restarts so a half-finished registration resumes on
/// the right screen rather than dumping the user back at the entry form.
///
/// Note there is deliberately no `rejected` / `correctionRequired` state:
/// a terminal KYC verdict is always re-derivable by calling
/// `getKycStatus(kycId)`, so both map onto [underReview] and the status
/// screen's first poll renders the rejection. A seventh state would
/// duplicate a fact that already has a single source of truth.
enum AuthFlowState {
  /// Nothing known — show the authentication entry screen.
  unauthenticated,

  /// Identifier verified as new; User Details not yet submitted.
  registration,

  /// `createUser` done and a `kycToken` is held; documents not yet sent.
  kycPending,

  /// `submitKyc` done and a `kycId` is held; verdict not yet consumed.
  underReview,

  /// `getKycStatus` returned APPROVED; access token not yet minted.
  approved,

  /// Access token stored — the Dashboard is home.
  authenticated;

  String get wireValue => name;

  static AuthFlowState fromName(String? value) {
    if (value == null) return AuthFlowState.unauthenticated;
    for (final state in AuthFlowState.values) {
      if (state.name == value) return state;
    }
    return AuthFlowState.unauthenticated;
  }
}

/// The facts a resumed flow needs to rebuild its screen's route arguments.
///
/// Non-sensitive by design — ids, enums and display metadata only. The
/// credentials that accompany these (`accessToken`, `kycToken`) live in
/// `SecureStorageService`, matching the existing `accessToken`-secure vs
/// `cachedUserProfile`-local split.
class AuthFlowContext {
  const AuthFlowContext({
    this.identifier,
    this.userId,
    this.fullName,
    this.email,
    this.role,
    this.subBranch,
    this.location,
    this.kycId,
    this.kycAttemptNumber = 0,
  });

  static const AuthFlowContext empty = AuthFlowContext();

  final AuthIdentifier? identifier;
  final String? userId;
  final String? fullName;
  final String? email;
  final UserRole? role;
  final String? subBranch;
  final LocationSelection? location;
  final String? kycId;

  /// Mirrors the mock ledger's attempt counter; 0 before the first submit.
  final int kycAttemptNumber;

  /// Where a mock KYC email should be addressed. Prefers the registered
  /// email, falling back to whatever identifier was used to sign up.
  String get notificationRecipient =>
      email ?? identifier?.normalized ?? 'resident@nivasshub.app';

  String get displayName => fullName ?? 'Resident';

  AuthFlowContext copyWith({
    AuthIdentifier? identifier,
    String? userId,
    String? fullName,
    String? email,
    UserRole? role,
    String? subBranch,
    LocationSelection? location,
    String? kycId,
    int? kycAttemptNumber,
  }) {
    return AuthFlowContext(
      identifier: identifier ?? this.identifier,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      subBranch: subBranch ?? this.subBranch,
      location: location ?? this.location,
      kycId: kycId ?? this.kycId,
      kycAttemptNumber: kycAttemptNumber ?? this.kycAttemptNumber,
    );
  }

  Map<String, dynamic> toJson() => {
    'identifier': identifier?.toJson(),
    'userId': userId,
    'fullName': fullName,
    'email': email,
    'role': role?.wireValue,
    'subBranch': subBranch,
    'location': location?.toStoredJson(),
    'kycId': kycId,
    'kycAttemptNumber': kycAttemptNumber,
  };

  factory AuthFlowContext.fromJson(Map<String, dynamic> json) {
    final rawIdentifier = json['identifier'];
    final rawLocation = json['location'];

    return AuthFlowContext(
      identifier: rawIdentifier is Map
          ? AuthIdentifier.fromJson(Map<String, dynamic>.from(rawIdentifier))
          : null,
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      role: UserRole.tryFromJson(json['role']),
      subBranch: json['subBranch'] as String?,
      location: rawLocation is Map
          ? LocationSelection.fromStoredJson(
              Map<String, dynamic>.from(rawLocation),
            )
          : null,
      kycId: json['kycId'] as String?,
      kycAttemptNumber: json['kycAttemptNumber'] as int? ?? 0,
    );
  }
}
