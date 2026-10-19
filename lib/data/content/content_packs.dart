import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';

/// Optional content downloaded from our public GitHub repository, only when
/// the user taps Download. Nothing about the user is ever sent.
abstract final class ContentSource {
  static const repo = 'prashantkeshr/personality-content';
  static final manifest =
      Uri.parse('https://raw.githubusercontent.com/$repo/main/manifest.json');
  static Uri file(String path) =>
      Uri.parse('https://raw.githubusercontent.com/$repo/main/$path');

  /// The only hosts the app will ever download from.
  static const hosts = {'raw.githubusercontent.com', 'github.com', 'objects.githubusercontent.com'};
}

/// One entry of `manifest.json`.
class PackInfo {
  const PackInfo({
    required this.id,
    required this.version,
    required this.kind,
    required this.title,
    required this.summary,
    required this.file,
    required this.size,
    required this.sha256,
    required this.license,
    required this.credit,
    this.items = 0,
  });

  final String id;
  final int version;

  /// `exercises` or `media`.
  final String kind;
  final Map<String, String> title;
  final Map<String, String> summary;
  final String file;
  final int size;
  final String sha256;
  final String license;
  final String credit;
  final int items;

  static Map<String, String> _text(Object? v) =>
      v is Map ? v.map((k, v) => MapEntry('$k', '$v')) : {'en': '${v ?? ''}'};

  factory PackInfo.fromJson(Map<String, dynamic> j) => PackInfo(
        id: j['id'] as String,
        version: j['version'] as int,
        kind: j['kind'] as String? ?? 'exercises',
        title: _text(j['title']),
        summary: _text(j['summary']),
        file: j['file'] as String,
        size: j['size'] as int,
        sha256: (j['sha256'] as String).toLowerCase(),
        license: j['license'] as String? ?? '',
        credit: j['credit'] as String? ?? '',
        items: j['items'] as int? ?? 0,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'version': version,
        'kind': kind,
        'title': title,
        'summary': summary,
        'file': file,
        'size': size,
        'sha256': sha256,
        'license': license,
        'credit': credit,
        'items': items,
      };

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? (m.isEmpty ? '' : m.values.first);
}

/// A pack on this phone.
class InstalledPack {
  const InstalledPack({required this.info, required this.dir, required this.installedAt});
  final PackInfo info;
  final String dir;
  final DateTime installedAt;
}

enum PackErrorKind { offline, wifiOnly, download, checksum, damaged, blockedHost }

class PackError implements Exception {
  const PackError(this.kind);
  final PackErrorKind kind;
  @override
  String toString() => 'PackError(${kind.name})';
}

/// Fetches bytes over HTTPS from the allowed hosts only.
abstract interface class PackFetcher {
  Future<Uint8List> get(Uri uri, {void Function(int received, int? total)? onProgress});
}

class HttpPackFetcher implements PackFetcher {
  const HttpPackFetcher({this.maxBytes = 64 << 20, this.stall = const Duration(seconds: 30)});
  final int maxBytes;

  /// Gives up when a lookup, connection or the data itself stalls this long,
  /// so a network without real internet shows an error instead of spinning.
  final Duration stall;

  @override
  Future<Uint8List> get(Uri uri, {void Function(int, int?)? onProgress}) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20)
      ..userAgent = 'Personality'; // no device or user details
    try {
      var u = uri;
      for (var hop = 0; hop < 5; hop++) {
        if (u.scheme != 'https' || !ContentSource.hosts.contains(u.host)) {
          throw const PackError(PackErrorKind.blockedHost);
        }
        final req = await client.getUrl(u).timeout(stall)..followRedirects = false;
        final res = await req.close().timeout(stall);
        if (res.isRedirect) {
          final loc = res.headers.value(HttpHeaders.locationHeader);
          await res.drain<void>();
          if (loc == null) throw const PackError(PackErrorKind.download);
          u = u.resolve(loc);
          continue;
        }
        if (res.statusCode != 200) {
          await res.drain<void>();
          throw const PackError(PackErrorKind.download);
        }
        final total = res.contentLength > 0 ? res.contentLength : null;
        final b = BytesBuilder(copy: false);
        await for (final chunk in res.timeout(stall)) {
          b.add(chunk);
          if (b.length > maxBytes) throw const PackError(PackErrorKind.download);
          onProgress?.call(b.length, total);
        }
        return b.takeBytes();
      }
      throw const PackError(PackErrorKind.download);
    } on PackError {
      rethrow;
    } on SocketException {
      throw const PackError(PackErrorKind.offline);
    } on TimeoutException {
      throw const PackError(PackErrorKind.offline);
    } on HandshakeException {
      throw const PackError(PackErrorKind.download);
    } on HttpException {
      throw const PackError(PackErrorKind.download);
    } finally {
      client.close(force: true);
    }
  }
}

/// Network state from Android, for "Wi-Fi only".
class NetworkState {
  const NetworkState({required this.online, required this.unmetered});
  final bool online;
  final bool unmetered;

  static const _ch = MethodChannel('personality/device');

  static Future<NetworkState> read() async {
    try {
      final m = await _ch.invokeMapMethod<String, bool>('network') ?? const {};
      return NetworkState(online: m['online'] ?? true, unmetered: m['unmetered'] ?? false);
    } on MissingPluginException {
      return const NetworkState(online: true, unmetered: true);
    }
  }
}

/// Downloads, verifies, installs and removes packs under [root].
class ContentPackStore {
  ContentPackStore({required this.root, required this.fetcher, DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  /// `<app support>/packs`.
  final String root;
  final PackFetcher fetcher;
  final DateTime Function() _clock;

  static const _meta = 'meta.json';

  Future<List<PackInfo>> fetchManifest() async {
    final bytes = await fetcher.get(ContentSource.manifest);
    try {
      final j = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      if ((j['schema'] as int? ?? 1) > 1) return const [];
      return [for (final p in j['packs'] as List) PackInfo.fromJson(p as Map<String, dynamic>)];
    } catch (_) {
      throw const PackError(PackErrorKind.damaged);
    }
  }

  Future<List<InstalledPack>> installed() async {
    final dir = Directory(root);
    if (!dir.existsSync()) return const [];
    final out = <InstalledPack>[];
    for (final d in dir.listSync().whereType<Directory>()) {
      final meta = File('${d.path}/$_meta');
      if (!meta.existsSync()) continue; // half-installed: ignored, cleaned on reinstall
      try {
        final j = jsonDecode(await meta.readAsString()) as Map<String, dynamic>;
        out.add(InstalledPack(
          info: PackInfo.fromJson(j['info'] as Map<String, dynamic>),
          dir: d.path,
          installedAt: DateTime.parse(j['installedAt'] as String),
        ));
      } catch (_) {}
    }
    out.sort((a, b) => a.info.id.compareTo(b.info.id));
    return out;
  }

  /// Downloads [p], checks its SHA-256 and unpacks it. Replaces an older
  /// version only once the new one is fully in place.
  Future<InstalledPack> install(PackInfo p, {void Function(double)? onProgress}) async {
    final bytes = await fetcher.get(ContentSource.file(p.file),
        onProgress: (r, t) => onProgress?.call((r / (t ?? p.size)).clamp(0, 1)));
    final digest = await Sha256().hash(bytes);
    final hex = digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    if (hex != p.sha256) throw const PackError(PackErrorKind.checksum);

    final staging = Directory('$root/.staging-${p.id}');
    if (staging.existsSync()) staging.deleteSync(recursive: true);
    staging.createSync(recursive: true);
    try {
      await _unzipInBackground(bytes, staging.path);
    } catch (_) {
      staging.deleteSync(recursive: true);
      throw const PackError(PackErrorKind.damaged);
    }
    final now = _clock();
    File('${staging.path}/$_meta').writeAsStringSync(
        jsonEncode({'info': p.toJson(), 'installedAt': now.toUtc().toIso8601String()}));
    final target = Directory('$root/${p.id}');
    if (target.existsSync()) target.deleteSync(recursive: true);
    staging.renameSync(target.path);
    return InstalledPack(info: p, dir: target.path, installedAt: now);
  }

  /// Built in a static scope so the isolate closure captures only plain
  /// data (not the progress callback, which holds UI state).
  static Future<void> _unzipInBackground(Uint8List bytes, String dir) =>
      Isolate.run(() => _unzip(bytes, dir));

  static void _unzip(Uint8List bytes, String dir) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final base = Directory(dir).absolute.path;
    for (final f in archive.files) {
      if (!f.isFile) continue;
      final out = File('$base/${f.name}').absolute;
      // Never write outside the pack folder.
      if (f.name.contains('..') || !out.path.startsWith(base)) throw const FormatException('path');
      out.parent.createSync(recursive: true);
      out.writeAsBytesSync(f.content as List<int>);
    }
  }

  Future<void> remove(String id) async {
    final d = Directory('$root/$id');
    if (d.existsSync()) d.deleteSync(recursive: true);
  }

  /// Bytes used on this phone by a pack.
  Future<int> sizeOf(InstalledPack p) async {
    var n = 0;
    await for (final e in Directory(p.dir).list(recursive: true)) {
      if (e is File) n += await e.length();
    }
    return n;
  }
}
