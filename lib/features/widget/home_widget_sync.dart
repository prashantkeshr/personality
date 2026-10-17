import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/security/app_lock.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/health_stats.dart';
import '../../l10n/app_localizations.dart';
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
    };
    final key = data.toString();
    if (key == _last) return;
    _last = key;
    await ref.read(homeWidgetBridgeProvider).update(data);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(todaySummaryProvider, (_, _) => _schedule());
    ref.listen(appLockProvider, (_, _) => _schedule());
    ref.listen(
      agendaProvider(Days.key(ref.watch(clockProvider)())),
      (_, _) => _schedule(),
    );
    ref.listen(settingsControllerProvider, (_, _) => _schedule());
    return widget.child;
  }
}
