import 'package:flutter/services.dart';

/// System save/open pickers and the share sheet. The user picks every file.
abstract interface class FileBridge {
  /// False when the user cancelled.
  Future<bool> save(String name, String mime, Uint8List bytes);

  /// Null when the user cancelled.
  Future<Uint8List?> open();

  Future<void> share(String name, String mime, Uint8List bytes);
}

class PlatformFileBridge implements FileBridge {
  const PlatformFileBridge();

  static const _ch = MethodChannel('personality/files');

  @override
  Future<bool> save(String name, String mime, Uint8List bytes) async =>
      await _ch.invokeMethod<bool>('save', {'name': name, 'mime': mime, 'bytes': bytes}) ??
      false;

  @override
  Future<Uint8List?> open() => _ch.invokeMethod<Uint8List>('open');

  @override
  Future<void> share(String name, String mime, Uint8List bytes) =>
      _ch.invokeMethod('share', {'name': name, 'mime': mime, 'bytes': bytes});
}
