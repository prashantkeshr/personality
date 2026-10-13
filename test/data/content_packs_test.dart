import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/content/content_packs.dart';
import 'package:personality/domain/entities/exercise_library.dart';

/// Serves bytes by URL; records what was asked for.
class FakeFetcher implements PackFetcher {
  FakeFetcher(this.files);
  final Map<String, Uint8List> files;
  final asked = <Uri>[];

  @override
  Future<Uint8List> get(Uri uri, {void Function(int, int?)? onProgress}) async {
    asked.add(uri);
    final b = files[uri.toString()];
    if (b == null) throw const PackError(PackErrorKind.download);
    onProgress?.call(b.length, b.length);
    return b;
  }
}

Future<String> sha(List<int> b) async =>
    (await Sha256().hash(b)).bytes.map((x) => x.toRadixString(16).padLeft(2, '0')).join();

Uint8List zip(Map<String, String> files) {
  final a = Archive();
  for (final e in files.entries) {
    final d = utf8.encode(e.value);
    a.addFile(ArchiveFile(e.key, d.length, d));
  }
  return Uint8List.fromList(ZipEncoder().encode(a));
}

void main() {
  late Directory root;
  setUp(() => root = Directory.systemTemp.createTempSync('packs'));
  tearDown(() => root.deleteSync(recursive: true));

  Future<PackInfo> info(String id, Uint8List bytes, {int version = 1, String? digest}) async => PackInfo(
        id: id,
        version: version,
        kind: 'exercises',
        title: const {'en': 'T'},
        summary: const {'en': 'S'},
        file: 'packs/$id/$id-$version.zip',
        size: bytes.length,
        sha256: digest ?? await sha(bytes),
        license: 'MIT',
        credit: '',
      );

  test('the real face, jaw & neck pack installs and parses', () async {
    final local = File('../personality-content/packs/face-jaw-neck/face-jaw-neck-1.zip');
    final manifestFile = File('../personality-content/manifest.json');
    if (!local.existsSync() || !manifestFile.existsSync()) return; // content repo not checked out
    final manifest = (jsonDecode(manifestFile.readAsStringSync())['packs'] as List)
        .map((p) => PackInfo.fromJson(p as Map<String, dynamic>))
        .toList();
    final p = manifest.firstWhere((p) => p.id == 'face-jaw-neck');
    final bytes = local.readAsBytesSync();
    final store = ContentPackStore(
        root: root.path, fetcher: FakeFetcher({ContentSource.file(p.file).toString(): bytes}));
    await store.install(p);
    final installed = await store.installed();
    expect(installed.single.info.id, 'face-jaw-neck');
    final j = jsonDecode(File('${installed.single.dir}/pack.json').readAsStringSync()) as Map<String, dynamic>;
    final ex = [for (final e in j['exercises'] as List) LibraryExercise.fromJson(e as Map<String, dynamic>)];
    final programs = [for (final e in j['programs'] as List) WorkoutProgram.fromJson(e as Map<String, dynamic>)];
    expect(ex.every((e) => e.name.containsKey('hi') && e.motion != null), isTrue);
    // Honest expectations travel with the face programs.
    expect(programs.every((p) => p.note['en']!.contains("can't")), isTrue);
  });

  test('manifest, install, update and remove', () async {
    final v1 = zip({'pack.json': '{"exercises":[]}'});
    final v2 = zip({'pack.json': '{"exercises":[],"v":2}', 'media/a.txt': 'x'});
    final p1 = await info('yoga', v1);
    final p2 = await info('yoga', v2, version: 2);
    final fetcher = FakeFetcher({
      ContentSource.manifest.toString(): Uint8List.fromList(utf8.encode(jsonEncode({
        'schema': 1,
        'packs': [p2.toJson()]
      }))),
      ContentSource.file(p1.file).toString(): v1,
      ContentSource.file(p2.file).toString(): v2,
    });
    final store = ContentPackStore(root: root.path, fetcher: fetcher);
    expect((await store.fetchManifest()).single.version, 2);

    final progress = <double>[];
    await store.install(p1, onProgress: progress.add);
    expect(progress.last, 1.0);
    expect((await store.installed()).single.info.version, 1);
    await store.install(p2);
    final now = await store.installed();
    expect(now.single.info.version, 2);
    expect(File('${now.single.dir}/media/a.txt').existsSync(), isTrue);
    expect(await store.sizeOf(now.single), greaterThan(0));
    await store.remove('yoga');
    expect(await store.installed(), isEmpty);
    // Only our repository was ever contacted.
    expect(fetcher.asked.every((u) => u.host == 'raw.githubusercontent.com'), isTrue);
  });

  test('a file that fails its checksum is never installed', () async {
    final bytes = zip({'pack.json': '{}'});
    final p = await info('bad', bytes, digest: '0' * 64);
    final store = ContentPackStore(
        root: root.path, fetcher: FakeFetcher({ContentSource.file(p.file).toString(): bytes}));
    await expectLater(store.install(p),
        throwsA(isA<PackError>().having((e) => e.kind, 'kind', PackErrorKind.checksum)));
    expect(await store.installed(), isEmpty);
  });

  test('archives that try to write outside the pack folder are rejected', () async {
    final bytes = zip({'../escape.txt': 'nope', 'pack.json': '{}'});
    final p = await info('evil', bytes);
    final store = ContentPackStore(
        root: root.path, fetcher: FakeFetcher({ContentSource.file(p.file).toString(): bytes}));
    await expectLater(store.install(p),
        throwsA(isA<PackError>().having((e) => e.kind, 'kind', PackErrorKind.damaged)));
    expect(File('${root.parent.path}/escape.txt').existsSync(), isFalse);
    expect(await store.installed(), isEmpty);
  });

  test('the downloader refuses anything but HTTPS to our hosts', () async {
    const f = HttpPackFetcher();
    for (final u in ['http://raw.githubusercontent.com/x', 'https://example.com/x', 'https://evil.githubusercontent.com.example/x']) {
      await expectLater(f.get(Uri.parse(u)),
          throwsA(isA<PackError>().having((e) => e.kind, 'kind', PackErrorKind.blockedHost)), reason: u);
    }
  });
}
