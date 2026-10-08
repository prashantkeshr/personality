import 'dart:typed_data';

/// One image plane as delivered by the camera.
class YuvPlane {
  const YuvPlane(this.bytes, this.bytesPerRow, this.bytesPerPixel);

  final Uint8List bytes;
  final int bytesPerRow;
  final int bytesPerPixel;
}

/// Packs a YUV_420_888 frame (3 planes, any row/pixel stride) into NV21:
/// a tightly packed Y plane followed by interleaved V/U at quarter size.
/// Some devices ignore the NV21 request and deliver this format instead.
Uint8List yuv420ToNv21(int width, int height, List<YuvPlane> planes) {
  final y = planes[0], u = planes[1], v = planes[2];
  final out = Uint8List(width * height * 3 ~/ 2);
  var o = 0;
  for (var row = 0; row < height; row++) {
    final start = row * y.bytesPerRow;
    out.setRange(o, o + width, y.bytes, start);
    o += width;
  }
  final cw = width ~/ 2, ch = height ~/ 2;
  final up = u.bytesPerPixel == 0 ? 1 : u.bytesPerPixel;
  final vp = v.bytesPerPixel == 0 ? 1 : v.bytesPerPixel;
  for (var row = 0; row < ch; row++) {
    for (var col = 0; col < cw; col++) {
      final vi = row * v.bytesPerRow + col * vp;
      final ui = row * u.bytesPerRow + col * up;
      out[o++] = vi < v.bytes.length ? v.bytes[vi] : 128;
      out[o++] = ui < u.bytes.length ? u.bytes[ui] : 128;
    }
  }
  return out;
}

/// Packs an RGB(A) image into NV21 (BT.601 full range) so a stored photo can
/// be analysed by the same detector as live frames — entirely in memory.
/// Odd edges are dropped so both dimensions are even.
({Uint8List bytes, int width, int height}) rgbToNv21(
    Uint8List rgba, int width, int height, {int channels = 4}) {
  final w = width & ~1, h = height & ~1;
  final out = Uint8List(w * h * 3 ~/ 2);
  int px(int x, int y) => (y * width + x) * channels;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final i = px(x, y);
      final r = rgba[i], g = rgba[i + 1], b = rgba[i + 2];
      out[y * w + x] = ((77 * r + 150 * g + 29 * b) >> 8).clamp(0, 255);
    }
  }
  var o = w * h;
  for (var y = 0; y < h; y += 2) {
    for (var x = 0; x < w; x += 2) {
      final i = px(x, y);
      final r = rgba[i], g = rgba[i + 1], b = rgba[i + 2];
      out[o++] = (((128 * r - 107 * g - 21 * b) >> 8) + 128).clamp(0, 255); // V
      out[o++] = (((-43 * r - 85 * g + 128 * b) >> 8) + 128).clamp(0, 255); // U
    }
  }
  return (bytes: out, width: w, height: h);
}
