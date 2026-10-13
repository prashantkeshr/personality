import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/content/content_packs.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/features/content/content_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../data/content_packs_test.dart' show FakeFetcher;
import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> openExercise(AppHarness app, WidgetTester tester) async {
    await app.tapAndSettle(find.text('Health'));
    await tester.scrollUntilVisible(find.text('Exercise').hitTestable(), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Exercise'));
  }

  testWidgets('play a guided workout to the end and it is logged', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openExercise(app, tester);
    await app.tapAndSettle(find.byTooltip('Guided workouts'));
    await app.tapAndSettle(find.text('Quick energy boost'));
    expect(find.text('Standing knee raises'), findsWidgets); // step list (first and last)
    // The player ticks every second, so it never settles: pump instead.
    await tester.tap(find.byKey(const Key('start-workout')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    String title() => tester.widget<Text>(find.byKey(const Key('segment-title'))).data!;
    String counter() => tester.widget<Text>(find.byKey(const Key('segment-counter'))).data!;
    expect(title(), 'Get ready');
    expect(counter(), '5');
    await tester.pump(const Duration(seconds: 1));
    expect(counter(), '4');
    await tester.pump(const Duration(seconds: 4));
    expect(title(), 'Standing knee raises');
    expect(counter(), '40');
    expect(find.textContaining('Up next: Bodyweight squat'), findsOneWidget);

    // Pausing stops the clock.
    await tester.tap(find.byKey(const Key('workout-pause')));
    await tester.pump(const Duration(seconds: 3));
    expect(counter(), '40');
    await tester.tap(find.byKey(const Key('workout-pause')));
    await tester.pump(const Duration(seconds: 2));
    expect(counter(), '38');

    // Skip through the rest.
    for (var i = 0; i < 20 && find.byKey(const Key('workout-skip')).evaluate().isNotEmpty; i++) {
      await tester.tap(find.byKey(const Key('workout-skip')));
      await tester.pump();
    }
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.text('Workout complete. Well done!'), findsOneWidget);
    final saved = await app.run(() => ExerciseRepository(app.db).watchSince(DateTime.utc(2020)).first);
    expect(saved!.single.name, 'Quick energy boost');
    expect(saved.single.category, ExerciseCategory.cardio);
    await app.tapAndSettle(find.byKey(const Key('workout-finish')));
    await app.dispose();
  });

  testWidgets('download a pack, then its exercises and workouts appear', (tester) async {
    final root = Directory.systemTemp.createTempSync('packs');
    addTearDown(() => root.deleteSync(recursive: true));
    final pack = utf8.encode(jsonEncode({
      'id': 'martial-arts',
      'exercises': [
        {
          'id': 'kf_horse_stance',
          'category': 'martialArts',
          'motion': 'horse_stance',
          'name': {'en': 'Horse stance', 'hi': 'हॉर्स स्टांस'},
          'steps': {'en': ['Sink down.'], 'hi': ['नीचे बैठें।']},
        }
      ],
      'programs': [
        {
          'id': 'stances',
          'category': 'martialArts',
          'title': {'en': 'Kung fu stances'},
          'summary': {'en': 'Legs.'},
          'steps': [
            {'exercise': 'kf_horse_stance', 'seconds': 30, 'rest': 0}
          ]
        }
      ],
    }));
    final archive = Archive()..addFile(ArchiveFile('pack.json', pack.length, pack));
    final bytes = Uint8List.fromList(ZipEncoder().encode(archive));
    final digest = (await Sha256().hash(bytes)).bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final info = {
      'id': 'martial-arts', 'version': 1, 'kind': 'exercises',
      'title': {'en': 'Martial arts drills'}, 'summary': {'en': 'Solo drills.'},
      'file': 'packs/martial-arts/martial-arts-1.zip', 'size': bytes.length, 'sha256': digest,
      'license': 'MIT', 'credit': 'Personality',
    };
    final fetcher = FakeFetcher({
      ContentSource.manifest.toString(): Uint8List.fromList(utf8.encode(jsonEncode({'schema': 1, 'packs': [info]}))),
      ContentSource.file(info['file'] as String).toString(): bytes,
    });
    var unmetered = false;

    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      packsRootProvider.overrideWith((ref) async => root.path),
      packFetcherProvider.overrideWithValue(fetcher),
      networkStateProvider.overrideWithValue(() async => NetworkState(online: true, unmetered: unmetered)),
    ]);
    Future<void> settleIo() async {
      for (var i = 0; i < 10; i++) {
        await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();
    }

    await openExercise(app, tester);
    await app.tapAndSettle(find.text('Exercise library'));
    await app.tapAndSettle(find.text('Get more exercises'));
    await settleIo();
    expect(find.text('Martial arts drills'), findsOneWidget);

    // Wi-Fi only (the default) blocks mobile data.
    await tester.tap(find.byKey(const Key('pack-download-martial-arts')));
    await settleIo();
    expect(find.textContaining('Connect to Wi-Fi'), findsOneWidget);
    unmetered = true;
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pack-download-martial-arts')));
    await settleIo();
    expect(find.text('On this phone'), findsOneWidget);

    // The library now includes the pack, with its own category filter.
    await tester.pageBack();
    await settleIo();
    await tester.enterText(find.byKey(const Key('exercise-search')), 'horse');
    await tester.pumpAndSettle();
    expect(find.text('Horse stance'), findsOneWidget);
    await app.tapAndSettle(find.text('Horse stance'));
    expect(find.text('1. Sink down.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byKey(const Key('open-workouts')));
    expect(find.text('Kung fu stances'), findsOneWidget);
    await app.dispose();
  });
}
