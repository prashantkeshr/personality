import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/services/health_stats.dart';
import 'package:personality/domain/services/progress_engine.dart';

int day(int offset) => Days.key(DateTime(2026, 10, 8).add(Duration(days: offset)));

DayActivity active(int offset) =>
    DayActivity(dayKey: day(offset), waterMl: 2000, habitsDone: 1); // 35 XP

void main() {
  group('XP and levels', () {
    test('XP comes from real actions, with sensible caps', () {
      expect(XpRules.forDay(DayActivity(dayKey: day(0))), 0);
      expect(XpRules.forDay(DayActivity(dayKey: day(0), waterMl: 500)), 5);
      expect(XpRules.forDay(DayActivity(dayKey: day(0), waterMl: 2000)), 25);
      // Logging ten meals doesn't farm XP.
      expect(XpRules.forDay(DayActivity(dayKey: day(0), meals: 10)), 15);
      expect(XpRules.forDay(DayActivity(dayKey: day(0), postureChecks: 5)), 50);
    });

    test('levels grow quadratically', () {
      expect(Level.fromXp(0).level, 1);
      expect(Level.fromXp(49).level, 1);
      expect(Level.fromXp(50).level, 2);
      expect(Level.fromXp(200).level, 3);
      final l = Level.fromXp(125); // level 2: 50..200
      expect((l.level, l.xpInLevel, l.xpForNext), (2, 75, 150));
      expect(l.progress, closeTo(0.5, 1e-9));
    });
  });

  group('streaks', () {
    test('consecutive active days; today pending does not break it', () {
      final xp = {for (var i = -3; i <= -1; i++) day(i): 30};
      final s = StreakRules.compute(xp, day(0));
      expect(s.current, 3);
      expect(s.days[day(0)], DayStatus.pending);
    });

    test('a missed day resets without a rest day', () {
      final xp = {day(-4): 30, day(-3): 30, day(-1): 30};
      final s = StreakRules.compute(xp, day(0));
      expect(s.days[day(-2)], DayStatus.missed);
      expect((s.current, s.best), (1, 2));
    });

    test('seven active days bank a rest day that protects the streak', () {
      final xp = {for (var i = -10; i <= -4; i++) day(i): 30, day(-2): 30, day(-1): 30};
      final s = StreakRules.compute(xp, day(0));
      expect(s.days[day(-3)], DayStatus.rested);
      expect(s.current, 10);
      expect(s.freezes, 0);
    });

    test('rest days are capped', () {
      final xp = {for (var i = -40; i <= -1; i++) day(i): 30};
      expect(StreakRules.compute(xp, day(0)).freezes, StreakRules.maxFreezes);
    });
  });

  group('quests', () {
    test('three stable quests per day, all achievable', () {
      const ctx = QuestContext(); // no plan, no habits, no wardrobe
      final a = QuestEngine.forDay(DayActivity(dayKey: day(0)), ctx);
      final b = QuestEngine.forDay(DayActivity(dayKey: day(0)), ctx);
      expect(a.map((q) => q.kind), b.map((q) => q.kind));
      expect(a, hasLength(3));
      expect(a.map((q) => q.kind).toSet(), hasLength(3));
      for (final q in a) {
        expect(q.kind, isNot(QuestKind.completePlan));
        expect(q.kind, isNot(QuestKind.allHabits));
        expect(q.kind, isNot(QuestKind.wearOutfit));
      }
    });

    test('goals steer quests over many days', () {
      var posture = 0;
      for (var i = 0; i < 60; i++) {
        final qs = QuestEngine.forDay(DayActivity(dayKey: day(i)),
            const QuestContext(goals: {GoalType.posture}));
        if (qs.any((q) => q.kind == QuestKind.postureCheck)) posture++;
      }
      expect(posture, greaterThan(30));
    });

    test('progress and bonus XP', () {
      final today = DayActivity(dayKey: day(0), waterMl: 2500, postureChecks: 1, meals: 2);
      const ctx = QuestContext();
      final quests = QuestEngine.forDay(today, ctx);
      final done = quests.where((q) => q.done).length;
      expect(QuestEngine.bonusXp(quests),
          done * Quest.xp + (done == 3 ? QuestEngine.allDoneBonus : 0));
    });
  });

  test('summary combines XP, quests, streak and badges', () {
    final history = [
      for (var i = -7; i <= -1; i++) active(i),
      DayActivity(dayKey: day(0), waterMl: 2100, postureChecks: 1, faceChecks: 1),
    ];
    final s = ProgressSummary.compute(
        history: history, todayKey: day(0), context: const QuestContext(), savedOutfits: 5);
    expect(s.streak.current, 8);
    expect(s.todayXp, greaterThanOrEqualTo(XpRules.forDay(history.last)));
    final earned = {for (final b in s.badges) if (b.earned) b.badge};
    expect(earned, containsAll([Award.firstSteps, Award.streak7, Award.hydrationHero,
        Award.faceExplorer, Award.stylist]));
    expect(earned, isNot(contains(Award.streak30)));
  });
}
