// On-device check of the bundled pose model (run with `flutter test
// integration_test -d <device>`). Uses synthetic frames only.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:personality/ml/pose/mlkit_pose_estimator.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

Uint8List nv21(int w, int h) {
  final b = Uint8List(w * h * 3 ~/ 2);
  for (var i = 0; i < w * h; i++) {
    b[i] = 40 + (i % w) * 150 ~/ w; // gradient luma
  }
  b.fillRange(w * h, b.length, 128); // neutral chroma
  return b;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final (w, h, rot) in [(640, 480, 270), (720, 480, 90), (1280, 720, 270)]) {
    testWidgets('ML Kit runs on a ${w}x$h NV21 frame (rotation $rot)',
        (tester) async {
      final estimator = MlKitPoseEstimator();
      final result = await estimator.estimate(CameraFrame(
        bytes: nv21(w, h),
        width: w,
        height: h,
        bytesPerRow: w,
        rotationDegrees: rot,
        timestamp: DateTime.now(),
        format: FrameFormat.nv21,
        frontCamera: rot == 270,
      ));
      // ignore: avoid_print
      print('RESULT ${w}x$h: ${result.runtimeType}'
          '${result is PoseUnavailable ? ' ${result.reason}' : ''}');
      expect(result, isNot(isA<PoseUnavailable>()));
      await estimator.dispose();
    });
  }
}
