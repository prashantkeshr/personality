// Draws the legacy launcher PNGs (Android < 8) from the same geometry as
// android/app/src/main/res/drawable/ic_launcher_foreground.xml.
//
//   dart run tool/generate_icons.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _sizes = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192};

// Colours (ARGB components).
const _bgA = (0x13, 0x80, 0x7D);
const _bgB = (0x0A, 0x4A, 0x55);
const _mint = (0xE6, 0xF6, 0xF3);
const _gold = (0xF2, 0xC1, 0x4E);

/// Emblem coverage at a point in the 108-unit adaptive viewport:
/// 0 = background, 1 = mint, 2 = gold.
int _shape(double x, double y) {
  // Open ring: radius 24, stroke 3.5, gap at the top between 250° and 310°.
  final dx = x - 54, dy = y - 54;
  final r = math.sqrt(dx * dx + dy * dy);
  var a = math.atan2(dy, dx) * 180 / math.pi;
  if (a < 0) a += 360;
  final inGap = a > 250 && a < 310;
  if ((r - 24).abs() <= 1.75 && !inGap) return 1;
  for (final (cx, cy) in [(69.43, 35.61), (45.79, 31.45)]) {
    if (math.pow(x - cx, 2) + math.pow(y - cy, 2) <= 1.75 * 1.75) return 1;
  }
  // Head and shoulders.
  if (math.pow(x - 54, 2) + math.pow(y - 47, 2) <= 6.5 * 6.5) return 1;
  if (y <= 70 && math.pow((x - 54) / 12, 2) + math.pow((y - 70) / 13, 2) <= 1) {
    return 1;
  }
  // Four-point spark.
  const star = [
    (58.0, 25.0), (59.6, 29.4), (64.0, 31.0), (59.6, 32.6),
    (58.0, 37.0), (56.4, 32.6), (52.0, 31.0), (56.4, 29.4),
  ];
  var inside = false;
  for (var i = 0, j = star.length - 1; i < star.length; j = i++) {
    final (xi, yi) = star[i];
    final (xj, yj) = star[j];
    if ((yi > y) != (yj > y) && x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
      inside = !inside;
    }
  }
  return inside ? 2 : 0;
}

img.Image _render(int size, {required bool round}) {
  final out = img.Image(width: size, height: size, numChannels: 4);
  const ss = 4; // supersampling per axis
  // The emblem's safe zone (18..90) fills the legacy icon.
  for (var py = 0; py < size; py++) {
    for (var px = 0; px < size; px++) {
      var cover = 0.0, rr = 0.0, gg = 0.0, bb = 0.0;
      for (var sy = 0; sy < ss; sy++) {
        for (var sx = 0; sx < ss; sx++) {
          final u = (px + (sx + 0.5) / ss) / size;
          final v = (py + (sy + 0.5) / ss) / size;
          // Background mask: circle, or rounded square (radius 18%).
          final inBg = round
              ? math.pow(u - 0.5, 2) + math.pow(v - 0.5, 2) <= 0.25
              : _inRounded(u, v, 0.18);
          if (!inBg) continue;
          final t = (u + v) / 2;
          var c = (
            _bgA.$1 + (_bgB.$1 - _bgA.$1) * t,
            _bgA.$2 + (_bgB.$2 - _bgA.$2) * t,
            _bgA.$3 + (_bgB.$3 - _bgA.$3) * t,
          );
          final s = _shape(18 + u * 72, 18 + v * 72);
          if (s == 1) c = (_mint.$1 * 1.0, _mint.$2 * 1.0, _mint.$3 * 1.0);
          if (s == 2) c = (_gold.$1 * 1.0, _gold.$2 * 1.0, _gold.$3 * 1.0);
          cover += 1;
          rr += c.$1;
          gg += c.$2;
          bb += c.$3;
        }
      }
      if (cover == 0) continue;
      out.setPixelRgba(px, py, (rr / cover).round(), (gg / cover).round(),
          (bb / cover).round(), (cover / (ss * ss) * 255).round());
    }
  }
  return out;
}

bool _inRounded(double u, double v, double r) {
  final x = math.max(r - u, math.max(u - (1 - r), 0.0));
  final y = math.max(r - v, math.max(v - (1 - r), 0.0));
  return x * x + y * y <= r * r;
}

void main() {
  const res = 'android/app/src/main/res';
  for (final MapEntry(key: dpi, value: size) in _sizes.entries) {
    for (final (name, round) in [('ic_launcher', false), ('ic_launcher_round', true)]) {
      final file = File('$res/mipmap-$dpi/$name.png');
      file.writeAsBytesSync(img.encodePng(_render(size, round: round)));
      stdout.writeln('${file.path} ($size px)');
    }
  }
}
