import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/features/backup/backup_nudge.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/whats_new/whats_new.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 26, 9);
  String iso(DateTime d) => d.toUtc().toIso8601String();

  group('backupNudgeFrom', () {
    test('due a week after the last backup', () {
      expect(backupNudgeFrom({'backup.last': iso(now.subtract(const Duration(days: 6)))}, now).due, isFalse);
      final n = backupNudgeFrom({'backup.last': iso(now.subtract(const Duration(days: 9)))}, now);
      expect(n.due, isTrue);
      expect(n.everBackedUp, isTrue);
      expect(n.daysSince(now), 9);
    });

    test('never backed up: counts from when the reminder started', () {
      expect(backupNudgeFrom({}, now).due, isFalse);
      final n = backupNudgeFrom({'backup.firstSeen': iso(now.subtract(const Duration(days: 7)))}, now);
      expect(n.due, isTrue);
      expect(n.everBackedUp, isFalse);
    });

    test('snoozed or turned off: not due', () {
      final old = iso(now.subtract(const Duration(days: 20)));
      expect(
          backupNudgeFrom({'backup.last': old, 'backup.snooze': iso(now.add(const Duration(days: 1)))}, now).due,
          isFalse);
      expect(
          backupNudgeFrom({'backup.last': old, 'backup.snooze': iso(now.subtract(const Duration(hours: 1)))}, now)
              .due,
          isTrue);
      expect(backupNudgeFrom({'backup.last': old, 'backup.weekly': '0'}, now).due, isFalse);
    });
  });

  testWidgets('Home reminds about a backup; Later hides it for a few days', (tester) async {
    final app = AppHarness(tester);
    await app.run(() => AppKv(app.db).put('backup.last', iso(now.subtract(const Duration(days: 9)))));
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    await app.reveal(find.byKey(const Key('backup-nudge')));
    expect(find.text('Time for a backup'), findsOneWidget);
    expect(find.textContaining('9 days ago'), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('backup-nudge-later')));
    expect(find.byKey(const Key('backup-nudge')), findsNothing);
    final snooze = await app.run(() => AppKv(app.db).get('backup.snooze'));
    expect(DateTime.parse(snooze!).difference(now.toUtc()).inDays, 3);

    // The reminder can be turned off on the Backup screen.
    await app.run(() => AppKv(app.db).put('backup.snooze', iso(now.subtract(const Duration(days: 1)))));
    await app.settle();
    await app.reveal(find.byKey(const Key('backup-nudge-go')));
    await app.tapAndSettle(find.byKey(const Key('backup-nudge-go')));
    expect(find.text('Weekly backup reminder'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('backup-weekly')));
    expect(await app.run(() => AppKv(app.db).get('backup.weekly')), '0');
    await tester.pageBack();
    await app.settle();
    expect(find.byKey(const Key('backup-nudge')), findsNothing);
    await app.dispose();
  });

  testWidgets('a new install starts counting instead of nagging at once', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    await app.settle();
    expect(find.byKey(const Key('backup-nudge')), findsNothing);
    expect(await app.run(() => AppKv(app.db).get('backup.firstSeen')), isNotNull);
    await app.dispose();
  });

  testWidgets("after an update, What's new shows once and links to each feature", (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded, whatsNew: true);
    await app.reveal(find.byKey(const Key('whats-new')));
    await app.tapAndSettle(find.byKey(const Key('whats-new')));
    expect(find.text("What's new"), findsOneWidget);
    expect(find.text('Build your own workout'), findsOneWidget);
    expect(find.text('Voice cues'), findsOneWidget);
    expect(await app.run(() => AppKv(app.db).get(whatsNewSeenKey)), '$whatsNewRelease');

    await app.tapAndSettle(find.text('Build your own workout'));
    expect(find.byKey(const Key('builder-name')), findsOneWidget);
    await tester.pageBack();
    await app.settle();
    await tester.pageBack();
    await app.settle();
    expect(find.byKey(const Key('whats-new')), findsNothing);
    await app.dispose();
  });

  testWidgets("What's new can be dismissed from Home", (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded, whatsNew: true);
    await app.reveal(find.byKey(const Key('whats-new-dismiss')));
    await app.tapAndSettle(find.byKey(const Key('whats-new-dismiss')));
    expect(find.byKey(const Key('whats-new')), findsNothing);
    await app.dispose();
  });
}
