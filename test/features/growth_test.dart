import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/features/content/content_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  /// Pack files load on a background isolate, which needs real time to
  /// pass; pump in steps rather than waiting to settle.
  Future<void> settleIo(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('My Growth: blueprint with reasons, skills, search and menu', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await app.tapAndSettle(find.text('My Growth'));
    expect(find.text('Your blueprint'), findsOneWidget);
    expect(find.text('Pick your goals to shape your blueprint'), findsOneWidget);

    // Every area explains itself, then offers the next step.
    await app.tapAndSettle(find.byKey(const Key('area-hydration')));
    expect(find.text('Why am I seeing this?'), findsOneWidget);
    expect(find.textContaining('Enough water helps'), findsOneWidget);
    expect(find.textContaining('Set water reminders'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('why-action')));
    expect(find.text('Water'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Skills: Indian and world martial arts, each with its own card.
    await tester.scrollUntilVisible(find.byKey(const Key('see-all-skills')).hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.byKey(const Key('see-all-skills')));
    expect(find.text('Indian martial arts'), findsOneWidget);
    expect(find.text('Kalaripayattu'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('discipline-kalaripayattu')));
    expect(find.text('Kerala'), findsOneWidget);
    expect(find.text('Download the techniques'), findsOneWidget); // pack not installed
    await tester.scrollUntilVisible(find.text('Tips & tricks').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('Warm up hips and hamstrings'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // One search covers skills, tips and the exercise library.
    await app.tapAndSettle(find.byKey(const Key('growth-search')));
    await tester.enterText(find.byKey(const Key('search-field')), 'kalari');
    await tester.pumpAndSettle();
    expect(find.text('Martial arts'), findsOneWidget);
    expect(find.text('Tips & tricks'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('search-field')), 'squat');
    await tester.pumpAndSettle();
    expect(find.text('Bodyweight squat'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('search-field')), 'zzqx');
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing found'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Profile and settings live behind the avatar.
    await app.tapAndSettle(find.byKey(const Key('profile-menu')));
    await app.tapAndSettle(find.text('Settings').last);
    expect(find.text('Appearance'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('with the Indian pack installed, a discipline lists its techniques and drills',
      (tester) async {
    final zip = File('../personality-content/packs/indian-martial-arts/indian-martial-arts-1.zip');
    final manifest = File('../personality-content/manifest.json');
    if (!zip.existsSync() || !manifest.existsSync()) return; // content repo not checked out
    final root = Directory.systemTemp.createTempSync('packs');
    addTearDown(() => root.deleteSync(recursive: true));
    final dir = Directory('${root.path}/indian-martial-arts')..createSync();
    final pack = ZipDecoder().decodeBytes(zip.readAsBytesSync()).findFile('pack.json')!;
    File('${dir.path}/pack.json').writeAsBytesSync(pack.content as List<int>);
    final info = (jsonDecode(manifest.readAsStringSync())['packs'] as List)
        .firstWhere((p) => p['id'] == 'indian-martial-arts');
    File('${dir.path}/meta.json')
        .writeAsStringSync(jsonEncode({'info': info, 'installedAt': '2026-10-13T00:00:00Z'}));

    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [packsRootProvider.overrideWith((ref) async => root.path)]);
    await settleIo(app, tester);
    await tester.tap(find.text('My Growth'));
    await settleIo(app, tester);
    // Card navigation is covered above; open the discipline directly.
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push('/growth/skills/kushti');
    await settleIo(app, tester);
    expect(find.text('Kushti (Pehlwani)'), findsOneWidget);
    expect(find.text('Download the techniques'), findsNothing);
    expect(find.text('Dand (Hindu push-up)'), findsOneWidget);
    // Filter by kind.
    await tester.ensureVisible(find.text('Conditioning'));
    await tester.pump();
    await tester.tap(find.text('Conditioning'));
    await settleIo(app, tester);
    expect(find.text('Wrestling stance'), findsNothing);
    expect(find.text('Baithak (Hindu squat)'), findsOneWidget);
    final list = find.ancestor(of: find.text('Baithak (Hindu squat)'), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Akhara conditioning (Dand-Baithak)').hitTestable(), 200,
        scrollable: list);
    await tester.scrollUntilVisible(find.text('Baithak (Hindu squat)').hitTestable(), -200, scrollable: list);
    await tester.tap(find.text('Baithak (Hindu squat)'));
    await settleIo(app, tester);
    expect(find.text('1. Stand with feet hip-width, arms back.'), findsOneWidget);
    await app.dispose();
  });
}
