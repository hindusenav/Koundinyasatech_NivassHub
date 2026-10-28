import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/camera/camera_strings.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/camera/app_camera_config.dart';
import 'package:flutter_nivasshub/models/kyc/picked_file.dart';
import 'package:flutter_nivasshub/services/file/file_picker_service_base.dart';
import 'package:flutter_nivasshub/widgets/camera/camera_info_view.dart';
import 'package:flutter_nivasshub/widgets/camera/camera_widgets.dart';
import 'package:provider/provider.dart';

/// The one camera used everywhere in the app (KYC documents, pet photos, …).
///
/// Handles the whole journey itself: permission explainer, live preview,
/// capture, review (retake / use photo) and the error states, so every
/// caller gets the same look and the same permission behaviour.
class AppCamera {
  AppCamera._();

  /// Opens the camera and resolves to the photo the user chose to use, or
  /// `null` when they backed out.
  static Future<PickedFile?> capture(
    BuildContext context, {
    AppCameraConfig config = AppCameraConfig.photo,
  }) {
    return Navigator.of(context).push<PickedFile>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AppCameraScreen(config: config),
      ),
    );
  }
}

enum _Stage { checking, needsPermission, loading, ready, error }

class AppCameraScreen extends StatefulWidget {
  const AppCameraScreen({super.key, required this.config});

  final AppCameraConfig config;

  @override
  State<AppCameraScreen> createState() => _AppCameraScreenState();
}

class _AppCameraScreenState extends State<AppCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  CameraDescription? _selected;
  _Stage _stage = _Stage.checking;
  bool _permanentlyDenied = false;
  bool _capturing = false;
  FlashMode _flash = FlashMode.off;
  XFile? _captured;
  Offset? _focusPoint;

  FilePickerServiceBase get _filePicker => context.read<FilePickerServiceBase>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResumed();
      return;
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    // Release the camera while backgrounded — leaving it open reliably
    // crashes on Android.
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller = null;
      controller.dispose();
      if (mounted && _captured == null) {
        setState(() => _stage = _Stage.loading);
      }
    }
  }

  void _onResumed() {
    if (!mounted) return;
    if (_stage == _Stage.needsPermission) {
      // The user may have just granted access from system Settings.
      _start();
      return;
    }
    final selected = _selected;
    if (_controller == null &&
        selected != null &&
        _captured == null &&
        (_stage == _Stage.loading || _stage == _Stage.ready)) {
      _initController(selected);
    }
  }

  // ---------------------------------------------------------------- setup

  Future<void> _start() async {
    final granted = await _filePicker.hasCameraPermission();
    if (!mounted) return;
    if (granted) {
      await _setUpCamera();
    } else {
      setState(() => _stage = _Stage.needsPermission);
    }
  }

  Future<void> _requestPermission() async {
    final error = await _filePicker.ensureCameraPermission();
    if (!mounted) return;
    if (error == null) {
      await _setUpCamera();
      return;
    }
    setState(() {
      _stage = _Stage.needsPermission;
      _permanentlyDenied = error.message == KycStrings.cameraPermanentlyDeniedMessage;
    });
  }

  Future<void> _setUpCamera() async {
    if (mounted) setState(() => _stage = _Stage.loading);
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      if (cameras.isEmpty) {
        setState(() => _stage = _Stage.error);
        return;
      }
      _cameras = cameras;
      final preferred = widget.config.startWithFrontCamera
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      final initial =
          _cameraFor(preferred) ??
          _cameraFor(CameraLensDirection.back) ??
          _cameraFor(CameraLensDirection.front) ??
          cameras.first;
      await _initController(initial);
    } catch (_) {
      if (mounted) setState(() => _stage = _Stage.error);
    }
  }

  CameraDescription? _cameraFor(CameraLensDirection direction) {
    for (final c in _cameras) {
      if (c.lensDirection == direction) return c;
    }
    return null;
  }

  bool get _canSwitch =>
      _cameraFor(CameraLensDirection.front) != null &&
      _cameraFor(CameraLensDirection.back) != null;

  bool get _isFront => _selected?.lensDirection == CameraLensDirection.front;

  Future<void> _initController(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = controller;
    _selected = description;

    try {
      await controller.initialize();
      if (!mounted || _controller != controller) {
        await controller.dispose();
        return;
      }
      await _applyFlash(controller, _flash);
      if (!mounted || _controller != controller) return;
      setState(() => _stage = _Stage.ready);
    } catch (_) {
      if (!mounted || _controller != controller) return;
      setState(() => _stage = _Stage.error);
    }
  }

  Future<void> _applyFlash(CameraController controller, FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } catch (_) {
      // Front cameras and some devices have no flash; ignore.
    }
  }

  // -------------------------------------------------------------- actions

  Future<void> _switchCamera() async {
    if (!_canSwitch || _stage != _Stage.ready) return;
    final target = _isFront
        ? _cameraFor(CameraLensDirection.back)
        : _cameraFor(CameraLensDirection.front);
    if (target == null) return;

    final old = _controller;
    _controller = null;
    setState(() {
      _stage = _Stage.loading;
      _focusPoint = null;
    });
    await old?.dispose();
    if (!mounted) return;
    await _initController(target);
  }

  Future<void> _cycleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final next = switch (_flash) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };
    await _applyFlash(controller, next);
    if (mounted) setState(() => _flash = next);
  }

  Future<void> _focusAt(TapUpDetails details, Size size) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final point = Offset(
      (details.localPosition.dx / size.width).clamp(0.0, 1.0),
      (details.localPosition.dy / size.height).clamp(0.0, 1.0),
    );
    setState(() => _focusPoint = details.localPosition);
    try {
      await controller.setFocusPoint(point);
      await controller.setExposurePoint(point);
    } catch (_) {
      // Not every device supports point focus.
    }
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _focusPoint = null);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _capturing) {
      return;
    }
    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      try {
        await controller.pausePreview();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _captured = file;
        _capturing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _capturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(CameraStrings.captureFailed)),
      );
    }
  }

  Future<void> _retake() async {
    final controller = _controller;
    setState(() => _captured = null);
    if (controller != null && controller.value.isInitialized) {
      try {
        await controller.resumePreview();
      } catch (_) {}
      return;
    }
    // The camera was released while the app was in the background.
    final selected = _selected;
    if (selected != null) {
      setState(() => _stage = _Stage.loading);
      await _initController(selected);
    }
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

  void _close() => Navigator.of(context).maybePop();

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: switch (_stage) {
          _Stage.checking => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          _Stage.needsPermission => _buildPermission(),
          _Stage.error => CameraInfoView(
            icon: CameraIcons.unavailable,
            title: CameraStrings.unavailableTitle,
            body: CameraStrings.unavailableBody,
            primaryLabel: CameraStrings.tryAgain,
            primaryIcon: AppIcons.refresh,
            onPrimary: _setUpCamera,
            secondaryLabel: CameraStrings.notNow,
            onSecondary: _close,
          ),
          _ => _captured != null ? _buildReview() : _buildLive(),
        },
      ),
    );
  }

  Widget _buildPermission() {
    final denied = _permanentlyDenied;
    return CameraInfoView(
      icon: CameraIcons.camera,
      title: denied
          ? CameraStrings.permissionDeniedTitle
          : CameraStrings.permissionTitle,
      body: denied
          ? CameraStrings.permissionDeniedBody
          : CameraStrings.permissionBody,
      points: denied
          ? const []
          : const [
              CameraInfoPoint(
                CameraIcons.capture,
                CameraStrings.permissionPointCapture,
              ),
              CameraInfoPoint(
                CameraIcons.privacy,
                CameraStrings.permissionPointPrivate,
              ),
              CameraInfoPoint(
                CameraIcons.control,
                CameraStrings.permissionPointControl,
              ),
            ],
      primaryLabel: denied
          ? CameraStrings.openSettings
          : CameraStrings.allowAccess,
      primaryIcon: denied ? AppIcons.settings : CameraIcons.camera,
      onPrimary: denied ? _filePicker.openSettings : _requestPermission,
      secondaryLabel: CameraStrings.notNow,
      onSecondary: _close,
    );
  }

  Widget _buildLive() {
    final ready = _stage == _Stage.ready;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (ready) _buildPreview() else _buildLoading(),
        if (ready && widget.config.guide == CameraGuide.document)
          const CameraDocumentGuide(),
        const _Scrim(top: true),
        const _Scrim(top: false),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    CameraGlassButton(
                      icon: AppIcons.close,
                      tooltip: 'Close',
                      onPressed: _close,
                    ),
                    Expanded(
                      child: Text(
                        widget.config.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              const Spacer(),
              if (ready) CameraHintPill(text: widget.config.hint),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 44,
                      child: ready && !_isFront
                          ? CameraGlassButton(
                              icon: switch (_flash) {
                                FlashMode.off => Icons.flash_off_rounded,
                                FlashMode.auto => Icons.flash_auto_rounded,
                                _ => Icons.flash_on_rounded,
                              },
                              tooltip: 'Flash',
                              active: _flash != FlashMode.off,
                              onPressed: _cycleFlash,
                            )
                          : null,
                    ),
                    CameraShutterButton(
                      busy: _capturing,
                      onPressed: ready ? _capture : () {},
                    ),
                    SizedBox(
                      width: 44,
                      child: _canSwitch
                          ? CameraGlassButton(
                              icon: AppIcons.switchCamera,
                              tooltip: 'Switch camera',
                              onPressed: ready ? _switchCamera : null,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() => const Center(
    child: CircularProgressIndicator(color: AppColors.primary),
  );

  Widget _buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return _buildLoading();
    }
    final previewSize = controller.value.previewSize;
    final portrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        Widget preview = CameraPreview(controller);
        if (previewSize != null) {
          // Cover-fit so the preview fills the screen without stretching.
          preview = ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: portrait ? previewSize.height : previewSize.width,
                height: portrait ? previewSize.width : previewSize.height,
                child: preview,
              ),
            ),
          );
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => _focusAt(d, size),
          child: Stack(
            fit: StackFit.expand,
            children: [
              preview,
              if (_focusPoint != null)
                Positioned(
                  left: _focusPoint!.dx - 32,
                  top: _focusPoint!.dy - 32,
                  child: const _FocusRing(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReview() {
    final captured = _captured!;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(File(captured.path), fit: BoxFit.cover),
        const _Scrim(top: true),
        const _Scrim(top: false),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    CameraGlassButton(
                      icon: AppIcons.close,
                      tooltip: 'Close',
                      onPressed: _close,
                    ),
                    Expanded(
                      child: Text(
                        CameraStrings.reviewTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              const Spacer(),
              const CameraHintPill(text: CameraStrings.reviewHint),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: CameraActionButton(
                        label: CameraStrings.retake,
                        icon: AppIcons.refresh,
                        onPressed: _retake,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CameraActionButton(
                        label: CameraStrings.usePhoto,
                        icon: AppIcons.check,
                        primary: true,
                        onPressed: _usePhoto,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Soft black gradient at the top/bottom edge so controls stay legible over
/// any camera image.
class _Scrim extends StatelessWidget {
  const _Scrim({required this.top});

  final bool top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: top ? 0 : null,
      bottom: top ? null : 0,
      height: top ? 150 : 260,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: top ? Alignment.topCenter : Alignment.bottomCenter,
              end: top ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [
                AppColors.black.withValues(alpha: top ? 0.6 : 0.75),
                AppColors.black.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusRing extends StatelessWidget {
  const _FocusRing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight, width: 2),
      ),
    );
  }
}
