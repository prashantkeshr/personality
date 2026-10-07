import 'package:flutter/material.dart';

import '../../ml/pose/pose_estimator.dart';

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
    // Body guide: where to stand for a full-body check.
    final guide = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width * 0.6,
          height: size.height * 0.88),
      const Radius.circular(24),
    );
    canvas.drawRRect(
        guide,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = guideColor);

    final p = pose;
    if (p == null) return;
    Offset? at(PoseJoint j) {
      final l = p[j];
      if (l == null || l.visibility < minVisibility) return null;
      // Front-camera previews are mirrored; mirror the overlay to match.
      final x = p.frontCamera ? 1 - l.x : l.x;
      return Offset(x * size.width, l.y * size.height);
    }

    final bone = Paint()
      ..color = boneColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (final (a, b) in _bones) {
      final pa = at(a), pb = at(b);
      if (pa != null && pb != null) canvas.drawLine(pa, pb, bone);
    }
    final dot = Paint()..color = boneColor;
    for (final l in p.landmarks) {
      final o = at(l.joint);
      if (o != null) canvas.drawCircle(o, 5, dot);
    }
  }

  @override
  bool shouldRepaint(SkeletonPainter old) => old.pose != pose;
}
