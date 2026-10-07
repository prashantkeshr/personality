import 'package:flutter/material.dart';

import '../../ml/pose/pose_estimator.dart';

/// Joints that get a marker (face detail points are skipped as clutter).
const _drawn = {
  PoseJoint.nose,
  PoseJoint.leftShoulder, PoseJoint.rightShoulder,
  PoseJoint.leftElbow, PoseJoint.rightElbow,
  PoseJoint.leftWrist, PoseJoint.rightWrist,
  PoseJoint.leftHip, PoseJoint.rightHip,
  PoseJoint.leftKnee, PoseJoint.rightKnee,
  PoseJoint.leftAnkle, PoseJoint.rightAnkle,
};

/// Bones drawn between landmarks.
const _bones = [
  (PoseJoint.leftShoulder, PoseJoint.rightShoulder),
  (PoseJoint.leftShoulder, PoseJoint.leftElbow),
  (PoseJoint.leftElbow, PoseJoint.leftWrist),
  (PoseJoint.rightShoulder, PoseJoint.rightElbow),
  (PoseJoint.rightElbow, PoseJoint.rightWrist),
  (PoseJoint.leftShoulder, PoseJoint.leftHip),
  (PoseJoint.rightShoulder, PoseJoint.rightHip),
  (PoseJoint.leftHip, PoseJoint.rightHip),
  (PoseJoint.leftHip, PoseJoint.leftKnee),
  (PoseJoint.leftKnee, PoseJoint.leftAnkle),
  (PoseJoint.rightHip, PoseJoint.rightKnee),
  (PoseJoint.rightKnee, PoseJoint.rightAnkle),
  (PoseJoint.leftEar, PoseJoint.rightEar),
];

/// Landmark overlay and body guide, painted in the preview's coordinate
/// space. Landmarks below [minVisibility] are not drawn.
class SkeletonPainter extends CustomPainter {
  SkeletonPainter({
    required this.pose,
    required this.guideColor,
    required this.boneColor,
    this.minVisibility = 0.5,
  });

  final PoseDetected? pose;
  final Color guideColor;
  final Color boneColor;
  final double minVisibility;

  @override
  void paint(Canvas canvas, Size size) {
    final p = pose;
    if (p == null) return;
    Offset? at(PoseJoint j) {
      final l = p[j];
      if (l == null || l.visibility < minVisibility) return null;
      // Front-camera previews are mirrored; mirror the overlay to match.
      final x = p.frontCamera ? 1 - l.x : l.x;
      return Offset(x * size.width, l.y * size.height);
    }

    // Soft glow beneath crisp bones; joints as rings with a light core.
    final glow = Paint()
      ..color = boneColor.withValues(alpha: 0.45)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final bone = Paint()
      ..color = boneColor
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    for (final (a, b) in _bones) {
      final pa = at(a), pb = at(b);
      if (pa != null && pb != null) {
        canvas.drawLine(pa, pb, glow);
        canvas.drawLine(pa, pb, bone);
      }
    }
    final ring = Paint()
      ..color = boneColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final core = Paint()..color = Colors.white;
    for (final l in p.landmarks) {
      if (!_drawn.contains(l.joint)) continue;
      final o = at(l.joint);
      if (o == null) continue;
      canvas.drawCircle(o, 6, ring);
      canvas.drawCircle(o, 2.5, core);
    }
  }

  @override
  bool shouldRepaint(SkeletonPainter old) => old.pose != pose;
}
