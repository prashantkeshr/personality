import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/security/app_lock.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/insights_engine.dart';
import '../../app/router.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/format/clock_format.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/health.dart';
import '../about/about_personality_screen.dart';
import '../content/content_providers.dart';
import '../health/body_providers.dart';
import '../insights/insights_providers.dart';
import '../journey/journey_providers.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';
import '../routines/reminder_sync_host.dart' show formatMinute;
import '../today/today_providers.dart';

/// The Android home-screen widget, through `personality/widget`.
abstract interface class HomeWidgetBridge {
  Future<void> update(Map<String, Object?> data);

  /// A pending tap from the widget ("add_water"), taken once.
  Future<String?> takeAction();
}

class PlatformHomeWidgetBridge implements HomeWidgetBridge {
  const PlatformHomeWidgetBridge();
  static const _ch = MethodChannel('personality/widget');

  @override
  Future<void> update(Map<String, Object?> data) async {
    try {
      await _ch.invokeMethod('update', data);
    } on MissingPluginException {
      // No widget support on this platform.
    }
  }

  @override
  Future<String?> takeAction() async {
    try {
      return await _ch.invokeMethod<String>('takeAction');
    } on MissingPluginException {
      return null;
    }
  }
}

/// Does nothing (tests, other platforms).
class NoHomeWidgetBridge implements HomeWidgetBridge {
  const NoHomeWidgetBridge();
  @override
  Future<void> update(Map<String, Object?> data) async {}
  @override
  Future<String?> takeAction() async => null;
}

final homeWidgetBridgeProvider = Provider<HomeWidgetBridge>(
  (ref) => const PlatformHomeWidgetBridge(),
);

/// One glass, as added from the widget.
const widgetGlassMl = 250;

/// Keeps the widget current and handles its "+ glass" button.
class HomeWidgetHost extends ConsumerStatefulWidget {
  const HomeWidgetHost({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<HomeWidgetHost> createState() => _HomeWidgetHostState();
}

class _HomeWidgetHostState extends ConsumerState<HomeWidgetHost> {
  late final AppLifecycleListener _life;
  Timer? _debounce;
  String? _last;

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(
      onResume: () {
        _takeAction();
        _schedule();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takeAction();
      _schedule();
    });
  }

  @override
  void dispose() {
    _life.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _push);
  }

  Future<void> _takeAction() async {
    try {
      final action = await ref.read(homeWidgetBridgeProvider).takeAction();
      // A tap on the growth, exercise or weight widget opens that screen.
      if (action != null && action.startsWith('route:')) {
        ref.read(routerProvider).go(action.substring('route:'.length));
        return;
      }
      // "Tick" on the habits widget: done today, or undone if it was.
      if (action != null && action.startsWith('habit:')) {
        final id = action.substring('habit:'.length);
        final today = Days.key(ref.read(clockProvider)());
        final done = (ref.read(habitCompletionsProvider).value ?? const [])
            .any((c) => c.habitId == id && c.dayKey == today &&
                c.status == HabitStatus.completed);
        await ref.read(habitRepositoryProvider).setStatus(
              id,
              today,
              done ? null : HabitStatus.completed,
            );
        ref.read(routerProvider).go(AppRoutes.habits);
        return;
      }
      // "add_water" (the Today widget) or "add_water:<ml>" (the water widget).
      if (action == null || !action.startsWith('add_water')) return;
      final ml = int.tryParse(action.split(':').skip(1).firstOrNull ?? '') ??
          widgetGlassMl;
      await ref
          .read(waterRepositoryProvider)
          .add(
            Measurement(
              value: ml.toDouble(),
              unit: 'ml',
              source: DataSource.userEntered,
              recordedAt: ref.read(clockProvider)().toUtc(),
            ),
          );
    } catch (e, st) {
      AppLogger.error('widget.action', e, st);
    }
  }

  Future<void> _push() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final fmt = HealthFormat.of(
      context,
      ref.read(settingsControllerProvider).unitSystem,
    );
    final summary = ref.read(todaySummaryProvider);
    final lock = ref.read(appLockProvider);
    final agenda = ref.read(
      agendaProvider(Days.key(ref.read(clockProvider)())),
    );
    final next = agenda?.next;
    final target = summary.targets.waterMl;
    final data = <String, Object?>{
      'waterLabel': l10n.featureWater,
      'waterText':
          '${fmt.water(summary.waterMl.toDouble())} / ${fmt.water(target.toDouble())}',
      'waterPercent': target <= 0
          ? 0
          : (summary.waterMl * 100 ~/ target).clamp(0, 100),
      'nextLabel': l10n.widgetNext,
      // With app lock on, nothing personal shows on the home screen.
      'nextText': lock.enabled
          ? l10n.widgetLocked
          : (next?.plan != null && next!.minute != null
                ? '${next.title ?? ''} · ${formatMinute(context, next.minute!)}'
                : l10n.widgetNothingNext),
      'addLabel': l10n.widgetAddGlass,
      'locked': lock.enabled,
      'lockedText': l10n.widgetLocked,
      ..._insights(l10n, summary),
      ..._daily(l10n, summary, fmt),
    };
    final key = data.toString();
    if (key == _last) return;
    _last = key;
    await ref.read(homeWidgetBridgeProvider).update(data);
  }

  /// Data for the growth, exercise and weight widgets: ready-made text and
  /// chart values, so the widgets never read the encrypted database.
  Map<String, Object?> _insights(AppLocalizations l10n, TodaySummary today) {
    final locale = Localizations.localeOf(context).toString();
    MetricSeries week(InsightMetric m) =>
        ref.read(insightSeriesProvider((m, InsightRange.week)));
    final plan = week(InsightMetric.plan).days;
    final activity = week(InsightMetric.activity).days;
    final days = [
      for (final d in plan) shortWeekday(locale, Days.fromKey(d.dayKey)),
    ].join('|');
    String series(Iterable<double> v) =>
        v.map((x) => x.toStringAsFixed(3)).join(',');

    // Growth: level, progress to the next one, streak, plan done per day.
    final progress = ref.read(progressSummaryProvider);
    final level = progress?.level;
    // Exercise: today's active minutes against the target, and the week.
    final target = today.targets.activeMinutes;
    final done = today.activeMinutes;
    final percent = target <= 0 ? 0 : (done * 100 ~/ target).clamp(0, 100);
    final weekMinutes = activity.fold<double>(0, (s, d) => s + (d.value ?? 0));
    // Weight: the latest weigh-ins, oldest first.
    final format = BodyFormat.of(
      context,
      ref.read(settingsControllerProvider).unitSystem,
    );
    final weights = (ref.read(weightRecordsProvider).value ?? const [])
        .take(30)
        .toList()
        .reversed
        .toList();

    return {
      'days': days,
      'g_title': l10n.widgetGrowthTitle,
      'g_level': level == null ? '—' : l10n.widgetLevel(level.level),
      'g_progress': level == null ? 0 : (level.progress * 100).round(),
      'g_xp': level == null
          ? ''
          : l10n.widgetXpToNext(
              level.xpForNext - level.xpInLevel,
              level.level + 1,
            ),
      'g_streak': progress == null || progress.streak.current == 0
          ? ''
          : '🔥 ${progress.streak.current}',
      'g_chartLabel': l10n.widgetPlanWeek,
      'g_week': series(plan.map((d) => d.value ?? 0)),
      'e_title': l10n.featureExercise,
      'e_value': l10n.widgetMinutesOf(done, target),
      'e_percent': percent,
      'e_percent_text': '$percent%',
      'e_week_text': l10n.widgetWeekMinutes(weekMinutes.round()),
      'e_start': l10n.widgetStart,
      'e_bars': series(
        activity.map(
          (d) => target <= 0 ? 0 : ((d.value ?? 0) / target).clamp(0, 1),
        ),
      ),
      'w_title': l10n.featureWeight,
      'w_value': weights.isEmpty ? '—' : format.weight(weights.last.value),
      'w_change': weights.length < 2
          ? l10n.widgetLogWeight
          : l10n.widgetSinceStart(
              format.weightChange(weights.last.value - weights.first.value),
            ),
      'w_values': series(weights.map((w) => w.value)),
    };
  }

  /// Data for the water, sleep, snapshot and habits widgets.
  Map<String, Object?> _daily(
    AppLocalizations l10n,
    TodaySummary today,
    HealthFormat fmt,
  ) {
    final now = ref.read(clockProvider)();
    final todayKey = Days.key(now);
    final lang = Localizations.localeOf(context).languageCode;

    // Water: the bottle fills toward the daily target.
    final waterTarget = today.targets.waterMl;
    final waterPct = waterTarget <= 0
        ? 0
        : (today.waterMl * 100 ~/ waterTarget).clamp(0, 100);

    // Sleep: last night against the target, and the week.
    final sleepTarget = today.targets.sleepMinutes / 60;
    final sleepWeek = ref
        .read(insightSeriesProvider((InsightMetric.sleep, InsightRange.week)))
        .days;

    // Snapshot: the top area to improve and a different exercise each day.
    final snap = ref.read(personalSnapshotProvider);
    final catalog = {
      for (final e
          in ref.read(exerciseCatalogProvider).value ??
              const <LibraryExercise>[])
        e.id: e,
    };
    final picks = [
      for (final s in snap.suggestions)
        if (catalog[s.exerciseId] case final e?) (s, e),
    ];
    final pick = picks.isEmpty ? null : picks[todayKey % picks.length];
    final focus = snap.improvements.firstOrNull;

    // Habits due today, up to four.
    final completions = ref.read(habitCompletionsProvider).value ?? const [];
    final due = [
      for (final h in ref.read(habitsProvider).value ?? const <Habit>[])
        if (!h.archived &&
            h.startDayKey <= todayKey &&
            h.schedule.includes(now.weekday))
          h,
    ];
    bool done(Habit h) => completions.any(
      (c) =>
          c.habitId == h.id &&
          c.dayKey == todayKey &&
          c.status == HabitStatus.completed,
    );
    final shown = due.take(4).toList();

    return {
      'wa_title': l10n.featureWater,
      'wa_value':
          '${fmt.water(today.waterMl.toDouble())} / ${fmt.water(waterTarget.toDouble())}',
      'wa_percent': waterPct,
      'wa_percent_text': l10n.widgetPercentOfGoal(waterPct),
      'wa_glass': '+ ${fmt.water(250)}',
      'wa_bottle': '+ ${fmt.water(500)}',
      'sl_title': l10n.featureSleep,
      'sl_value': today.lastSleep == null
          ? '—'
          : fmt.duration(today.lastSleep!),
      'sl_sub': l10n.widgetSleepGoal(sleepTarget.toStringAsFixed(1)),
      'sl_bars': sleepWeek
          .map(
            (d) => sleepTarget <= 0
                ? 0.0
                : ((d.value ?? 0) / sleepTarget).clamp(0.0, 1.0),
          )
          .map((x) => x.toStringAsFixed(3))
          .join(','),
      'sn_title': l10n.widgetFocusTitle,
      'sn_area': focus == null
          ? l10n.widgetFocusAllGood
          : snapshotAreaLabel(l10n, focus.area),
      'sn_tip': focus == null
          ? l10n.widgetFocusKeepGoing
          : improveTip(l10n, focus.area),
      'sn_ex_label': l10n.widgetTryToday,
      'sn_ex': pick == null ? '' : LibraryExercise.pick(pick.$2.name, lang),
      'sn_ex_reason': pick == null ? '' : snapshotReasonText(l10n, pick.$1.reason),
      'sn_ex_route': pick == null
          ? null
          : '${AppRoutes.exerciseLibrary}/${pick.$2.id}',
      'hb_title': l10n.featureHabits,
      'hb_summary': due.isEmpty
          ? ''
          : l10n.widgetHabitsDone(due.where(done).length, due.length),
      'hb_empty': l10n.widgetHabitsEmpty,
      'hb_n': shown.length,
      for (var i = 0; i < shown.length; i++) ...{
        'hb_${i}_id': shown[i].id,
        'hb_${i}_name': shown[i].name,
        'hb_${i}_done': done(shown[i]),
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(todaySummaryProvider, (_, _) => _schedule());
    ref.listen(habitsProvider, (_, _) => _schedule());
    ref.listen(habitCompletionsProvider, (_, _) => _schedule());
    ref.listen(personalSnapshotProvider, (_, _) => _schedule());
    ref.listen(progressSummaryProvider, (_, _) => _schedule());
    ref.listen(weightRecordsProvider, (_, _) => _schedule());
    ref.listen(appLockProvider, (_, _) => _schedule());
    ref.listen(
      agendaProvider(Days.key(ref.watch(clockProvider)())),
      (_, _) => _schedule(),
    );
    ref.listen(settingsControllerProvider, (_, _) => _schedule());
    return widget.child;
  }
}
