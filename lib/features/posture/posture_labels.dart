import 'package:flutter/material.dart';

import '../../domain/services/posture_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/pose/pose_estimator.dart';

extension PostureLabels on AppLocalizations {
  String postureMetricName(PostureMetric m) => switch (m) {
        PostureMetric.headTilt => pmHeadTilt,
        PostureMetric.shoulderLevel => pmShoulderLevel,
        PostureMetric.hipLevel => pmHipLevel,
        PostureMetric.torsoLean => pmTorsoLean,
        PostureMetric.kneeAlignment => pmKneeAlignment,
        PostureMetric.headForward => pmHeadForward,
      };

  String bandLabel(AlignmentBand b) => switch (b) {
        AlignmentBand.aligned => bandAligned,
        AlignmentBand.slight => bandSlight,
        AlignmentBand.noticeable => bandNoticeable,
      };

  /// Neutral description of where the deviation points.
  String directionLabel(PostureMetric m, MetricDirection d) => switch ((m, d)) {
        (_, MetricDirection.none) => dirNone,
        (PostureMetric.shoulderLevel || PostureMetric.hipLevel,
            MetricDirection.left) =>
          dirLeftHigher,
        (PostureMetric.shoulderLevel || PostureMetric.hipLevel,
            MetricDirection.right) =>
          dirRightHigher,
        (PostureMetric.headTilt, MetricDirection.left) => dirTiltLeft,
        (PostureMetric.headTilt, MetricDirection.right) => dirTiltRight,
        (PostureMetric.kneeAlignment, MetricDirection.left) => dirKneeLeft,
        (PostureMetric.kneeAlignment, MetricDirection.right) => dirKneeRight,
        (_, MetricDirection.left) => dirLeanLeft,
        (_, MetricDirection.right) => dirLeanRight,
        (PostureMetric.headForward, MetricDirection.forward) => dirHeadAhead,
        (_, MetricDirection.forward) => dirLeanForward,
        (_, MetricDirection.backward) => dirLeanBack,
      };

  String viewLabel(PostureView v) => switch (v) {
        PostureView.front => viewFront,
        PostureView.side => viewSide,
      };

  String poseGuidance(FrameQualityIssue i) => switch (i) {
        FrameQualityIssue.tooDark => lightingTooDarkAdvice,
        FrameQualityIssue.tooBright => lightingTooBrightAdvice,
        FrameQualityIssue.lowContrast => lightingLowContrastAdvice,
        FrameQualityIssue.bodyOutOfFrame => poseReposition,
        FrameQualityIssue.tooFar => poseTooFar,
        FrameQualityIssue.tooClose => poseTooClose,
        FrameQualityIssue.motionBlur => poseHoldStill,
        FrameQualityIssue.unclearView => poseUnclearView,
        FrameQualityIssue.lowVisibility => poseLowVisibility,
      };
}

/// Order in which problems are explained: fix the most basic first.
const guidancePriority = [
  FrameQualityIssue.tooDark,
  FrameQualityIssue.tooBright,
  FrameQualityIssue.lowContrast,
  FrameQualityIssue.bodyOutOfFrame,
  FrameQualityIssue.tooFar,
  FrameQualityIssue.tooClose,
  FrameQualityIssue.lowVisibility,
  FrameQualityIssue.unclearView,
  FrameQualityIssue.motionBlur,
];

FrameQualityIssue firstIssue(Set<FrameQualityIssue> issues) =>
    guidancePriority.firstWhere(issues.contains, orElse: () => issues.first);

Color bandColor(ColorScheme s, AlignmentBand b) => switch (b) {
      // Neutral palette: never red for body observations (design system).
      AlignmentBand.aligned => s.primary,
      AlignmentBand.slight => s.tertiary,
      AlignmentBand.noticeable => s.secondary,
    };
