/// Lighting quality from the luminance (Y) plane of a camera frame.
///
/// This is a real measurement — brightness and contrast of the pixels — not
/// an estimate of the person. It drives the lighting indicator and the
/// "improve lighting" guidance (spec §17).
library;

import 'dart:math' as math;
import 'dart:typed_data';

enum LightingLevel { tooDark, dim, good, tooBright, lowContrast }

class FrameQuality {
  const FrameQuality({required this.meanLuma, required this.contrast});

  /// Average brightness, 0–255.
  final double meanLuma;

  /// Standard deviation of brightness; near zero for a covered lens.
  final double contrast;

  LightingLevel get lighting {
    if (contrast < QualityThresholds.minContrast) return LightingLevel.lowContrast;
    if (meanLuma < QualityThresholds.tooDark) return LightingLevel.tooDark;
    if (meanLuma < QualityThresholds.dim) return LightingLevel.dim;
    if (meanLuma > QualityThresholds.tooBright) return LightingLevel.tooBright;
    return LightingLevel.good;
  }

  /// Whether the frame is usable for landmark detection.
  bool get usable =>
      lighting == LightingLevel.good || lighting == LightingLevel.dim;
}

abstract final class QualityThresholds {
  static const tooDark = 40.0;
  static const dim = 70.0;
  static const tooBright = 225.0;
  static const minContrast = 8.0;
}

abstract final class FrameQualityAnalyzer {
  /// Samples roughly [samples] pixels on a grid; reading every pixel is
  /// unnecessary for a lighting estimate and costs battery.
  static FrameQuality analyze({
    required Uint8List yPlane,
    required int width,
    required int height,
    required int bytesPerRow,
    int samples = 4096,
  }) {
    if (width <= 0 || height <= 0 || yPlane.isEmpty) {
      return const FrameQuality(meanLuma: 0, contrast: 0);
    }
    final step = math.max(1, math.sqrt(width * height / samples).floor());
    var n = 0;
    var sum = 0.0;
    var sumSq = 0.0;
    for (var y = 0; y < height; y += step) {
      final row = y * bytesPerRow;
      for (var x = 0; x < width; x += step) {
        final i = row + x;
        if (i >= yPlane.length) break;
        final v = yPlane[i].toDouble();
        sum += v;
        sumSq += v * v;
        n++;
      }
    }
    if (n == 0) return const FrameQuality(meanLuma: 0, contrast: 0);
    final mean = sum / n;
    final variance = math.max(0.0, sumSq / n - mean * mean);
    return FrameQuality(meanLuma: mean, contrast: math.sqrt(variance));
  }
}
