import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/camera/camera_strings.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/models/camera/app_camera_config.dart';
import 'package:flutter_nivasshub/screens/camera/app_camera.dart';
import 'package:flutter_nivasshub/services/file/mock_file_picker_service.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Camera permission is off; requesting it either stays denied or is
/// permanently denied, as configured.
class _DeniedPicker extends MockFilePickerService {
  _DeniedPicker({required this.permanent});

  final bool permanent;
  bool openedSettings = false;

  @override
  Future<bool> hasCameraPermission() async => false;

  @override
  Future<ApiException?> ensureCameraPermission() async => ApiException(
    message: permanent
        ? KycStrings.cameraPermanentlyDeniedMessage
        : 'Camera permission is required to take a photo.',
    type: ApiExceptionType.forbidden,
  );

  @override
  Future<void> openSettings() async => openedSettings = true;
}

Widget _host(FilePickerServiceBase picker) {
  return Provider<FilePickerServiceBase>.value(
    value: picker,
    child: const MaterialApp(
      home: AppCameraScreen(config: AppCameraConfig.document),
    ),
  );
}

void main() {
  testWidgets('shows the branded permission screen when access is off', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_DeniedPicker(permanent: false)));
    await tester.pumpAndSettle();

    expect(find.text(CameraStrings.permissionTitle), findsOneWidget);
    expect(find.text(CameraStrings.allowAccess), findsOneWidget);
    expect(find.text(CameraStrings.notNow), findsOneWidget);
  });

  testWidgets('permanent denial switches to Open Settings', (tester) async {
    final picker = _DeniedPicker(permanent: true);
    await tester.pumpWidget(_host(picker));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CameraStrings.allowAccess));
    await tester.pumpAndSettle();

    expect(find.text(CameraStrings.permissionDeniedTitle), findsOneWidget);
    expect(find.text(CameraStrings.openSettings), findsOneWidget);

    await tester.tap(find.text(CameraStrings.openSettings));
    expect(picker.openedSettings, isTrue);
  });
}
