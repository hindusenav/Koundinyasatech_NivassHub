import 'package:flutter_nivasshub/constants/kyc/kyc_config.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';

/// Returns a synthetic file without touching a platform channel, so the
/// whole KYC flow — pick, upload, submit, resubmit — can be driven from a
/// widget test or on a device where the picker is unavailable.
///
/// Not wired up by default; `main.dart` builds [FilePickerService].
class MockFilePickerService implements FilePickerServiceBase {
  MockFilePickerService({
    this.fileName = 'address_proof.pdf',
    this.sizeBytes = 240 * 1024,
  });

  final String fileName;
  final int sizeBytes;

  int _counter = 0;

  @override
  Future<ApiResponse<PickedFile?>> pick({
    required FilePickSource source,
    List<String> allowedExtensions = KycConfig.allowedKycExtensions,
    int maxSizeBytes = KycConfig.maxKycFileSizeBytes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _counter++;

    final extension = source == FilePickSource.files ? 'pdf' : 'jpg';
    final name = source == FilePickSource.files
        ? fileName
        : 'photo_$_counter.$extension';

    return ApiResponse.success(
      PickedFile(
        path: '/mock/documents/$name',
        fileName: name,
        extension: extension,
        sizeBytes: sizeBytes,
      ),
    );
  }
}
