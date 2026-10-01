import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';

/// In-app camera capture for a KYC document: live preview with a
/// front/back switch, capture, then an in-app preview offering
/// Cancel/Retake/Use Photo — entirely owned by this app rather than
/// delegated to the OS camera app.
///
/// Assumes the camera permission has already been granted by the caller
/// (see `FilePickerServiceBase.ensureCameraPermission`); this screen does
/// not request it itself.
class KycCameraCaptureScreen extends StatefulWidget {
  const KycCameraCaptureScreen({super.key});

  /// Pushes this screen and resolves to the chosen photo, or `null` if the
  /// user cancelled without using one.
  static Future<PickedFile?> show(BuildContext context) {
    return Navigator.of(context).push<PickedFile>(
      MaterialPageRoute(builder: (_) => const KycCameraCaptureScreen()),
    );
  }

  @override
  State<KycCameraCaptureScreen> createState() =>
      _KycCameraCaptureScreenState();
}

enum _CameraScreenStatus { loading, ready, error }

class _KycCameraCaptureScreenState extends State<KycCameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  _CameraScreenStatus _status = _CameraScreenStatus.loading;
  String? _errorMessage;

  /// Set once a photo has been captured; its presence is what switches the
  /// screen into preview mode.
  XFile? _captured;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setUpCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    // Release the camera while backgrounded and reacquire it on resume —
    // without this, backgrounding mid-capture reliably crashes on Android.
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed && _captured == null) {
      _initController(_cameras[_cameraIndex]);
    }
  }

  Future<void> _setUpCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _status = _CameraScreenStatus.error;
          _errorMessage = KycStrings.cameraUnavailableMessage;
        });
        return;
      }

      _cameras = cameras;
      // Back camera is the default; fall back to the first camera reported
      // if this device has no back lens (e.g. a front-only device).
      _cameraIndex = cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (_cameraIndex < 0) _cameraIndex = 0;

      await _initController(cameras[_cameraIndex]);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _CameraScreenStatus.error;
        _errorMessage = KycStrings.cameraUnavailableMessage;
      });
    }
  }

  Future<void> _initController(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = controller;

    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() => _status = _CameraScreenStatus.ready);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _CameraScreenStatus.error;
        _errorMessage = KycStrings.cameraUnavailableMessage;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    final controller = _controller;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    setState(() => _status = _CameraScreenStatus.loading);
    await controller?.dispose();
    await _initController(_cameras[_cameraIndex]);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isTakingPicture) return;

    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      setState(() => _captured = file);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(KycStrings.cameraCaptureFailedMessage)),
      );
    }
  }

  void _retake() {
    setState(() => _captured = null);
  }

  Future<void> _usePhoto() async {
    final file = _captured;
    if (file == null) return;

    final length = await File(file.path).length();
    if (!mounted) return;
    Navigator.of(context).pop(
      PickedFile(
        path: file.path,
        fileName: file.name,
        extension: 'jpg',
        sizeBytes: length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: _captured != null ? _buildPreview() : _buildLiveCamera(),
        ),
      ),
    );
  }

  Widget _buildLiveCamera() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: _buildCameraBody()),
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: _RoundIconButton(
            icon: AppIcons.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        if (_cameras.length > 1)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: _RoundIconButton(
              icon: AppIcons.switchCamera,
              onPressed: _status == _CameraScreenStatus.ready
                  ? _switchCamera
                  : null,
            ),
          ),
        if (_status == _CameraScreenStatus.ready)
          Positioned(
            bottom: AppSpacing.xl,
            left: 0,
            right: 0,
            child: Center(
              child: _CaptureButton(onPressed: _capture),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraBody() {
    switch (_status) {
      case _CameraScreenStatus.loading:
        return const CircularProgressIndicator(color: AppColors.white);
      case _CameraScreenStatus.error:
        return Padding(
          padding: AppSpacing.screenPadding,
          child: Text(
            _errorMessage ?? KycStrings.cameraUnavailableMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
          ),
        );
      case _CameraScreenStatus.ready:
        final controller = _controller;
        if (controller == null || !controller.value.isInitialized) {
          return const CircularProgressIndicator(color: AppColors.white);
        }
        return CameraPreview(controller);
    }
  }

  Widget _buildPreview() {
    final captured = _captured!;
    return Column(
      children: [
        Expanded(child: Image.file(File(captured.path), fit: BoxFit.contain)),
        Padding(
          padding: AppSpacing.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _PreviewActionButton(
                  label: StringConstants.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              AppSpacing.gapWSm,
              Expanded(
                child: _PreviewActionButton(
                  label: KycStrings.cameraRetake,
                  onPressed: _retake,
                ),
              ),
              AppSpacing.gapWSm,
              Expanded(
                child: _PreviewActionButton(
                  label: KycStrings.cameraUsePhoto,
                  isPrimary: true,
                  onPressed: _usePhoto,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: AppDimensions.avatarLg,
        height: AppDimensions.avatarLg,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _PreviewActionButton extends StatelessWidget {
  const _PreviewActionButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary : Colors.white12,
        foregroundColor: AppColors.white,
        minimumSize: const Size(0, AppDimensions.buttonHeightMd),
      ),
      child: Text(label),
    );
  }
}
