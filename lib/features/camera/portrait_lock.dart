import 'package:flutter/services.dart';

/// Camera screens are portrait-only so the preview, overlay and model input
/// share one orientation. Other screens follow the device as usual.
abstract final class PortraitLock {
  static void enter() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  static void exit() => SystemChrome.setPreferredOrientations(const []);
}
