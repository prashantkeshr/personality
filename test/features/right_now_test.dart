import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/permissions/app_permissions.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

class FakePermissions implements AppPermissions {
  FakePermissions(this.granted);
  Set<AppPermission> granted;
  final asked = <AppPermission>[];

  @override
  Future<PermissionState> status() async => PermissionState(
    granted: {...granted},
    askable: {...AppPermission.values},
  );
  @override
  Future<bool> request(AppPermission p) async {
    asked.add(p);
    granted.add(p);
    return true;
  }

  @override
  Future<void> openSettings() async {}
}

WidgetTester tester_(AppHarness app) => app.tester;

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<AppHarness> start(
    WidgetTester tester,
    DateTime now, {
    AppPermissions? permissions,
  }) async {
    final app = AppHarness(tester);
    await app.start(
      onboarded,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        if (permissions != null)
          appPermissionsProvider.overrideWithValue(permissions),
      ],
    );
    return app;
  }

  /// Scrolls Home down to the section, then the row sideways to [f].
  Future<void> reveal(AppHarness app, Finder f) async {
    final section = find.byKey(const Key('right-now'));
    await app.reveal(section);
    await tester_(app).dragUntilVisible(
      f,
      find.descendant(of: section, matching: find.byType(Scrollable)).first,
      const Offset(-200, 0),
    );
    await app.settle();
  }

  testWidgets('lunch at 1 pm; "not now" sets it aside for today', (
    tester,
  ) async {
    final app = await start(tester, DateTime(2026, 10, 19, 13));
    final lunch = find.byKey(const Key('now-lunch'));
    await reveal(app, lunch);
    expect(find.text('Lunch time'), findsWidgets);
    await app.tapAndSettle(find.byKey(const Key('now-later-lunch')));
    expect(lunch, findsNothing);
    await app.dispose();
  });

  testWidgets('a micro set is logged and the next one grows', (tester) async {
    // 19 Oct, afternoon half: a counted exercise (glute bridges).
    final app = await start(tester, DateTime(2026, 10, 19, 16));
    final card = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('now-micro:'),
    );
    await reveal(app, card);
    final key = (tester.widget(card).key as ValueKey<String>).value;
    final id = key.substring('now-micro:'.length);
    // Two sets earlier → one step up from the start.
    await app.run(() => AppKv(app.db).put('now.sets.$id', '2'));
    await app.settle();

    await app.tapAndSettle(find.byKey(Key('now-do-micro:$id')));
    final title = tester
        .widget<Text>(find.byKey(const Key('micro-title')))
        .data!;
    await app.tapAndSettle(find.byKey(const Key('micro-done')));

    expect(
      find.text('Set logged. Next time it grows a little.'),
      findsOneWidget,
    );
    expect(card, findsNothing); // done for today
    final count = await app.run(() => AppKv(app.db).get('now.sets.$id'));
    expect(count, '3');
    final sessions = await app.run(
      () => app.db.select(app.db.exerciseSessions).get(),
    );
    expect(sessions!.single.name, title);
    await app.dispose();
  });

  testWidgets('chosen skills come up in the evening', (tester) async {
    final app = await start(tester, DateTime(2026, 10, 19, 18));
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .push('/growth/skills/karate');
    await app.settle();
    await app.settle();
    final toggle = find.byKey(const Key('skill-practise'));
    await app.reveal(toggle);
    await app.tapAndSettle(toggle);
    await app.tapAndSettle(find.byTooltip('Back'));

    final skill = find.byKey(const Key('now-skill:karate'));
    await reveal(app, skill);
    expect(find.text('Practise Karate for 5 min'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('missing permissions: a card, "Later" for three days', (
    tester,
  ) async {
    final perms = FakePermissions({AppPermission.notifications});
    var now = DateTime(2026, 10, 19, 9);
    final app = AppHarness(tester);
    await app.start(
      onboarded,
      overrides: [
        clockProvider.overrideWith(
          (ref) =>
              () => now,
        ),
        appPermissionsProvider.overrideWithValue(perms),
      ],
    );
    final card = find.byKey(const Key('perm-nudge'));
    expect(card, findsOneWidget);
    expect(find.text('Camera · Physical activity'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('perm-later')));
    expect(card, findsNothing);
    final later = await app.run(() => AppKv(app.db).get(permissionNudgeKey));
    await app.dispose();

    // Three days later it asks again; Allow requests each missing one.
    now = now.add(const Duration(days: 3, minutes: 1));
    final again = AppHarness(tester);
    await again.run(() => AppKv(again.db).put(permissionNudgeKey, later!));
    await again.start(
      onboarded,
      overrides: [
        clockProvider.overrideWith(
          (ref) =>
              () => now,
        ),
        appPermissionsProvider.overrideWithValue(perms),
      ],
    );
    expect(card, findsOneWidget);
    await again.tapAndSettle(find.byKey(const Key('perm-nudge-allow')));
    expect(perms.asked, [AppPermission.camera, AppPermission.activity]);
    expect(card, findsNothing);
    await again.dispose();
  });

  testWidgets('a held exercise counts down and logs itself', (tester) async {
    // 19 Oct, morning half: the rotation lands on the plank.
    final app = await start(tester, DateTime(2026, 10, 19, 11));
    final card = find.byKey(const Key('now-micro:plank'));
    await reveal(app, card);
    await app.tapAndSettle(find.byKey(const Key('now-do-micro:plank')));
    expect(find.byKey(const Key('micro-done')), findsNothing);
    await tester.tap(find.byKey(const Key('micro-timer')));
    await tester.pump();
    expect(find.text('20s'), findsOneWidget); // the start for a new user
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('10s'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    await app.settle();
    expect(
      find.text('Set logged. Next time it grows a little.'),
      findsOneWidget,
    );
    final count = await app.run(() => AppKv(app.db).get('now.sets.plank'));
    expect(count, '1');
    await app.dispose();
  });
}
