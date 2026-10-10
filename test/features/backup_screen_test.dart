import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/file_bridge.dart';
import 'package:personality/data/backup/backup_service.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/features/backup/backup_screen.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

class FakeFiles implements FileBridge {
  final saved = <String, Uint8List>{};
  Uint8List? toOpen;

  @override
  Future<bool> save(String name, String mime, Uint8List bytes) async {
    saved[name] = bytes;
    return true;
  }

  @override
  Future<Uint8List?> open() async => toOpen;

  @override
  Future<void> share(String name, String mime, Uint8List bytes) async => saved[name] = bytes;
}

void main() {
  final now = DateTime(2026, 10, 10, 9);

  testWidgets('make a backup, then restore it after the data is gone', (tester) async {
    final files = FakeFiles();
    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true), overrides: [
      clockProvider.overrideWithValue(() => now),
      fileBridgeProvider.overrideWithValue(files),
      backupServiceProvider
          .overrideWith((ref) => BackupService(app.db, clock: () => now, iterations: 1000)),
    ]);
    await app.run(() => SleepRepository(app.db, clock: () => now)
        .add(bedAt: DateTime(2026, 10, 9, 23), wakeAt: DateTime(2026, 10, 10, 7)));

    Future<void> work() async {
      // Encryption runs in another isolate: let real time pass.
      for (var i = 0; i < 15; i++) {
        await app.run(() => Future<void>.delayed(const Duration(milliseconds: 40)));
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    await tester.tap(find.byTooltip('Settings').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byKey(const Key('settings-backup')).hitTestable(), 150,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.byKey(const Key('settings-backup')));
    expect(find.text('No backup made on this phone yet'), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('backup-save')));
    await tester.enterText(find.byKey(const Key('passphrase')), 'short');
    await tester.enterText(find.byKey(const Key('passphrase-again')), 'short');
    await app.tapAndSettle(find.byKey(const Key('passphrase-ok')));
    expect(find.text('Use at least 8 characters'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('passphrase')), 'my long passphrase');
    await tester.enterText(find.byKey(const Key('passphrase-again')), 'my long passphrase');
    await tester.tap(find.byKey(const Key('passphrase-ok')));
    await work();
    expect(files.saved.keys, ['personality-2026-10-10.personality']);
    expect(find.textContaining('Last backup'), findsOneWidget);

    // Lose the data, then restore.
    await app.run(() => app.db.customStatement('DELETE FROM sleep_log'));
    files.toOpen = files.saved.values.single;
    await tester.tap(find.byKey(const Key('backup-restore')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('passphrase')), 'wrong passphrase');
    await tester.tap(find.byKey(const Key('passphrase-ok')));
    await work();
    expect(find.text('Wrong passphrase.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('backup-restore')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('passphrase')), 'my long passphrase');
    await tester.tap(find.byKey(const Key('passphrase-ok')));
    await work();
    expect(find.textContaining('Backup from'), findsOneWidget);
    await tester.tap(find.byKey(const Key('restore-merge')));
    await work();
    final nights = await app.run(
        () => SleepRepository(app.db).watchSince(DateTime(2026, 10, 1)).first);
    expect(nights, hasLength(1));
    expect(find.textContaining('Restored'), findsOneWidget);
    await app.dispose();
  });
}
