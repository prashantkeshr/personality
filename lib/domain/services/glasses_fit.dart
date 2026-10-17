import 'face_engine.dart';

/// A frame in the glasses finder (assets/content/glasses.json).
class GlassesFrame {
  const GlassesFrame({
    required this.id,
    required this.name,
    required this.shape,
    required this.colorHex,
    this.thick = false,
    this.size = 'medium',
  });

  final String id;
  final Map<String, String> name;

  /// Matches a `GlassesStyle` name (rectangular, round, aviator, catEye…).
  final String shape;
  final String colorHex;
  final bool thick;

  /// narrow, medium or wide.
  final String size;

  factory GlassesFrame.fromJson(Map<String, dynamic> j) => GlassesFrame(
        id: j['id'] as String,
        name: (j['name'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String)),
        shape: j['shape'] as String,
        colorHex: j['color'] as String,
        thick: j['thick'] as bool? ?? false,
        size: j['size'] as String? ?? 'medium',
      );
}

/// How well a frame balances a face shape. This is fit guidance from
/// contrast rules, not a judgement of anyone's looks.
enum FrameFit { great, good, lessBalancing }

/// Why a frame got its fit (the UI turns these into sentences).
enum FitReason { addsAngles, softensAngles, addsLength, balancesForehead, liftsCheekbones, suitsMost, echoesShape, unknownShape }

abstract final class GlassesFit {
  /// Shapes that contrast with each face shape, and ones that echo it.
  static const _great = <FaceShape, Set<String>>{
    FaceShape.oval: {'rectangular', 'square', 'aviator', 'geometric', 'classic', 'browline'},
    FaceShape.round: {'rectangular', 'square', 'browline', 'geometric'},
    FaceShape.square: {'round', 'oval', 'aviator', 'catEye', 'rimless'},
    FaceShape.oblong: {'deep', 'classic', 'aviator', 'square', 'round'},
    FaceShape.heart: {'aviator', 'oval', 'round', 'rimless'},
    FaceShape.diamond: {'catEye', 'oval', 'browline', 'rimless'},
  };
  static const _less = <FaceShape, Set<String>>{
    FaceShape.oval: {},
    FaceShape.round: {'round', 'oval'},
    FaceShape.square: {'square', 'geometric', 'rectangular'},
    FaceShape.oblong: {'rimless'},
    FaceShape.heart: {'catEye', 'browline'},
    FaceShape.diamond: {'rectangular', 'square'},
  };

  static FitReason _reason(FaceShape s) => switch (s) {
        FaceShape.oval => FitReason.suitsMost,
        FaceShape.round => FitReason.addsAngles,
        FaceShape.square => FitReason.softensAngles,
        FaceShape.oblong => FitReason.addsLength,
        FaceShape.heart => FitReason.balancesForehead,
        FaceShape.diamond => FitReason.liftsCheekbones,
      };

  /// Fit of [frame] for [face]; without a face analysis every frame is
  /// "good" and the reason says so.
  static (FrameFit, FitReason) fit(GlassesFrame frame, FaceShape? face) {
    if (face == null) return (FrameFit.good, FitReason.unknownShape);
    if (_great[face]!.contains(frame.shape)) return (FrameFit.great, _reason(face));
    if (_less[face]!.contains(frame.shape)) return (FrameFit.lessBalancing, FitReason.echoesShape);
    return (FrameFit.good, _reason(face));
  }

  /// Frames ordered best fit first, keeping the catalogue order within a level.
  static List<GlassesFrame> ranked(List<GlassesFrame> frames, FaceShape? face) {
    final indexed = frames.indexed.toList()
      ..sort((a, b) {
        final c = fit(a.$2, face).$1.index.compareTo(fit(b.$2, face).$1.index);
        return c != 0 ? c : a.$1.compareTo(b.$1);
      });
    return [for (final (_, f) in indexed) f];
  }
}
