import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/features/camera/camera_source.dart';
import 'package:personality/ml/face/face_estimator.dart';
import 'package:personality/ml/inference/frame_pipeline.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

/// A camera that delivers synthetic frames on demand.
class FakeCamera implements CameraSource {
  FakeCamera({this.deny = false});
  final bool deny;
  final _state = ValueNotifier(const CameraSourceState());
  void Function(FrameInput)? _onFrame;
  CameraPowerMode? startedWith;
  int stops = 0;

  @override
  ValueListenable<CameraSourceState> get state => _state;
  @override
  Future<List<CameraLens>> lenses() async => [CameraLens.back, CameraLens.front];
  @override
  Future<void> start(CameraLens lens, CameraPowerMode mode,
      void Function(FrameInput) onFrame) async {
    startedWith = mode;
    if (deny) {
      _state.value =
          const CameraSourceState(problem: CameraProblem.permissionDenied);
      return;
    }
    _onFrame = onFrame;
    _state.value =
        CameraSourceState(running: true, lens: lens, previewAspectRatio: 4 / 3);
  }

  @override
  Future<void> stop() async {
    stops++;
    _onFrame = null;
    _state.value = const CameraSourceState();
  }

  @override
  Widget preview() => const ColoredBox(color: Colors.black);

  /// Sends a frame with the given brightness (checkerboard a/b).
  /// Frames are luma-only; tests pair this with a scripted estimator.
  Future<void> emit(int a, int b, DateTime at) async {
    final y = Uint8List(64 * 48);
    for (var i = 0; i < y.length; i++) {
      y[i] = (i + i ~/ 64).isEven ? a : b;
    }
    _onFrame?.call(FrameInput(
        yPlane: y,
        width: 64,
        height: 48,
        bytesPerRow: 64,
        rotationDegrees: 90,
        timestamp: at));
  }
}

class FixedProbe implements DeviceCapabilityProbe {
  const FixedProbe(this.specs);
  final DeviceSpecs specs;
  @override
  Future<DeviceSpecs> probe() async => specs;
}


/// Returns scripted pose results in order, repeating the last one.
class ScriptedEstimator implements PoseEstimator {
  ScriptedEstimator(this.script);
  List<PoseEstimation> script;
  int calls = 0;

  @override
  Future<void> load() async {}
  @override
  Future<PoseEstimation> estimate(CameraFrame frame) async {
    final r = script[calls < script.length ? calls : script.length - 1];
    calls++;
    return r;
  }

  @override
  Future<void> dispose() async {}
}

/// Returns scripted face results in order, repeating the last one.
class ScriptedFaceEstimator implements FaceEstimator {
  ScriptedFaceEstimator(this.script);
  List<FaceEstimation> script;
  int calls = 0;

  @override
  Future<FaceEstimation> estimate(CameraFrame frame) async {
    final r = script[calls < script.length ? calls : script.length - 1];
    calls++;
    return r;
  }

  @override
  Future<void> dispose() async {}
}
