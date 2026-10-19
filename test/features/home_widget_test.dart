import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/security/app_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/widget/home_widget_sync.dart';

import '../helpers/app_harness.dart';

class FakeWidget implements HomeWidgetBridge {
  FakeWidget([this.action]);
  String? action;
  final updates = <Map<String, Object?>>[];

  @override
  Future<String?> takeAction() async {
    final a = action;
    action = null;
    return a;
  }

  @override
  Future<void> update(Map<String, Object?> data) async => updates.add(data);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 17, 9);

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  testWidgets('the widget gets water and the next task; "+ glass" adds water', (tester) async {
    final widget = FakeWidget('add_water');
    final app = AppHarness(tester);
    await app.start(onboarded, widget: widget, overrides: [clockProvider.overrideWithValue(() => now)]);
    await wait(app, tester);
    final water = await app.run(() => BodyRecordRepository(app.db, app.db.waterLogs, unit: 'ml').watchAll().first);
    expect(water!.single.value, widgetGlassMl);
    final last = widget.updates.last;
    expect(last['waterText'], contains('250 ml'));
    expect(last['waterPercent'], greaterThan(0));
    expect(last['addLabel'], '+ Glass');
    expect(last['nextText'], isNot(contains('Unlock')));
    await app.dispose();
  });

  testWidgets('with app lock on, the widget hides the next task', (tester) async {
    final widget = FakeWidget();
    final app = AppHarness(tester);
    await app.run(() => PinVault(app.lockStore, iterations: 1000).setPin('2468'));
    await app.start(onboarded, widget: widget);
    await wait(app, tester);
    expect(widget.updates.last['nextText'], 'Unlock the app to see your next task');
    await app.dispose();
  });

  testWidgets('growth, exercise and weight widgets get text and chart data', (
    tester,
  ) async {
    final widget = FakeWidget();
    final app = AppHarness(tester);
    await app.run(() async {
      final w = BodyRecordRepository(
        app.db,
        app.db.weightRecords,
        unit: CanonicalUnits.mass,
      );
      for (final (v, ago) in [(75.0, 20), (74.0, 10), (73.2, 1)]) {
        await w.add(
          Measurement(
            value: v,
            unit: CanonicalUnits.mass,
            source: DataSource.userEntered,
            recordedAt: now.subtract(Duration(days: ago)).toUtc(),
          ),
        );
      }
    });
    await app.start(
      onboarded,
      widget: widget,
      overrides: [clockProvider.overrideWithValue(() => now)],
    );
    await wait(app, tester);
    final last = widget.updates.last;
    expect(last['locked'], isFalse);
    expect(last['g_level'], 'Level 1');
    expect((last['days'] as String).split('|'), hasLength(7));
    expect((last['g_week'] as String).split(','), hasLength(7));
    expect(last['e_value'], '0 / 30 min');
    expect(last['e_start'], 'Start');
    expect((last['e_bars'] as String).split(','), hasLength(7));
    expect(last['w_value'], '73.2 kg');
    expect(last['w_change'], '-1.8 kg since start');
    expect(last['w_values'], '75.000,74.000,73.200');
    await app.dispose();
  });

  testWidgets('a tap on the weight widget opens the weight screen', (
    tester,
  ) async {
    final widget = FakeWidget('route:/health/weight');
    final app = AppHarness(tester);
    await app.start(onboarded, widget: widget);
    await wait(app, tester);
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.byType(Scaffold).last));
    expect(router.state.uri.path, '/health/weight');
    await app.dispose();
  });
}
