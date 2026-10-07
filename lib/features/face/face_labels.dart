import '../../domain/services/face_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/pose/pose_estimator.dart' show FrameQualityIssue;
import '../posture/posture_labels.dart';

extension FaceLabels on AppLocalizations {
  String faceShapeName(FaceShape s) => switch (s) {
        FaceShape.oval => shapeOval,
        FaceShape.round => shapeRound,
        FaceShape.square => shapeSquare,
        FaceShape.oblong => shapeOblong,
        FaceShape.heart => shapeHeart,
        FaceShape.diamond => shapeDiamond,
      };

  String faceRatioName(FaceRatio r) => switch (r) {
        FaceRatio.lengthToWidth => ratioLengthWidth,
        FaceRatio.foreheadToCheek => ratioForeheadCheek,
        FaceRatio.jawToCheek => ratioJawCheek,
      };
}

/// Face-specific wording for capture problems.
String faceGuidance(AppLocalizations l10n, FrameQualityIssue i) => switch (i) {
      FrameQualityIssue.tooFar => l10n.faceTooFar,
      FrameQualityIssue.tooClose => l10n.faceTooClose,
      FrameQualityIssue.unclearView => l10n.faceTipStraight,
      FrameQualityIssue.bodyOutOfFrame => l10n.faceInGuide,
      _ => l10n.poseGuidance(i),
    };
