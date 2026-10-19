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
      if (action != 'add_water') return;
      await ref
          .read(waterRepositoryProvider)
          .add(
            Measurement(
              value: widgetGlassMl.toDouble(),
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

  @override
  Widget build(BuildContext context) {
    ref.listen(todaySummaryProvider, (_, _) => _schedule());
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
