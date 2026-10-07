import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Developer logging (spec §70).
///
/// Only technical context is logged: an event name and the error *type*.
/// Messages, values, images and health data are never passed to the log.
abstract final class AppLogger {
  static void error(String event, Object error, [StackTrace? stackTrace]) {
    developer.log(
      '$event: ${error.runtimeType}',
      name: 'personality',
      level: 1000,
      stackTrace: stackTrace,
    );
    // Debug builds only: the exception text helps diagnose device-specific
    // failures. Release builds never print it.
    if (kDebugMode) debugPrint('[personality] $event: $error');
  }

  static void info(String event) {
    developer.log(event, name: 'personality', level: 800);
  }
}
