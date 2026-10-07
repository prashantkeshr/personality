import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/ml/preprocessing/yuv_convert.dart';

void main() {
  test('packs strided 3-plane YUV into NV21 (Y, then V/U pairs)', () {
    const w = 4, h = 2;
    // Y plane with 2 bytes of row padding.
    final y = Uint8List.fromList([1, 2, 3, 4, 0, 0, 5, 6, 7, 8, 0, 0]);
    // Chroma: semi-planar layout (pixel stride 2), as many phones deliver.
    final u = Uint8List.fromList([10, 0, 11]);
    final v = Uint8List.fromList([20, 0, 21]);
    final out = yuv420ToNv21(w, h, [
      YuvPlane(y, 6, 1),
      YuvPlane(u, 4, 2),
      YuvPlane(v, 4, 2),
    ]);
    expect(out, [1, 2, 3, 4, 5, 6, 7, 8, 20, 10, 21, 11]);
  });
}
