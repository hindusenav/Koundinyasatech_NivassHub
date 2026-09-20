import 'package:flutter/widgets.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';

/// The document slots KYC can ask for. Which three are actually required
/// depends on the user's role — see [KycDocumentCatalog.forRole].
enum KycDocumentType {
  addressProofOne,
  addressProofTwo,

  /// Owner only — proof the flat is theirs.
  registrationProof,

  /// Tenant only — proof they are the lawful occupant.
  rentalAgreement;

  String get wireValue => name;

  static KycDocumentType? tryFromJson(dynamic value) {
    for (final type in KycDocumentType.values) {
      if (type.wireValue == value) return type;
    }
    return null;
  }
}

/// Presentation metadata for one document card. `const`, no JSON — this is
/// app copy, not server data.
class KycDocumentSpec {
  const KycDocumentSpec({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final KycDocumentType type;
  final String title;
  final String subtitle;
  final IconData icon;
}

/// Maps a role to its ordered, required document set (spec §8 and §9).
///
/// Both roles need the same two address proofs; only the third differs.
/// Keeping that as one lookup means the KYC screen never branches on role
/// itself — it just renders whatever list it is handed.
class KycDocumentCatalog {
  KycDocumentCatalog._();

  static const KycDocumentSpec _addressProofOne = KycDocumentSpec(
    type: KycDocumentType.addressProofOne,
    title: KycStrings.addressProofOneTitle,
    subtitle: KycStrings.addressProofOneSubtitle,
    icon: AppIcons.profile,
  );

  static const KycDocumentSpec _addressProofTwo = KycDocumentSpec(
    type: KycDocumentType.addressProofTwo,
    title: KycStrings.addressProofTwoTitle,
    subtitle: KycStrings.addressProofTwoSubtitle,
    icon: AppIcons.location,
  );

  static const KycDocumentSpec _registrationProof = KycDocumentSpec(
    type: KycDocumentType.registrationProof,
    title: KycStrings.registrationProofTitle,
    subtitle: KycStrings.registrationProofSubtitle,
    icon: AppIcons.society,
  );

  static const KycDocumentSpec _rentalAgreement = KycDocumentSpec(
    type: KycDocumentType.rentalAgreement,
    title: KycStrings.rentalAgreementTitle,
    subtitle: KycStrings.rentalAgreementSubtitle,
    icon: AppIcons.notice,
  );

  /// Always exactly three documents, in display order.
  static List<KycDocumentSpec> forRole(UserRole role) => switch (role) {
    UserRole.owner => const [
      _addressProofOne,
      _addressProofTwo,
      _registrationProof,
    ],
    UserRole.tenant => const [
      _addressProofOne,
      _addressProofTwo,
      _rentalAgreement,
    ],
  };

  static List<KycDocumentType> typesForRole(UserRole role) =>
      forRole(role).map((spec) => spec.type).toList(growable: false);

  /// The role-specific third document — the one the mock verdict ladder
  /// flags on its second attempt.
  static KycDocumentType ownershipProofFor(UserRole role) => switch (role) {
    UserRole.owner => KycDocumentType.registrationProof,
    UserRole.tenant => KycDocumentType.rentalAgreement,
  };

  static KycDocumentSpec specFor(KycDocumentType type) => switch (type) {
    KycDocumentType.addressProofOne => _addressProofOne,
    KycDocumentType.addressProofTwo => _addressProofTwo,
    KycDocumentType.registrationProof => _registrationProof,
    KycDocumentType.rentalAgreement => _rentalAgreement,
  };
}
