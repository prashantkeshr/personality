import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

/// Speaks short workout cues with the phone's own text-to-speech engine
/// (offline voices; nothing is sent anywhere).
class Speech {
  const Speech();
  static const _ch = MethodChannel('personality/speech');

  /// Says [text], replacing anything still being said.
  Future<void> say(String text, String lang) async {
    try {
      await _ch.invokeMethod('speak', {'text': text, 'lang': lang});
    } on MissingPluginException {
      // Tests and platforms without the channel: stay quiet.
    } catch (e, st) {
      AppLogger.error('speech.say', e, st);
    }
  }

  Future<void> stop() async {
    try {
      await _ch.invokeMethod('stop');
    } on MissingPluginException {
      // ignore
    } catch (e, st) {
      AppLogger.error('speech.stop', e, st);
    }
  }
}

final speechProvider = Provider<Speech>((ref) => const Speech());
