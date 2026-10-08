/// Colour maths for palettes and outfit harmony (spec §22–24).
///
/// Colours are sRGB hex values. Perceptual distance uses CIE Lab (ΔE76),
/// harmony uses hue angles. Pure Dart, no Flutter imports.
library;

import 'dart:math' as math;

class Rgb {
  const Rgb(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  /// Parses "#RRGGBB" or "RRGGBB".
  factory Rgb.hex(String hex) {
    final h = hex.replaceFirst('#', '');
    if (h.length != 6) throw FormatException('Bad colour', hex);
    final v = int.parse(h, radix: 16);
    return Rgb((v >> 16) & 0xff, (v >> 8) & 0xff, v & 0xff);
  }

  String get hex =>
      '#${[r, g, b].map((c) => c.toRadixString(16).padLeft(2, '0')).join().toUpperCase()}';

  int get argb => 0xff000000 | (r << 16) | (g << 8) | b;

  @override
  bool operator ==(Object other) =>
      other is Rgb && other.r == r && other.g == g && other.b == b;

  @override
  int get hashCode => Object.hash(r, g, b);
}

class Lab {
  const Lab(this.l, this.a, this.b);

  final double l;
  final double a;
  final double b;

  /// Chroma (colourfulness).
  double get chroma => math.sqrt(a * a + b * b);

  /// Hue angle in degrees [0, 360).
  double get hue {
    final h = math.atan2(b, a) * 180 / math.pi;
    return h < 0 ? h + 360 : h;
  }
}

double _lin(int c) {
  final v = c / 255;
  return v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
}

double _f(double t) =>
    t > 216 / 24389 ? math.pow(t, 1 / 3).toDouble() : (24389 / 27 * t + 16) / 116;

/// sRGB → CIE Lab (D65).
Lab toLab(Rgb c) {
  final r = _lin(c.r), g = _lin(c.g), b = _lin(c.b);
  final x = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047;
  final y = 0.2126 * r + 0.7152 * g + 0.0722 * b;
  final z = (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883;
  final fx = _f(x), fy = _f(y), fz = _f(z);
  return Lab(116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz));
}

/// Perceptual distance (CIE76 ΔE).
double deltaE(Rgb a, Rgb b) {
  final p = toLab(a), q = toLab(b);
  return math.sqrt(math.pow(p.l - q.l, 2) +
      math.pow(p.a - q.a, 2) +
      math.pow(p.b - q.b, 2));
}

/// Neutrals (black, white, greys, beige, navy, denim, brown) pair with
/// almost anything, so harmony rules treat them separately.
bool isNeutral(Rgb c) {
  final lab = toLab(c);
  if (lab.chroma < 12) return true; // greys, black, white
  final h = lab.hue;
  // Beige/camel/brown: low-to-mid chroma warm hues.
  if (lab.chroma < 32 && h >= 40 && h <= 95) return true;
  // Navy and denim: dark or muted blues.
  if (h >= 240 && h <= 300 && (lab.l < 32 || lab.chroma < 30)) return true;
  return false;
}

/// Smallest angle between two hues, 0–180.
double hueGap(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

enum Harmony { neutral, monochrome, analogous, complementary, clash }

/// How a set of colours relates. Neutrals are ignored; one accent colour
/// is always fine.
Harmony harmonyOf(List<Rgb> colors) {
  final accents = [for (final c in colors) if (!isNeutral(c)) toLab(c)];
  if (accents.isEmpty) return Harmony.neutral;
  if (accents.length == 1) return Harmony.monochrome;
  var maxGap = 0.0;
  for (var i = 0; i < accents.length; i++) {
    for (var j = i + 1; j < accents.length; j++) {
      maxGap = math.max(maxGap, hueGap(accents[i].hue, accents[j].hue));
    }
  }
  if (maxGap <= 20) return Harmony.monochrome;
  if (maxGap <= 50) return Harmony.analogous;
  if (maxGap >= 140 && accents.length == 2) return Harmony.complementary;
  return Harmony.clash;
}
