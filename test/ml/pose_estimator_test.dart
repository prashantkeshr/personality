import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

void main() {
  test('unavailable estimator never fabricates landmarks', () async {
    const estimator = UnavailablePoseEstimator();
    await estimator.load();
    final result = await estimator.estimate(CameraFrame(
      bytes: Uint8List(4),
      width: 1,
      height: 1,
      rotationDegrees: 0,
      timestamp: DateTime.utc(2026),
    ));
    expect(result, isA<PoseUnavailable>());
    expect((result as PoseUnavailable).reason,
        UnavailableReason.modelNotInstalled);
  });

  test('pose topology has 33 joints', () {
    expect(PoseJoint.values, hasLength(33));
  });
}
