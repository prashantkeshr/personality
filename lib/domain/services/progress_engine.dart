/// Progress, XP, levels, streaks, daily quests and badges (spec §36–37).
///
/// Everything is *derived* from what the user actually did (water logged,
/// habits completed, posture checks …). Nothing is stored separately, so
/// progress can never drift from the real records or be double-counted.
/// The tone is encouraging: missing a day never removes earned XP, and a
/// banked rest day protects the streak.
library;

import 'dart:math' as math;

import '../entities/body.dart';
import 'health_stats.dart';

/// Everything that happened on one local day.
class DayActivity {
  const DayActivity({
    required this.dayKey,
    this.waterMl = 0,
    this.waterTargetMl = 2000,
    this.meals = 0,
    this.sleepLogged = false,
    this.workouts = 0,
    this.habitsDone = 0,
    this.habitsScheduled = 0,
    this.planDone = 0,
    this.postureChecks = 0,
    this.faceChecks = 0,
    this.snapshots = 0,
    this.outfitsSaved = 0,
    this.outfitsWorn = 0,
    this.weightLogged = false,
  });

  final int dayKey;
  final double waterMl;
  final int waterTargetMl;
  final int meals;
  final bool sleepLogged;
  final int workouts;
  final int habitsDone;
  final int habitsScheduled;
  final int planDone;
  final int postureChecks;
  final int faceChecks;
  final int snapshots;
  final int outfitsSaved;
  final int outfitsWorn;
  final bool weightLogged;

  bool get waterTargetMet => waterMl >= waterTargetMl;
}

abstract final class XpRules {
  /// A day with at least this much XP keeps the streak going.
  static const activeDayXp = 15;

  static int forDay(DayActivity d) {
    int capped(int n, int max, int each) => each * math.min(n, max);
    var xp = 0;
    if (d.waterMl > 0) xp += 5;
    if (d.waterTargetMet) xp += 20;
    if (d.sleepLogged) xp += 10;
    if (d.weightLogged) xp += 10;
    xp += capped(d.meals, 3, 5);
    xp += capped(d.workouts, 2, 15);
    xp += 10 * d.habitsDone;
    xp += 5 * d.planDone;
    xp += capped(d.postureChecks, 2, 25);
    xp += capped(d.faceChecks, 1, 20);
    xp += capped(d.snapshots, 3, 20);
    xp += capped(d.outfitsSaved, 3, 10);
    xp += capped(d.outfitsWorn, 1, 10);
    return xp;
  }
}

/// Level n starts at 50·(n−1)² XP: quick early levels, steadier later.
class Level {
  const Level(this.level, this.xpInLevel, this.xpForNext);

  final int level;
  final int xpInLevel;
  final int xpForNext;

  double get progress => xpForNext == 0 ? 0 : xpInLevel / xpForNext;

  static int startOf(int level) => 50 * (level - 1) * (level - 1);

  factory Level.fromXp(int xp) {
    final level = math.sqrt(xp / 50).floor() + 1;
    final start = startOf(level), next = startOf(level + 1);
    return Level(level, xp - start, next - start);
  }
}

enum DayStatus { active, rested, missed, pending }

class Streak {
  const Streak({
    required this.current,
    required this.best,
    required this.freezes,
    required this.days,
  });

  /// Consecutive active (or rested) days ending today or yesterday.
  final int current;
  final int best;

  /// Banked rest days available (max [StreakRules.maxFreezes]).
  final int freezes;

  /// Status of each day considered, oldest first.
  final Map<int, DayStatus> days;
}

abstract final class StreakRules {
  static const maxFreezes = 2;

  /// One rest day is earned for every 7 consecutive active days.
  static const earnEvery = 7;

  /// Walks days oldest → newest. Today without activity is "pending" and
  /// does not break the streak.
  static Streak compute(Map<int, int> xpByDay, int todayKey) {
    if (xpByDay.isEmpty) {
      return const Streak(current: 0, best: 0, freezes: 0, days: {});
    }
    final first = xpByDay.keys.reduce(math.min);
    final days = <int, DayStatus>{};
    var run = 0, best = 0, freezes = 0, sinceEarn = 0;
    for (var d = Days.fromKey(first);
        Days.key(d) <= todayKey;
        d = DateTime(d.year, d.month, d.day + 1)) {
      final k = Days.key(d);
      final active = (xpByDay[k] ?? 0) >= XpRules.activeDayXp;
      if (active) {
        days[k] = DayStatus.active;
        run++;
        sinceEarn++;
        if (sinceEarn >= earnEvery) {
          freezes = math.min(maxFreezes, freezes + 1);
          sinceEarn = 0;
        }
      } else if (k == todayKey) {
        days[k] = DayStatus.pending;
      } else if (run > 0 && freezes > 0) {
        days[k] = DayStatus.rested;
        freezes--;
        run++; // a rest day keeps the run alive
      } else {
        days[k] = DayStatus.missed;
        run = 0;
        sinceEarn = 0;
      }
      best = math.max(best, run);
    }
    return Streak(current: run, best: best, freezes: freezes, days: days);
  }
}

enum QuestKind {
  drinkTarget,
  logMeals,
  postureCheck,
  completePlan,
  allHabits,
  logSleep,
  workout,
  wearOutfit,
  snapshot,
  logWeight,
}

class Quest {
  const Quest(this.kind, this.target, this.progress);

  final QuestKind kind;
  final int target;
  final int progress;

  bool get done => progress >= target;
  static const xp = 15;
}

/// What the app knows exists, so quests are always achievable.
class QuestContext {
  const QuestContext({
    this.hasPlanToday = false,
    this.habitsToday = 0,
    this.wardrobeItems = 0,
    this.snapshotThisWeek = false,
    this.goals = const {},
  });

  final bool hasPlanToday;
  final int habitsToday;
  final int wardrobeItems;
  final bool snapshotThisWeek;
  final Set<GoalType> goals;
}

abstract final class QuestEngine {
  static const perDay = 3;
  static const allDoneBonus = 25;

  /// Three quests for the day, stable for that day, favouring the user's
  /// goals and never asking for something impossible.
  static List<Quest> forDay(DayActivity today, QuestContext ctx) {
    final weighted = <QuestKind, int>{
      QuestKind.drinkTarget: ctx.goals.contains(GoalType.hydration) ? 5 : 3,
      QuestKind.logMeals: 2,
      QuestKind.postureCheck: ctx.goals.contains(GoalType.posture) ? 5 : 2,
      QuestKind.logSleep: ctx.goals.contains(GoalType.sleep) ? 4 : 2,
      QuestKind.workout: ctx.goals.contains(GoalType.fitness) ||
              ctx.goals.contains(GoalType.flexibility)
          ? 5
          : 2,
      QuestKind.logWeight:
          ctx.goals.contains(GoalType.weightManagement) ? 4 : 1,
      if (ctx.hasPlanToday) QuestKind.completePlan: 4,
      if (ctx.habitsToday > 0)
        QuestKind.allHabits: ctx.goals.contains(GoalType.habits) ? 5 : 3,
      if (ctx.wardrobeItems >= 3)
        QuestKind.wearOutfit: ctx.goals.contains(GoalType.style) ? 4 : 2,
      if (!ctx.snapshotThisWeek)
        QuestKind.snapshot: ctx.goals.contains(GoalType.grooming) ? 3 : 1,
    };
    // Deterministic per day: same quests all day, different tomorrow.
    final rnd = math.Random(today.dayKey);
    final pool = weighted.entries.toList();
    final picked = <QuestKind>[];
    while (picked.length < perDay && pool.isNotEmpty) {
      final total = pool.fold(0, (s, e) => s + e.value);
      var r = rnd.nextInt(total);
      final i = pool.indexWhere((e) => (r -= e.value) < 0);
      picked.add(pool.removeAt(i).key);
    }
    return [for (final k in picked) _quest(k, today, ctx)];
  }

  static Quest _quest(QuestKind k, DayActivity d, QuestContext ctx) =>
      switch (k) {
        QuestKind.drinkTarget =>
          Quest(k, d.waterTargetMl, d.waterMl.round().clamp(0, d.waterTargetMl)),
        QuestKind.logMeals => Quest(k, 2, math.min(d.meals, 2)),
        QuestKind.postureCheck => Quest(k, 1, math.min(d.postureChecks, 1)),
        QuestKind.completePlan => Quest(k, 3, math.min(d.planDone, 3)),
        QuestKind.allHabits => Quest(
            k, ctx.habitsToday, math.min(d.habitsDone, ctx.habitsToday)),
        QuestKind.logSleep => Quest(k, 1, d.sleepLogged ? 1 : 0),
        QuestKind.workout => Quest(k, 1, math.min(d.workouts, 1)),
        QuestKind.wearOutfit => Quest(k, 1, math.min(d.outfitsWorn, 1)),
        QuestKind.snapshot => Quest(k, 1, math.min(d.snapshots, 1)),
        QuestKind.logWeight => Quest(k, 1, d.weightLogged ? 1 : 0),
      };

  static int bonusXp(List<Quest> quests) =>
      quests.where((q) => q.done).length * Quest.xp +
      (quests.isNotEmpty && quests.every((q) => q.done) ? allDoneBonus : 0);
}

enum Award {
  firstSteps,
  streak7,
  streak30,
  hydrationHero,
  postureRegular,
  faceExplorer,
  journeyKeeper,
  planner,
  habitHero,
  stylist,
  level5,
  level10,
}

class AwardProgress {
  const AwardProgress(this.badge, this.progress, this.target);

  final Award badge;
  final int progress;
  final int target;

  bool get earned => progress >= target;
}

abstract final class AwardRules {
  static List<AwardProgress> evaluate({
    required List<DayActivity> history,
    required Streak streak,
    required Level level,
    required int savedOutfits,
  }) {
    int sum(int Function(DayActivity d) f) =>
        history.fold(0, (s, d) => s + f(d));
    final anyXp = history.any((d) => XpRules.forDay(d) > 0) ? 1 : 0;
    return [
      AwardProgress(Award.firstSteps, anyXp, 1),
      AwardProgress(Award.streak7, streak.best, 7),
      AwardProgress(Award.streak30, streak.best, 30),
      AwardProgress(Award.hydrationHero, sum((d) => d.waterTargetMet ? 1 : 0), 7),
      AwardProgress(Award.postureRegular, sum((d) => d.postureChecks), 5),
      AwardProgress(Award.faceExplorer, sum((d) => d.faceChecks), 1),
      AwardProgress(Award.journeyKeeper, sum((d) => d.snapshots), 4),
      AwardProgress(Award.planner, sum((d) => d.planDone), 20),
      AwardProgress(Award.habitHero, sum((d) => d.habitsDone), 30),
      AwardProgress(Award.stylist, savedOutfits, 5),
      AwardProgress(Award.level5, level.level, 5),
      AwardProgress(Award.level10, level.level, 10),
    ];
  }
}

/// The full picture for the dashboard.
class ProgressSummary {
  const ProgressSummary({
    required this.totalXp,
    required this.todayXp,
    required this.level,
    required this.streak,
    required this.quests,
    required this.badges,
  });

  final int totalXp;
  final int todayXp;
  final Level level;
  final Streak streak;
  final List<Quest> quests;
  final List<AwardProgress> badges;

  static ProgressSummary compute({
    required List<DayActivity> history,
    required int todayKey,
    required QuestContext context,
    int savedOutfits = 0,
  }) {
    final today = history.firstWhere((d) => d.dayKey == todayKey,
        orElse: () => DayActivity(dayKey: todayKey));
    final quests = QuestEngine.forDay(today, context);
    final xpByDay = {for (final d in history) d.dayKey: XpRules.forDay(d)};
    // Quest bonuses count for today only (past quests are not re-derived).
    final todayXp = (xpByDay[todayKey] ?? 0) + QuestEngine.bonusXp(quests);
    xpByDay[todayKey] = todayXp;
    final total = xpByDay.values.fold(0, (a, b) => a + b);
    final level = Level.fromXp(total);
    final streak = StreakRules.compute(xpByDay, todayKey);
    return ProgressSummary(
      totalXp: total,
      todayXp: todayXp,
      level: level,
      streak: streak,
      quests: quests,
      badges: AwardRules.evaluate(
          history: history,
          streak: streak,
          level: level,
          savedOutfits: savedOutfits),
    );
  }
}
