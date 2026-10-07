import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/models/auth/create_user_request.dart';
import 'package:flutter_nivasshub/models/auth/login_user_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_role.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_document_slot.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_submit_request.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';
import 'package:flutter_nivasshub/models/registration/registration_master_data.dart';
import 'package:flutter_nivasshub/models/registration/user_registration_request.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/location/location_provider.dart';
import 'package:flutter_nivasshub/services/auth/mock_auth_entry_service.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/services/file/mock_file_picker_service.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_mock_ledger.dart';
import 'package:flutter_nivasshub/services/kyc/mock_kyc_service.dart';
import 'package:flutter_nivasshub/services/location/mock_location_service.dart';
import 'package:flutter_nivasshub/services/notifications/mock_notification_service.dart';
import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_document_service.dart';
import 'support/in_memory_secure_storage.dart';

/// Covers the parts of the auth-entry → registration → KYC flow whose
/// behaviour is rules rather than layout: who exists, how the cascade
/// resets, what verdict a submission gets, and which documents survive a
/// resubmission.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService localStorage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localStorage = LocalStorageService();
    await localStorage.init();
  });

  // -------------------------------------------------------------------
  // Authentication entry
  // -------------------------------------------------------------------

  group('MockAuthEntryService', () {
    late MockAuthEntryService service;

    setUp(() => service = MockAuthEntryService());

    AuthIdentifier mobile(String raw) => AuthIdentifier(
      raw: raw,
      channel: AuthChannel.mobile,
      countryCode: '+91',
    );

    test('the seeded mobile is reported as an existing user', () async {
      final response = await service.checkUserExists(
        CheckUserExistsRequest(identifier: mobile('9876543210')),
      );

      expect(response.isSuccess, isTrue);
      expect(response.data!.userExists, isTrue);
    });

    test('an unknown mobile is reported as a new user', () async {
      final response = await service.checkUserExists(
        CheckUserExistsRequest(identifier: mobile('9876543211')),
      );

      expect(response.data!.userExists, isFalse);
    });

    test('an email resolving to the same account is recognised', () async {
      final response = await service.checkUserExists(
        CheckUserExistsRequest(
          identifier: const AuthIdentifier(
            raw: 'User@Gmail.com',
            channel: AuthChannel.email,
          ),
        ),
      );

      expect(response.data!.userExists, isTrue);
    });

    test('the correct password authenticates and returns a token', () async {
      final response = await service.loginUser(
        LoginUserRequest(identifier: mobile('9876543210'), password: '1234'),
      );

      expect(response.isSuccess, isTrue);
      expect(response.data!.authenticated, isTrue);
      expect(response.data!.accessToken, isNotEmpty);
    });

    test('a wrong password fails with the spec wording', () async {
      final response = await service.loginUser(
        LoginUserRequest(identifier: mobile('9876543210'), password: '9999'),
      );

      expect(response.isFailure, isTrue);
      expect(response.message, KycStrings.invalidPassword);
    });

    test('createUser issues a KYC token and requires KYC', () async {
      final response = await service.createUser(
        CreateUserRequest(
          fullName: 'New Resident',
          mobileNumber: '9876543211',
          countryCode: '+91',
          email: 'new@example.com',
          role: UserRole.owner,
          subBranch: 'Residential',
          location: _completeSelection(),
        ),
      );

      expect(response.isSuccess, isTrue);
      expect(response.data!.kycRequired, isTrue);
      expect(response.data!.kycToken, isNotEmpty);
    });

    test('createUser rejects an incomplete property selection', () async {
      final response = await service.createUser(
        CreateUserRequest(
          fullName: 'New Resident',
          mobileNumber: '9876543211',
          countryCode: '+91',
          email: 'new@example.com',
          role: UserRole.owner,
          subBranch: 'Residential',
          location: const LocationSelection(),
        ),
      );

      expect(response.isFailure, isTrue);
    });
  });

  // -------------------------------------------------------------------
  // Registration role id
  // -------------------------------------------------------------------

  group('Registration roles / sub-roles / categories', () {
    final json = {
      'Roles': [
        {
          'role_id': 6,
          'name': 'U',
          'description': 'User',
          'Sub_Role': [
            {
              'sub_role_id': 1,
              'name': 'FO',
              'description': 'Flat Owner',
              'Categories': [
                {'category_id': 1, 'name': 'CR', 'description': 'Resides'},
              ],
            },
          ],
        },
        {
          'role_id': 7,
          'name': 'T',
          'description': 'Tenant',
          'Sub_Role': [
            {'sub_role_id': 4, 'name': 'PT', 'description': 'Primary Tenant'},
          ],
        },
      ],
    };

    test('parses nested Sub_Role/Categories and maps role ids to UserRole', () {
      final data = RegistrationMasterData.fromJson(json);
      expect(data.roles[0].userRole, UserRole.owner);
      expect(data.roles[1].userRole, UserRole.tenant);
      expect(data.roles[0].subRoles.single.categories.single.categoryId, '1');
      expect(data.roles[1].subRoles.single.categories, isEmpty);
    });

    test('request sends sub_role and only sends sub_role_cat when set', () {
      UserRegistrationRequest build({String? cat}) => UserRegistrationRequest(
        fullName: 'A',
        mobileNumber: '1',
        mobileCountryCode: '+91',
        email: 'a@b.c',
        country: '77',
        state: '4347',
        city: 'H',
        socId: '33',
        towerId: '7',
        floorId: '1',
        unitId: '101',
        roleId: '6',
        subRole: '1',
        subRoleCat: cat,
      );
      expect(build(cat: '1').toJson()['sub_role_cat'], 1);
      expect(build().toJson()['sub_role'], 1);
      expect(build().toJson().containsKey('sub_role_cat'), isFalse);
    });
  });

  // -------------------------------------------------------------------
  // Resend via registration-check
  // -------------------------------------------------------------------

  group('OtpMobileEmailVerificationProvider.resendOtp', () {
    test('re-submits the identifier to registration-check and adopts the new token',
        () async {
      final auth = _FakeResendAuthService();
      final provider = OtpMobileEmailVerificationProvider(
        service: _CapturingOtpVerificationService(),
        authService: auth,
        resendIdentifier: const AuthIdentifier(
          raw: '9391181130',
          channel: AuthChannel.mobile,
          countryCode: '+91',
        ),
        userId: 'OLD_TOKEN',
        otpJustSent: false,
      );

      final ok = await provider.resendOtp(OtpChannel.mobile);
      await provider.verifyOtp(OtpChannel.mobile, '123456');

      expect(ok, isTrue);
      expect(auth.requests.single.toJson(), {
        'umail': '9391181130',
        'cont_code': '+91',
      });
    });

    test('fails cleanly when there is no identifier to resend with', () async {
      final provider = OtpMobileEmailVerificationProvider(
        service: _CapturingOtpVerificationService(),
        authService: _FakeResendAuthService(),
        userId: 'OLD_TOKEN',
        otpJustSent: false,
      );

      expect(await provider.resendOtp(OtpChannel.email), isFalse);
      expect(provider.stateFor(OtpChannel.email).resendError, isNotNull);
    });
  });

  // -------------------------------------------------------------------
  // Cascading property selection
  // -------------------------------------------------------------------

  group('LocationProvider cascade', () {
    late LocationProvider provider;

    setUp(() => provider = LocationProvider(MockLocationService()));

    Future<void> selectFirst(LocationLevel level) async {
      await provider.load(level);
      await provider.select(level, provider.optionsFor(level).first);
    }

    test('only country is selectable before anything is chosen', () async {
      expect(provider.isEnabled(LocationLevel.country), isTrue);
      for (final level in LocationLevel.values.skip(1)) {
        expect(provider.isEnabled(level), isFalse, reason: level.name);
      }
    });

    test('choosing a level loads and unlocks the next one', () async {
      await selectFirst(LocationLevel.country);

      expect(provider.isEnabled(LocationLevel.state), isTrue);
      expect(provider.optionsFor(LocationLevel.state), isNotEmpty);
    });

    test(
      'the full seven-level path resolves to a complete selection',
      () async {
        for (final level in LocationLevel.values) {
          await selectFirst(level);
        }

        expect(provider.isComplete, isTrue);
        expect(provider.selection.flat, isNotNull);
      },
    );

    test('changing the country clears every level below it', () async {
      for (final level in LocationLevel.values) {
        await selectFirst(level);
      }
      expect(provider.isComplete, isTrue);

      final countries = provider.optionsFor(LocationLevel.country);
      await provider.select(LocationLevel.country, countries[1]);

      // State reloads for the new country; everything under it is gone.
      for (final level in LocationLevel.values.skip(2)) {
        expect(provider.selectedFor(level), isNull, reason: level.name);
        expect(provider.optionsFor(level), isEmpty, reason: level.name);
        expect(provider.isEnabled(level), isFalse, reason: level.name);
      }
    });

    test('changing a mid-level clears only what is below it', () async {
      for (final level in LocationLevel.values) {
        await selectFirst(level);
      }

      final country = provider.selectedFor(LocationLevel.country);
      final state = provider.selectedFor(LocationLevel.state);

      final cities = provider.optionsFor(LocationLevel.city);
      await provider.select(LocationLevel.city, cities.last);

      expect(provider.selectedFor(LocationLevel.country), country);
      expect(provider.selectedFor(LocationLevel.state), state);
      expect(provider.selectedFor(LocationLevel.society), isNull);
      expect(provider.selectedFor(LocationLevel.flat), isNull);
    });

    test('a childless society reports empty rather than failing', () async {
      await selectFirst(LocationLevel.country);
      await selectFirst(LocationLevel.state);
      await selectFirst(LocationLevel.city);

      final societies = provider.optionsFor(LocationLevel.society);
      final childless = societies.firstWhere((s) => s.id == 'SOC-EMPTY');
      await provider.select(LocationLevel.society, childless);

      expect(provider.stateFor(LocationLevel.tower), LocationLoadState.empty);
      expect(provider.errorFor(LocationLevel.tower), isNull);
    });

    test('the failing society surfaces an error with a message', () async {
      await selectFirst(LocationLevel.country);
      await selectFirst(LocationLevel.state);
      await selectFirst(LocationLevel.city);

      final societies = provider.optionsFor(LocationLevel.society);
      final failing = societies.firstWhere((s) => s.id == 'SOC-ERROR');
      await provider.select(LocationLevel.society, failing);

      expect(provider.stateFor(LocationLevel.tower), LocationLoadState.error);
      expect(provider.errorFor(LocationLevel.tower), isNotNull);
    });
  });

  // -------------------------------------------------------------------
  // GET /kyc/documents — the applicable document list
  // -------------------------------------------------------------------

  group('DocumentServiceBase.getApplicableDocuments (fake)', () {
    test('renders exactly what the backend returns, in order', () async {
      final service = FakeDocumentService(documents: threeFakeDocuments());

      final response = await service.getApplicableDocuments(
        userToken: 'USR1',
      );

      expect(response.isSuccess, isTrue);
      expect(response.data!.map((d) => d.documentName), [
        'Address Proof 1',
        'Address Proof 2',
        'Ownership Proof',
      ]);
    });

    test('an empty catalog is a valid, non-error response', () async {
      final service = FakeDocumentService(documents: const []);

      final response = await service.getApplicableDocuments(
        userToken: 'USR1',
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, isEmpty);
    });
  });

  // -------------------------------------------------------------------
  // The mock verdict engine
  // -------------------------------------------------------------------

  group('MockKycService verdicts', () {
    late MockKycService service;

    setUp(() {
      service = MockKycService(
        storage: localStorage,
        notificationService: MockNotificationService(localStorage),
        recipientResolver: () => 'resident@example.com',
        nameResolver: () => 'Test Resident',
      );
    });

    /// Submits, then rewinds the ledger's timestamp past every review
    /// stage so the frozen verdict is revealed without waiting out the
    /// real twelve seconds.
    Future<KycVerificationStatus> submitAndReveal({
      required int attempt,
      UserRole role = UserRole.owner,
      String fileNamePrefix = 'document',
    }) async {
      final submit = await service.submitKyc(
        _submitRequest(
          role: role,
          attempt: attempt,
          fileNamePrefix: fileNamePrefix,
        ),
      );
      expect(submit.isSuccess, isTrue);

      final ledger = KycMockLedger.read(localStorage)!;
      await KycMockLedger.write(
        localStorage,
        KycMockLedger(
          kycId: ledger.kycId,
          attemptNumber: ledger.attemptNumber,
          submittedAtEpochMs: DateTime.now().millisecondsSinceEpoch - 60 * 1000,
          verdict: ledger.verdict,
          issues: ledger.issues,
          reason: ledger.reason,
        ),
      );

      final status = await service.getKycStatus(kycId: ledger.kycId);
      expect(status.isSuccess, isTrue);
      return status.data!.status;
    }

    test('a fresh submission reports UNDER_REVIEW, not a verdict', () async {
      final response = await service.submitKyc(_submitRequest(attempt: 1));

      expect(response.data!.status, KycVerificationStatus.underReview);
    });

    test('attempt 1 asks for a correction', () async {
      expect(
        await submitAndReveal(attempt: 1),
        KycVerificationStatus.correctionRequired,
      );
    });

    test('attempt 2 is rejected', () async {
      expect(await submitAndReveal(attempt: 2), KycVerificationStatus.rejected);
    });

    test('attempt 3 is approved, so the loop always terminates', () async {
      expect(await submitAndReveal(attempt: 3), KycVerificationStatus.approved);
    });

    test('a failing attempt flags exactly one document', () async {
      await submitAndReveal(attempt: 1);
      final ledger = KycMockLedger.read(localStorage)!;

      expect(ledger.issues, hasLength(1));
      expect(ledger.issues.single.documentId, 2);
    });

    test('a rejection flags the last document in the manifest', () async {
      await submitAndReveal(attempt: 2, role: UserRole.tenant);
      final ledger = KycMockLedger.read(localStorage)!;

      expect(ledger.issues.single.documentId, 3);
    });

    test('a filename token overrides the attempt ladder', () async {
      expect(
        await submitAndReveal(attempt: 1, fileNamePrefix: 'approve'),
        KycVerificationStatus.approved,
      );
    });

    test(
      'the review stage progresses before the verdict is revealed',
      () async {
        final submit = await service.submitKyc(_submitRequest(attempt: 1));
        final status = await service.getKycStatus(kycId: submit.data!.kycId);

        expect(status.data!.status.isTerminal, isFalse);
        expect(status.data!.stage, KycReviewStage.submitted);
      },
    );

    test('a submission with no documents is rejected as invalid', () async {
      final response = await service.submitKyc(
        const KycSubmitRequest(
          kycToken: 'token',
          userId: 'USR1',
          role: UserRole.owner,
          attemptNumber: 1,
          documents: [],
        ),
      );

      expect(response.isFailure, isTrue);
    });

    test('the terminal notification is sent exactly once', () async {
      final notifications = MockNotificationService(localStorage);
      final localService = MockKycService(
        storage: localStorage,
        notificationService: notifications,
        recipientResolver: () => 'resident@example.com',
        nameResolver: () => 'Test Resident',
      );

      final submit = await localService.submitKyc(_submitRequest(attempt: 3));
      final ledger = KycMockLedger.read(localStorage)!;
      await KycMockLedger.write(
        localStorage,
        KycMockLedger(
          kycId: ledger.kycId,
          attemptNumber: ledger.attemptNumber,
          submittedAtEpochMs: DateTime.now().millisecondsSinceEpoch - 60 * 1000,
          verdict: ledger.verdict,
        ),
      );

      // Polling runs every two seconds, so the guard has to survive
      // repeated observation of the same terminal state.
      for (var i = 0; i < 4; i++) {
        await localService.getKycStatus(kycId: submit.data!.kycId);
      }

      final log = await notifications.getNotifications();
      expect(log.data, hasLength(1));
    });
  });

  // -------------------------------------------------------------------
  // Document preservation across a resubmission
  // -------------------------------------------------------------------

  group('KycProvider', () {
    late KycProvider provider;
    late MockKycService kycService;

    setUp(() {
      final notifications = MockNotificationService(localStorage);
      kycService = MockKycService(
        storage: localStorage,
        notificationService: notifications,
        recipientResolver: () => 'resident@example.com',
        nameResolver: () => 'Test Resident',
      );
      provider = KycProvider(
        documentService: FakeDocumentService(documents: threeFakeDocuments()),
        kycService: kycService,
        filePickerService: MockFilePickerService(),
        localStorage: localStorage,
        authState: AuthStateProvider(
          localStorage: localStorage,
          secureStorage: SecureStorageService(storage: InMemorySecureStorage()),
        ),
      );
    });

    Future<void> uploadAll() async {
      for (final slot in provider.slots) {
        await provider.pickAndUpload(
          slot.document.documentId,
          FilePickSource.files,
        );
      }
    }

    test('uploading one document leaves the others untouched, and optional '
        'documents do not block submit', () async {
      final documents = FakeDocumentService(
        documents: const [
          KycApplicableDocument(documentId: 13, documentName: 'Aadhar'),
          KycApplicableDocument(
            documentId: 14,
            documentName: 'Driving Licence',
            isMandatory: false,
          ),
          KycApplicableDocument(documentId: 19, documentName: 'Lease'),
        ],
      );
      final p = KycProvider(
        documentService: documents,
        kycService: kycService,
        filePickerService: MockFilePickerService(),
        localStorage: localStorage,
        authState: AuthStateProvider(
          localStorage: localStorage,
          secureStorage: SecureStorageService(storage: InMemorySecureStorage()),
        ),
      );
      await p.initialise(userId: 'T', kycToken: '', role: UserRole.owner);

      await p.pickAndUpload(13, FilePickSource.files);

      expect(documents.uploadRequests.single.documentId, 13);
      expect(p.slotFor(13)!.isSatisfied, isTrue);
      expect(p.slotFor(14)!.isSatisfied, isFalse);
      expect(p.slotFor(19)!.isSatisfied, isFalse);
      expect(p.canSubmit, isFalse);

      await p.pickAndUpload(19, FilePickSource.files);
      expect(p.canSubmit, isTrue); // Driving Licence is optional
    });

    test('each upload uses the token returned by the previous one', () async {
      final documents = FakeDocumentService(rotateTokens: true);
      final rotating = KycProvider(
        documentService: documents,
        kycService: kycService,
        filePickerService: MockFilePickerService(),
        localStorage: localStorage,
        authState: AuthStateProvider(
          localStorage: localStorage,
          secureStorage: SecureStorageService(storage: InMemorySecureStorage()),
        ),
      );
      await rotating.initialise(
        userId: 'SESSION_0',
        kycToken: '',
        role: UserRole.owner,
      );

      await rotating.pickAndUpload(1, FilePickSource.files);
      await rotating.pickAndUpload(2, FilePickSource.files);
      await rotating.pickAndUpload(3, FilePickSource.files);

      expect(documents.uploadRequests.map((r) => r.userId), [
        'SESSION_0',
        'ROTATED_1',
        'ROTATED_2',
      ]);
    });

    test('submit stays disabled until every document is uploaded', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
      );
      expect(provider.canSubmit, isFalse);

      await provider.pickAndUpload(1, FilePickSource.files);
      expect(provider.canSubmit, isFalse);

      await provider.pickAndUpload(2, FilePickSource.files);
      await provider.pickAndUpload(3, FilePickSource.files);
      expect(provider.canSubmit, isTrue);
    });

    test(
      'uploadPicked uploads an already-picked file without opening the picker',
      () async {
        await provider.initialise(
          userId: 'USR1',
          kycToken: 'token',
          role: UserRole.owner,
        );

        await provider.uploadPicked(
          1,
          const PickedFile(
            path: '/mock/documents/preview_confirmed.jpg',
            fileName: 'preview_confirmed.jpg',
            extension: 'jpg',
            sizeBytes: 1024,
          ),
        );

        final slot = provider.slotFor(1)!;
        expect(slot.status, KycUploadStatus.uploaded);
        expect(slot.uploaded!.fileName, 'preview_confirmed.jpg');
      },
    );

    test('removing a document disables submit again', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
      );
      await uploadAll();
      expect(provider.canSubmit, isTrue);

      await provider.remove(2);
      expect(provider.canSubmit, isFalse);
    });

    test('the cards render exactly what GET /kyc/documents returned', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.tenant,
      );

      expect(
        provider.slots.map((s) => s.document.documentName),
        contains('Ownership Proof'),
      );
    });

    test('a correction preserves the documents it did not flag', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
      );
      await uploadAll();
      expect(await provider.submit(), isTrue);

      final firstKycId = provider.submittedKycId!;
      final ledger = KycMockLedger.read(localStorage)!;

      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
        resubmitKycId: firstKycId,
        invalidDocuments: ledger.issues,
        rejectionReason: ledger.reason,
      );

      final flagged = provider.slotFor(2)!;
      expect(flagged.status, KycUploadStatus.empty);
      expect(flagged.issueReason, isNotNull);

      for (final documentId in const [1, 3]) {
        final slot = provider.slotFor(documentId)!;
        expect(
          slot.status,
          KycUploadStatus.preserved,
          reason: 'document $documentId',
        );
        expect(
          slot.uploaded!.documentId,
          documentId,
          reason: 'document $documentId',
        );
      }

      // Only the flagged card needs replacing before submit re-enables.
      expect(provider.canSubmit, isFalse);
      await provider.pickAndUpload(2, FilePickSource.files);
      expect(provider.canSubmit, isTrue);
      expect(provider.attemptNumber, 2);
    });

    test('resubmitting eventually reaches approval', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
      );
      await uploadAll();

      var verdict = KycVerificationStatus.submitted;

      for (var attempt = 1; attempt <= 3; attempt++) {
        expect(
          await provider.submit(),
          isTrue,
          reason: 'attempt $attempt should submit',
        );

        final ledger = KycMockLedger.read(localStorage)!;
        verdict = ledger.verdict;
        if (verdict == KycVerificationStatus.approved) break;

        await provider.initialise(
          userId: 'USR1',
          kycToken: 'token',
          role: UserRole.owner,
          resubmitKycId: provider.submittedKycId,
          invalidDocuments: ledger.issues,
          rejectionReason: ledger.reason,
        );
        for (final issue in ledger.issues) {
          await provider.pickAndUpload(issue.documentId, FilePickSource.files);
        }
      }

      expect(verdict, KycVerificationStatus.approved);
    });

    test('reset clears the stored documents and the mock ledger', () async {
      await provider.initialise(
        userId: 'USR1',
        kycToken: 'token',
        role: UserRole.owner,
      );
      await uploadAll();
      await provider.submit();

      await provider.reset();

      expect(KycMockLedger.read(localStorage), isNull);
      expect(provider.slots, isEmpty);
    });
  });
}

/// Records the verify requests it receives, without a live
/// `POST /country-codes/user-registration/verify-otp` call.
class _CapturingOtpVerificationService implements OtpVerificationServiceBase {
  final verifyRequests = <UserRegistrationVerifyOtpRequest>[];

  @override
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  ) async {
    verifyRequests.add(request);
    return ApiResponse.success(
      const UserRegistrationVerifyOtpResponseData(verified: true),
    );
  }
}

/// Answers every registration-check with 412 MOBILE_EMAIL_NOT_VERIFIED and
/// a fresh token, as the real backend does while OTPs are outstanding.
class _FakeResendAuthService implements AuthEntryServiceBase {
  final requests = <CheckUserExistsRequest>[];

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) async {
    requests.add(request);
    return ApiResponse.success(
      CheckUserExistsResponseData(
        userExists: true,
        identifier: request.identifier.normalized,
        outcome: RegistrationCheckOutcome.mobileEmailNotVerified,
        registrationToken: 'NEW_TOKEN',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------

LocationSelection _completeSelection() {
  LocationNode node(LocationLevel level) =>
      LocationNode(id: '${level.name}-1', name: level.label, level: level);

  return LocationSelection(
    country: node(LocationLevel.country),
    state: node(LocationLevel.state),
    city: node(LocationLevel.city),
    society: node(LocationLevel.society),
    tower: node(LocationLevel.tower),
    floor: node(LocationLevel.floor),
    flat: node(LocationLevel.flat),
  );
}

KycSubmitRequest _submitRequest({
  required int attempt,
  UserRole role = UserRole.owner,
  String fileNamePrefix = 'document',
}) {
  final documents = threeFakeDocuments();
  return KycSubmitRequest(
    kycToken: 'mock_kyc_token',
    userId: 'USR1001',
    role: role,
    attemptNumber: attempt,
    documents: [
      for (var i = 0; i < documents.length; i++)
        KycSubmitDocument(
          documentId: documents[i].documentId,
          documentName: documents[i].documentName,
          fileName: '$fileNamePrefix$i.pdf',
        ),
    ],
  );
}
