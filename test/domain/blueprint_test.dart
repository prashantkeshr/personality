import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/discipline.dart';
import 'package:personality/domain/services/blueprint_engine.dart';
import 'package:personality/domain/services/insights_engine.dart';

MetricSeries week(InsightMetric m, int met, {int logged = 7}) => MetricSeries(m, [
      for (var i = 0; i < 7; i++)
        DayPoint(20261001 + i, i < logged ? 1 : null,
            i < met ? DayMark.met : (i < logged ? DayMark.missed : DayMark.noData)),
    ]);

void main() {
  test('no data is never shown as failure, and there is no overall score', () {
    final areas = Blueprint.compute(const BlueprintFacts());
    expect(areas.length, BlueprintArea.values.length);
    expect(areas.every((a) => a.progress == null && a.reason == BlueprintReason.noRecords), isTrue);
    expect(Blueprint.nextStep(areas), isNull); // nothing to nag about
  });

  test('focus areas come first, weakest first, and drive the next step', () {
    final areas = Blueprint.compute(BlueprintFacts(
      goals: {GoalType.hydration, GoalType.sleep, GoalType.posture},
      water: week(InsightMetric.water, 6),
      sleep: week(InsightMetric.sleep, 2),
      activity: week(InsightMetric.activity, 7),
    ));
    expect(areas.take(3).map((a) => a.area),
        [BlueprintArea.posture, BlueprintArea.sleep, BlueprintArea.hydration]);
    expect(areas.first.reason, BlueprintReason.yourGoal); // posture: chosen, nothing yet
    final sleep = areas[1];
    expect(sleep.metDays, 2);
    expect(sleep.reason, BlueprintReason.fallingBehind);
    expect(areas[2].reason, BlueprintReason.onTrack);
    // Fitness isn't a goal but has records: it's listed after the focus areas.
    expect(areas[3].area, BlueprintArea.fitness);
    expect(Blueprint.nextStep(areas)!.area, BlueprintArea.posture);
  });

  test('less frequent areas use sensible targets', () {
    final areas = {
      for (final a in Blueprint.compute(const BlueprintFacts(
        hasBodyPlan: true,
        weighIns14d: 2,
        everCheckedPosture: true,
        postureChecks14d: 2,
        wardrobeItems: 4,
        everPractisedSkill: true,
        skillSessions7d: 1,
      )))
        a.area: a
    };
    expect(areas[BlueprintArea.body]!.progress, 0.5); // 2 of 4 weigh-ins
    expect(areas[BlueprintArea.body]!.action, BlueprintAction.logWeight);
    expect(areas[BlueprintArea.posture]!.progress, 1.0); // one a week is enough
    expect(areas[BlueprintArea.style]!.action, BlueprintAction.addClothes);
    expect(areas[BlueprintArea.skills]!.progress, closeTo(1 / 3, 1e-9));
  });

  test('disciplines: Indian and world, bilingual, with real motions', () {
    final list = [
      for (final d in jsonDecode(File('assets/content/disciplines.json').readAsStringSync()) as List)
        Discipline.fromJson(d as Map<String, dynamic>),
    ];
    final motions = (jsonDecode(File('assets/content/motions.json').readAsStringSync()) as Map).keys.toSet();
    expect(list.where((d) => d.indian).map((d) => d.id),
        containsAll(['kalaripayattu', 'silambam', 'gatka', 'mardani_khel', 'thang_ta', 'kushti', 'musti_yuddha', 'lathi_khela']));
    expect(list.where((d) => !d.indian).length, greaterThanOrEqualTo(5));
    for (final d in list) {
      for (final m in [d.name, d.region, d.about, d.trains, d.safety, ...d.tips]) {
        expect(m.keys, containsAll(['en', 'hi']), reason: d.id);
      }
      expect(d.tips.length, greaterThanOrEqualTo(3), reason: d.id);
      expect(motions, contains(d.motion), reason: d.id);
      expect(['martial-arts', 'indian-martial-arts'], contains(d.pack));
    }
  });
}
