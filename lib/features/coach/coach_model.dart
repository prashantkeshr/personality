import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:llamadart/llamadart.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';

/// The coach's language model: Qwen2.5 0.5B Instruct, q4_0 GGUF
/// (Apache-2.0, ungated), downloaded once by the user and then fully
/// offline. Pinned by size and SHA-256.
abstract final class CoachModelInfo {
  static const fileName = 'qwen2.5-0.5b-instruct-q4_0.gguf';
  static final url = Uri.parse(
    'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/$fileName',
  );
  static const size = 428730208;
  static const sha256 =
      '7671c0c304e6ce5a7fc577bcb12aba01e2c155cc2efd29b2213c95b18edaf6ed';
  static const licence = 'Qwen2.5-0.5B-Instruct · Apache-2.0 · Alibaba Cloud';

  /// Hugging Face and its download CDN only.
  static bool allowedHost(String host) =>
      host == 'huggingface.co' || host.endsWith('.hf.co');
}

enum CoachModelError { offline, download, checksum, storage, blockedHost }

class CoachModelException implements Exception {
  const CoachModelException(this.error);
  final CoachModelError error;
  @override
  String toString() => 'CoachModelException(${error.name})';
}

/// Downloads the model to `<app support>/models`, verifying it as it streams.
class CoachModelStore {
  CoachModelStore({required this.dir});
  final String dir;

  File get file => File('$dir/${CoachModelInfo.fileName}');
  bool get installed => file.existsSync() && file.lengthSync() == CoachModelInfo.size;

  /// [onProgress] gets 0–1. Cancels when [cancel] completes.
  Future<void> download({
    void Function(double)? onProgress,
    Future<void>? cancel,
  }) async {
    Directory(dir).createSync(recursive: true);
    final part = File('${file.path}.part');
    if (part.existsSync()) part.deleteSync();
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20)
      ..userAgent = 'Personality'; // no device or user details
    var cancelled = false;
    unawaited(cancel?.then((_) {
      cancelled = true;
      client.close(force: true);
    }));
    try {
      var u = CoachModelInfo.url;
      HttpClientResponse? res;
      for (var hop = 0; hop < 6; hop++) {
        if (u.scheme != 'https' || !CoachModelInfo.allowedHost(u.host)) {
          throw const CoachModelException(CoachModelError.blockedHost);
        }
        final req = await client.getUrl(u).timeout(const Duration(seconds: 30))
          ..followRedirects = false;
        final r = await req.close().timeout(const Duration(seconds: 30));
        if (r.isRedirect) {
          final loc = r.headers.value(HttpHeaders.locationHeader);
          await r.drain<void>();
          if (loc == null) throw const CoachModelException(CoachModelError.download);
          u = u.resolve(loc);
          continue;
        }
        res = r;
        break;
      }
      if (res == null || res.statusCode != 200) {
        await res?.drain<void>();
        throw const CoachModelException(CoachModelError.download);
      }
      final digest = _DigestSink();
      final hasher = crypto.sha256.startChunkedConversion(digest);
      final out = part.openWrite();
      var received = 0;
      try {
        await for (final chunk in res.timeout(const Duration(seconds: 45))) {
          out.add(chunk);
          hasher.add(chunk);
          received += chunk.length;
          if (received > CoachModelInfo.size) {
            throw const CoachModelException(CoachModelError.download);
          }
          onProgress?.call(received / CoachModelInfo.size);
        }
      } finally {
        await out.close();
      }
      hasher.close();
      if (received != CoachModelInfo.size ||
          digest.value.toString() != CoachModelInfo.sha256) {
        throw const CoachModelException(CoachModelError.checksum);
      }
      part.renameSync(file.path);
    } on CoachModelException {
      if (part.existsSync()) part.deleteSync();
      rethrow;
    } on FileSystemException {
      if (part.existsSync()) part.deleteSync();
      throw const CoachModelException(CoachModelError.storage);
    } on Exception {
      if (part.existsSync()) part.deleteSync();
      throw CoachModelException(
        cancelled ? CoachModelError.download : CoachModelError.offline,
      );
    } finally {
      client.close(force: true);
    }
  }

  Future<void> remove() async {
    if (file.existsSync()) file.deleteSync();
  }
}

class _DigestSink implements Sink<crypto.Digest> {
  late crypto.Digest value;
  @override
  void add(crypto.Digest data) => value = data;
  @override
  void close() {}
}

final coachModelStoreProvider = FutureProvider<CoachModelStore>((ref) async =>
    CoachModelStore(dir: '${(await getApplicationSupportDirectory()).path}/models'));

// --------------------------------------------------------------- runtime

enum CoachRole { system, user, assistant }

typedef CoachTurn = (CoachRole, String);

/// Runs the model. Swapped for a fake in tests.
abstract interface class CoachRuntime {
  /// Loads the model file once; throws when the device can't run it.
  Future<void> load(String path);
  bool get loaded;
  Stream<String> reply(List<CoachTurn> turns, {int maxTokens});
  void stop();
  Future<void> dispose();
}

class LlamaCoachRuntime implements CoachRuntime {
  LlamaEngine? _engine;
  String? _path;

  @override
  bool get loaded => _engine != null;

  @override
  Future<void> load(String path) async {
    if (_engine != null && _path == path) return;
    await dispose();
    _engine = await LlamaEngine.load(
      LlamaModel(ModelSource.parse(path)),
      // Small context keeps memory near 0.8 GB on a 0.5B model.
      params: const ModelParams(contextSize: 2048),
    );
    _path = path;
  }

  @override
  Stream<String> reply(List<CoachTurn> turns, {int maxTokens = 220}) {
    final engine = _engine;
    if (engine == null) return const Stream.empty();
    return engine
        .create(
          [
            for (final (role, text) in turns)
              LlamaChatMessage.fromText(
                role: switch (role) {
                  CoachRole.system => LlamaChatRole.system,
                  CoachRole.user => LlamaChatRole.user,
                  CoachRole.assistant => LlamaChatRole.assistant,
                },
                text: text,
              ),
          ],
          params: GenerationParams(maxTokens: maxTokens, temp: 0.2, topP: 0.85, penalty: 1.15),
          enableThinking: false,
        )
        .textDeltas();
  }

  @override
  void stop() => _engine?.cancelGeneration();

  @override
  Future<void> dispose() async {
    final e = _engine;
    _engine = null;
    _path = null;
    if (e != null) {
      try {
        await e.dispose();
      } catch (err, st) {
        AppLogger.error('coach.dispose', err, st);
      }
    }
  }
}

final coachRuntimeProvider = Provider<CoachRuntime>((ref) {
  final r = LlamaCoachRuntime();
  ref.onDispose(r.dispose);
  return r;
});

/// Whether this phone may run the model: about 0.8 GB of memory is needed,
/// so "4 GB" phones qualify (they report roughly 3.6–3.8 GB); Android's
/// low-RAM devices never do. 32-bit phones fail to load the engine and
/// fall back to search mode.
final coachDeviceCapableProvider = Provider<bool>((ref) {
  final specs = ref.watch(deviceSpecsProvider).value;
  final ram = specs?.ramMb;
  return ram != null && ram >= 3400 && !specs!.lowRamDevice;
});
