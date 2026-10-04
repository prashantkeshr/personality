import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/device/device_tier.dart';
import '../../core/logging/app_logger.dart';
import '../../ml/inference/frame_pipeline.dart';

enum CameraLens { front, back }

/// Why the camera is not running, if it is not.
enum CameraProblem { permissionDenied, noCamera, failed }

@immutable
class CameraSourceState {
  const CameraSourceState({
    this.running = false,
    this.starting = false,
    this.problem,
    this.lens,
    this.previewAspectRatio,
  });

  final bool running;
  final bool starting;
  final CameraProblem? problem;
  final CameraLens? lens;
  final double? previewAspectRatio;
}

/// Camera access behind an interface so screens and tests do not depend on
/// the plugin. Frames are delivered to [onFrame] only; nothing is stored.
abstract interface class CameraSource {
  ValueListenable<CameraSourceState> get state;
  Future<List<CameraLens>> lenses();
  Future<void> start(CameraLens lens, CameraPowerMode mode,
      void Function(FrameInput) onFrame);
  Future<void> stop();
  Widget preview();
}

ResolutionPreset _preset(CameraPowerMode m) => switch (m) {
      CameraPowerMode.lowPower => ResolutionPreset.low,
      CameraPowerMode.standard => ResolutionPreset.medium,
      CameraPowerMode.highAccuracy => ResolutionPreset.high,
    };

/// The real camera (camera plugin, CameraX on Android).
class PluginCameraSource implements CameraSource {
  final _state = ValueNotifier(const CameraSourceState());
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  ValueListenable<CameraSourceState> get state => _state;

  Future<List<CameraDescription>> _all() async =>
      _cameras ??= await availableCameras();

  @override
  Future<List<CameraLens>> lenses() async {
    try {
      final all = await _all();
      return {
        for (final c in all)
          if (c.lensDirection == CameraLensDirection.front)
            CameraLens.front
          else if (c.lensDirection == CameraLensDirection.back)
            CameraLens.back,
      }.toList();
    } catch (e, st) {
      AppLogger.error('camera.list', e, st);
      return const [];
    }
  }

  @override
  Future<void> start(CameraLens lens, CameraPowerMode mode,
      void Function(FrameInput) onFrame) async {
    await stop();
    _state.value = CameraSourceState(starting: true, lens: lens);
    try {
      final all = await _all();
      final wanted = lens == CameraLens.front
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      final description =
          all.where((c) => c.lensDirection == wanted).firstOrNull ??
              all.firstOrNull;
      if (description == null) {
        _state.value = const CameraSourceState(problem: CameraProblem.noCamera);
        return;
      }
      final controller = CameraController(
        description,
        _preset(mode),
        enableAudio: false, // never records sound
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      _controller = controller;
      await controller.initialize(); // requests CAMERA permission if needed
      await controller.startImageStream((image) {
        final y = image.planes.first;
        onFrame(FrameInput(
          yPlane: y.bytes,
          width: image.width,
          height: image.height,
          bytesPerRow: y.bytesPerRow,
          rotationDegrees: description.sensorOrientation,
          timestamp: DateTime.now(),
        ));
      });
      _state.value = CameraSourceState(
        running: true,
        lens: description.lensDirection == CameraLensDirection.front
            ? CameraLens.front
            : CameraLens.back,
        previewAspectRatio: controller.value.aspectRatio,
      );
    } on CameraException catch (e, st) {
      AppLogger.error('camera.start', e, st);
      await stop();
      _state.value = CameraSourceState(
        problem: e.code.startsWith('CameraAccessDenied')
            ? CameraProblem.permissionDenied
            : CameraProblem.failed,
      );
    } catch (e, st) {
      AppLogger.error('camera.start', e, st);
      await stop();
      _state.value = const CameraSourceState(problem: CameraProblem.failed);
    }
  }

  @override
  Future<void> stop() async {
    final c = _controller;
    _controller = null;
    if (c != null) {
      try {
        if (c.value.isStreamingImages) await c.stopImageStream();
      } catch (_) {}
      await c.dispose();
    }
    if (_state.value.running || _state.value.starting) {
      _state.value = const CameraSourceState();
    }
  }

  @override
  Widget preview() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return const SizedBox.shrink();
    return CameraPreview(c);
  }
}
