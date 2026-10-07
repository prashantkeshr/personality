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
