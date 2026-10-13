// Shrinks line-art illustrations for a content pack:
// dart run tool/convert_illustrations.dart <input dir> <output dir> [size]
//
// Output is an 8-bit grayscale PNG (white background, dark lines), trimmed
// and fitted into a square. The app tints it with the theme colour.
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

void main(List<String> args) {
  final input = Directory(args[0]);
  final output = Directory(args[1])..createSync(recursive: true);
  final size = args.length > 2 ? int.parse(args[2]) : 360;
  var n = 0, bytes = 0;
  for (final f in input.listSync().whereType<File>().where((f) => f.path.endsWith('.png'))) {
    final src = img.decodePng(f.readAsBytesSync());
    if (src == null) continue;
    // Flatten onto white: transparent pixels become white whatever their colour.
    final flat = img.Image(width: src.width, height: src.height);
    var minX = src.width, minY = src.height, maxX = 0, maxY = 0;
    for (final p in src) {
      final a = src.hasAlpha ? p.aNormalized.toDouble() : 1.0;
      // Grayscale sources have one channel; luminance would read g and b as 0.
      final lum = (src.numChannels <= 2 ? p.rNormalized : p.luminanceNormalized).toDouble();
      final g = (255 * (1 - a * (1 - lum))).round().clamp(0, 255);
      flat.setPixelRgb(p.x, p.y, g, g, g);
      if (g < 200) {
        minX = math.min(minX, p.x);
        minY = math.min(minY, p.y);
        maxX = math.max(maxX, p.x);
        maxY = math.max(maxY, p.y);
      }
    }
    if (maxX <= minX || maxY <= minY) continue;
    final trimmed = img.copyCrop(flat, x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1);
    final scale = (size - 8) / math.max(trimmed.width, trimmed.height);
    final resized = img.copyResize(trimmed,
        width: math.max(1, (trimmed.width * scale).round()),
        height: math.max(1, (trimmed.height * scale).round()),
        interpolation: img.Interpolation.average);
    final out = img.Image(width: size, height: size, numChannels: 1);
    for (final p in out) {
      p.r = 255;
    }
    final ox = (size - resized.width) ~/ 2, oy = (size - resized.height) ~/ 2;
    for (final p in resized) {
      out.getPixel(ox + p.x, oy + p.y).r = p.r;
    }
    final png = img.encodePng(out, level: 9);
    File('${output.path}/${f.uri.pathSegments.last}').writeAsBytesSync(png);
    n++;
    bytes += png.length;
  }
  stdout.writeln('$n images, ${(bytes / 1024).round()} KB');
}
