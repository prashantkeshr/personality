import 'dart:math' as math;

import 'package:flutter/foundation.dart' show Uint8List, compute;
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;

import '../../data/repositories/snapshot_repository.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/pose/pose_estimator.dart' show CameraFrame, FrameFormat;
import '../../ml/preprocessing/yuv_convert.dart';

/// Decodes a stored JPEG into an NV21 frame in memory (no files written).
CameraFrame? photoToFrame(Uint8List jpeg) {
  img.Image? im;
  try {
    im = img.decodeJpg(jpeg);
  } catch (_) {
    return null;
  }
  if (im == null || im.width < 64 || im.height < 64) return null;
  final rgba = im.convert(numChannels: 4, format: img.Format.uint8);
  final nv21 = rgbToNv21(rgba.toUint8List(), rgba.width, rgba.height);
  return CameraFrame(
    bytes: nv21.bytes,
    width: nv21.width,
    height: nv21.height,
    rotationDegrees: 0,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
    format: FrameFormat.nv21,
  );
}

/// Finds the eyes in face snapshots that have not been checked yet, so the
/// journey time-lapse can line every photo up. Runs once per photo.
class SnapshotAligner {
  SnapshotAligner(this._repo, this._estimator);

  final SnapshotRepository _repo;
  final FaceEstimator _estimator;

  /// Returns how many photos were checked.
  Future<int> alignPending() async {
    var checked = 0;
    for (final (id, jpeg) in await _repo.pendingAlignment()) {
      final frame = await compute(photoToFrame, jpeg);
      if (frame == null) {
        await _repo.setEyes(id, null);
        checked++;
        continue;
      }
      final result = await _estimator.estimate(frame);
      switch (result) {
        case FaceUnavailable():
          return checked; // try again once face analysis is available
        case FaceDetected(:final leftEye?, :final rightEye?):
          await _repo.setEyes(id, (
            (leftEye.$1 / frame.width, leftEye.$2 / frame.height),
            (rightEye.$1 / frame.width, rightEye.$2 / frame.height),
          ));
        default:
          await _repo.setEyes(id, null);
      }
      checked++;
    }
    return checked;
  }
}

/// Where the eyes land in every aligned frame: centred, 42% from the top,
/// 32% of the frame width apart.
const alignedEyeCentre = Offset(0.5, 0.42);
const alignedEyeDistance = 0.32;

/// Maps image pixels to an [out]-sized frame so the eyes sit at the fixed
/// position, level and at the same distance — like a time-lapse rig.
Matrix4 alignTransform(EyePoints eyes, Size image, Size out) {
  var (a, b) = eyes;
  if (a.$1 > b.$1) (a, b) = (b, a); // left-most eye first
  final ax = a.$1 * image.width, ay = a.$2 * image.height;
  final bx = b.$1 * image.width, by = b.$2 * image.height;
  final dist = math.max(1.0, math.sqrt(math.pow(bx - ax, 2) + math.pow(by - ay, 2)));
  final scale = alignedEyeDistance * out.width / dist;
  final angle = math.atan2(by - ay, bx - ax);
  return Matrix4.identity()
    ..translateByDouble(alignedEyeCentre.dx * out.width,
        alignedEyeCentre.dy * out.height, 0, 1)
    ..rotateZ(-angle)
    ..scaleByDouble(scale, scale, 1, 1)
    ..translateByDouble(-(ax + bx) / 2, -(ay + by) / 2, 0, 1);
}

/// Fallback when eyes were not found: cover-fit the photo.
Matrix4 coverTransform(Size image, Size out) {
  final s = math.max(out.width / image.width, out.height / image.height);
  return Matrix4.identity()
    ..translateByDouble((out.width - image.width * s) / 2,
        (out.height - image.height * s) / 2, 0, 1)
    ..scaleByDouble(s, s, 1, 1);
}
