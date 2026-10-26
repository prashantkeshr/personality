import 'dart:ui';

import 'package:flutter/services.dart';

/// Phones stay in portrait (the layouts are designed for it); tablets turn
/// freely. Camera screens are portrait everywhere so the preview, overlay
/// and model input share one orientation.
abstract final class PortraitLock {
  /// True when the shortest side is under 600 logical pixels.
  static bool get isPhone {
    final views = PlatformDispatcher.instance.views;
    if (views.isEmpty) return true;
    final v = views.first;
    final size = v.physicalSize / v.devicePixelRatio;
    return size.shortestSide < 600;
  }

  /// The app-wide rule, applied at start.
  static void applyDefault() => SystemChrome.setPreferredOrientations(
    isPhone ? const [DeviceOrientation.portraitUp] : const [],
  );

  static void enter() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Back to the app-wide rule (portrait on phones).
  static void exit() => applyDefault();
}
