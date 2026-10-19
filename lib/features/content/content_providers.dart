import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/database/app_database.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../data/content/content_packs.dart';
import '../../domain/entities/exercise_library.dart';

/// Where packs live: `<app support>/packs`. Not part of backups.
final packsRootProvider = FutureProvider<String>(
    (ref) async => '${(await getApplicationSupportDirectory()).path}/packs');

final packFetcherProvider = Provider<PackFetcher>((ref) => const HttpPackFetcher());

final networkStateProvider = Provider<Future<NetworkState> Function()>((ref) => NetworkState.read);

final contentStoreProvider = FutureProvider<ContentPackStore>((ref) async => ContentPackStore(
    root: await ref.watch(packsRootProvider.future), fetcher: ref.watch(packFetcherProvider)));

/// Packs on this phone. Refreshed after installs and removals.
final installedPacksProvider = FutureProvider<List<InstalledPack>>((ref) async {
  try {
    return await (await ref.watch(contentStoreProvider.future)).installed();
  } catch (e, st) {
    AppLogger.error('content.installed', e, st);
    return const [];
  }
});

/// The online list. Only fetched while the Content screen is open. No
/// automatic retries: a failure shows at once, with a Retry button.
final packManifestProvider = FutureProvider.autoDispose<List<PackInfo>>(
    (ref) async => (await ref.watch(contentStoreProvider.future)).fetchManifest(),
    retry: (_, _) => null);

const _wifiKey = 'content.wifiOnly';

/// Download over Wi-Fi only (on by default; a device setting, not backed up).
final wifiOnlyProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.appSettingsEntries)..where((t) => t.key.equals(_wifiKey)))
      .watchSingleOrNull()
      .map((r) => r?.value != 'false');
});

Future<void> setWifiOnly(AppDatabase db, bool on) =>
    db.into(db.appSettingsEntries).insertOnConflictUpdate(AppSettingsEntriesCompanion(
        key: const Value(_wifiKey),
        value: Value('$on'),
        updatedAt: Value(DateTime.now().toUtc().millisecondsSinceEpoch)));

/// Exercises and programs from installed packs, plus where their media is.
class PackCatalog {
  const PackCatalog({this.exercises = const [], this.programs = const [], this.root});
  final List<LibraryExercise> exercises;
  final List<WorkoutProgram> programs;
  final String? root;

  /// Local file for an `images` entry, if its pack is installed.
  File? media(String ref) {
    if (root == null) return null;
    final f = File('$root/$ref');
    return f.existsSync() ? f : null;
  }
}

final packCatalogProvider = FutureProvider<PackCatalog>((ref) async {
  final packs = await ref.watch(installedPacksProvider.future);
  if (packs.isEmpty) return const PackCatalog();
  final root = await ref.watch(packsRootProvider.future);
  final dirs = [
    for (final p in packs)
      if (p.info.kind == 'exercises') (p.info.id, p.dir)
  ];
  final raw = await _readPacks(dirs);
  final exercises = <LibraryExercise>[];
  final programs = <WorkoutProgram>[];
  for (final (id, text) in raw) {
    try {
      final j = jsonDecode(text) as Map<String, dynamic>;
      for (final e in j['exercises'] as List? ?? const []) {
        exercises.add(LibraryExercise.fromJson(e as Map<String, dynamic>, pack: id));
      }
      for (final p in j['programs'] as List? ?? const []) {
        programs.add(WorkoutProgram.fromJson(p as Map<String, dynamic>, pack: id));
      }
    } catch (e, st) {
      AppLogger.error('content.parse.$id', e, st);
    }
  }
  return PackCatalog(exercises: exercises, programs: programs, root: root);
});

/// Large packs are read off the UI thread; only plain data crosses over.
Future<List<(String, String)>> _readPacks(List<(String, String)> dirs) => Isolate.run(() => [
      for (final (id, dir) in dirs)
        if (File('$dir/pack.json').existsSync()) (id, File('$dir/pack.json').readAsStringSync()),
    ]);

final _builtInExercisesProvider = FutureProvider<List<LibraryExercise>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/exercises.json', cache: false);
  return [for (final e in jsonDecode(raw) as List) LibraryExercise.fromJson(e as Map<String, dynamic>)];
});

final _builtInProgramsProvider = FutureProvider<List<WorkoutProgram>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/programs.json', cache: false);
  return [for (final p in jsonDecode(raw) as List) WorkoutProgram.fromJson(p as Map<String, dynamic>)];
});

/// Packs merge in once they're read; built-in content never waits for them.
PackCatalog _packsOrEmpty(Ref ref) => ref.watch(packCatalogProvider).value ?? const PackCatalog();

/// Built-in exercises first, then everything from installed packs.
final exerciseCatalogProvider = FutureProvider<List<LibraryExercise>>((ref) async {
  final builtIn = await ref.watch(_builtInExercisesProvider.future);
  final packs = _packsOrEmpty(ref);
  final ids = {for (final e in builtIn) e.id};
  return [...builtIn, ...packs.exercises.where((e) => !ids.contains(e.id))];
});

/// Programs whose exercises are all available on this phone.
final programCatalogProvider = FutureProvider<List<WorkoutProgram>>((ref) async {
  final builtIn = await ref.watch(_builtInProgramsProvider.future);
  final packs = _packsOrEmpty(ref);
  final known = {for (final e in await ref.watch(exerciseCatalogProvider.future)) e.id};
  return [
    for (final p in [...builtIn, ...packs.programs])
      if (p.steps.every((s) => known.contains(s.exercise))) p,
  ];
});

/// Media lookup for exercise pictures (null-safe in tests).
final packMediaProvider = Provider<PackCatalog>(
    (ref) => ref.watch(packCatalogProvider).value ?? const PackCatalog());
