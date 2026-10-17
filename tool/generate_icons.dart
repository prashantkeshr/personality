// Builds every launcher icon from the brand artwork in
// tool/branding/icon_source.png:
//
//   * adaptive foreground (mipmap-*/ic_launcher_foreground.png): the artwork
//     inside the 66% safe zone, so circle, squircle and square masks all keep
//     it whole;
//   * splash logo (drawable-*/splash_logo.png): the artwork on transparent;
//   * themed-icon monochrome (mipmap-*/ic_launcher_monochrome.png), also
//     cropped tight as the notification small icon
//     (drawable-*/ic_notification.png);
//   * legacy square and round PNGs (mipmap-*/ic_launcher*.png), and the same
//     square as the in-app logo (assets/images/brand/app_icon.png).
//
// The artwork sits on a dark rounded square that shades slightly from top to
// bottom. That square is replaced by a smooth gradient of the same colours
// across the whole canvas, so no seam shows whatever mask the launcher applies.
//
//   dart run tool/generate_icons.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _res = 'android/app/src/main/res';
const _dpis = {'mdpi': 1.0, 'hdpi': 1.5, 'xhdpi': 2.0, 'xxhdpi': 3.0, 'xxxhdpi': 4.0};

/// Artwork height as a share of the canvas: the adaptive layer is masked to
/// about 66% of its 108dp canvas, while legacy icons show the whole canvas.
const _adaptiveArt = 0.58;
const _legacyArt = 0.78;

late final img.Image _src;
late final img.Image _filled; // the artwork on a smooth opaque background
late final (double, double) _artCentre;
late final double _artHeight;

void main() {
  _src = img.decodePng(File('tool/branding/icon_source.png').readAsBytesSync())!
      .convert(numChannels: 4);
  _measureArt();
  _filled = _extendEdges(_src);

  // In-app logo (Settings → About), drawn like the legacy square icon.
  final logo = File('assets/images/brand/app_icon.png')..createSync(recursive: true);
  logo.writeAsBytesSync(img.encodePng(_mask(_canvas(192, _legacyArt), round: false)));
  stdout.writeln('${logo.path} (192 px)');

  for (final MapEntry(key: dpi, value: scale) in _dpis.entries) {
    final adaptive = (108 * scale).round();
    final legacy = (48 * scale).round();
    _write('mipmap-$dpi/ic_launcher_foreground.png', _canvas(adaptive, _adaptiveArt));
    _write('mipmap-$dpi/ic_launcher_monochrome.png', _mono(adaptive, _adaptiveArt));
    _write('drawable-$dpi/splash_logo.png', _logo(adaptive, _adaptiveArt));
    _write('drawable-$dpi/ic_notification.png', _mono((24 * scale).round(), 0.92));
    final full = _canvas(legacy, _legacyArt);
    _write('mipmap-$dpi/ic_launcher.png', _mask(full, round: false));
    _write('mipmap-$dpi/ic_launcher_round.png', _mask(full, round: true));
  }
}

void _write(String path, img.Image image) {
  final file = File('$_res/$path');
  file.writeAsBytesSync(img.encodePng(image));
  stdout.writeln('${file.path} (${image.width} px)');
}

double _luma(img.Pixel p) => 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;

/// Bounding box of the bright artwork (the faces, swirl and orb).
void _measureArt() {
  var x0 = _src.width, y0 = _src.height, x1 = 0, y1 = 0;
  for (final p in _src) {
    if (p.a > 200 && _luma(p) > 70) {
      x0 = math.min(x0, p.x);
      x1 = math.max(x1, p.x);
      y0 = math.min(y0, p.y);
      y1 = math.max(y1, p.y);
    }
  }
  _artCentre = ((x0 + x1) / 2, (y0 + y1) / 2);
  _artHeight = math.max((y1 - y0).toDouble(), (x1 - x0).toDouble());
}

/// The artwork and its glow on a smooth background: each row's background
/// colour is the average of that row's plain dark pixels, so the baked-in
/// square, its rim and any banding disappear and the launcher's own mask
/// gives the shape.
img.Image _extendEdges(img.Image s) {
  // Row averages of the dark background.
  final rows = List.filled(s.height, (0.0, 0.0, 0.0));
  var last = (0.0, 0.0, 10.0);
  for (var y = 0; y < s.height; y++) {
    var n = 0, r = 0.0, g = 0.0, b = 0.0;
    for (var x = 0; x < s.width; x++) {
      final p = s.getPixel(x, y);
      if (p.a == 255 && math.max(p.r, math.max(p.g, p.b)) <= 40) {
        n++;
        r += p.r;
        g += p.g;
        b += p.b;
      }
    }
    if (n > 20) last = (r / n, g / n, b / n);
    rows[y] = last;
  }
  // Smooth the rows so no band survives.
  const k = 40;
  final bg = [
    for (var y = 0; y < s.height; y++)
      () {
        var r = 0.0, g = 0.0, b = 0.0, n = 0;
        for (var i = math.max(0, y - k); i <= math.min(s.height - 1, y + k); i++) {
          r += rows[i].$1;
          g += rows[i].$2;
          b += rows[i].$3;
          n++;
        }
        return (r / n, g / n, b / n);
      }(),
  ];
  final out = s.clone();
  for (final p in out) {
    final c = bg[p.y];
    // Artwork weight: plain background (brightest channel <= 36) is replaced,
    // bright art kept, and the glow in between blended.
    final w = _artWeight(p);
    p
      ..r = (p.r * w + c.$1 * (1 - w)).round()
      ..g = (p.g * w + c.$2 * (1 - w)).round()
      ..b = (p.b * w + c.$3 * (1 - w)).round()
      ..a = 255;
  }
  return out;
}

/// Renders [size] px with the artwork [art] of the canvas tall, centred.
/// Drawn at a larger size first, then averaged down for clean small icons.
img.Image _render(int size, double art, img.Color Function(double sx, double sy) at) {
  final big = math.max(size, 512);
  final out = img.Image(width: big, height: big, numChannels: 4);
  final perPx = _artHeight / (art * big); // source px per canvas px
  for (final p in out) {
    final sx = _artCentre.$1 + (p.x + 0.5 - big / 2) * perPx;
    final sy = _artCentre.$2 + (p.y + 0.5 - big / 2) * perPx;
    p.set(at(sx, sy));
  }
  return big == size
      ? out
      : img.copyResize(out, width: size, height: size, interpolation: img.Interpolation.average);
}

img.Color _sample(img.Image s, double x, double y) => s.getPixelInterpolate(
      x.clamp(0, s.width - 1.0),
      y.clamp(0, s.height - 1.0),
      interpolation: img.Interpolation.linear,
    );

/// How much of a source pixel is artwork rather than plain background:
/// background (brightest channel <= 36) is 0, bright art 1, glow in between.
double _artWeight(img.Color p) {
  final m = math.max(p.r, math.max(p.g, p.b)).toDouble();
  final w = ((m - 36) / 40).clamp(0.0, 1.0);
  return w * w * (3 - 2 * w) * (p.a / 255);
}

img.Image _canvas(int size, double art) =>
    _render(size, art, (x, y) => _sample(_filled, x, y));

/// The artwork and its glow on transparent, for splash screens.
img.Image _logo(int size, double art) => _render(size, art, (x, y) {
      final inside = x >= 0 && y >= 0 && x < _src.width && y < _src.height;
      final p = _sample(_src, x, y);
      final a = inside ? _artWeight(p) : 0.0;
      return img.ColorRgba8(p.r.toInt(), p.g.toInt(), p.b.toInt(), (a * 255).round());
    });

/// White silhouette of the bright artwork on transparent, for themed icons.
img.Image _mono(int size, double art) => _render(size, art, (x, y) {
      final inside = x >= 0 && y >= 0 && x < _src.width && y < _src.height;
      final p = _sample(_src, x, y);
      final l = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
      final a = inside ? ((l - 50) / 110).clamp(0.0, 1.0) * (p.a / 255) : 0.0;
      return img.ColorRgba8(255, 255, 255, (a * 255).round());
    });

/// Legacy masks: circle, or a rounded square with 18% corners.
img.Image _mask(img.Image full, {required bool round}) {
  final out = full.clone();
  final n = out.width.toDouble();
  const ss = 4;
  for (final p in out) {
    var cover = 0;
    for (var i = 0; i < ss * ss; i++) {
      final u = (p.x + (i % ss + 0.5) / ss) / n;
      final v = (p.y + (i ~/ ss + 0.5) / ss) / n;
      if (round ? math.pow(u - 0.5, 2) + math.pow(v - 0.5, 2) <= 0.25 : _inRounded(u, v, 0.18)) {
        cover++;
      }
    }
    p.a = (p.a * cover / (ss * ss)).round();
  }
  return out;
}

bool _inRounded(double u, double v, double r) {
  final x = math.max(r - u, math.max(u - (1 - r), 0.0));
  final y = math.max(r - v, math.max(v - (1 - r), 0.0));
  return x * x + y * y <= r * r;
}
