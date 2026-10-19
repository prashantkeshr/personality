import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/units/units.dart';
import '../../l10n/app_localizations.dart';
import 'app_settings.dart';

/// Supported UI languages, as language codes. Keep in sync with lib/l10n.
const supportedLanguageCodes = ['en', 'hi', 'es', 'pt', 'id', 'ar'];

Future<void> _save(
  BuildContext context,
  WidgetRef ref,
  AppSettings Function(AppSettings) change,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final message = AppLocalizations.of(context).settingsSaveError;
  try {
    await ref.read(settingsControllerProvider.notifier).update(change);
  } catch (e, st) {
    AppLogger.error('settings.save', e, st);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
  }
}

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(
      settingsControllerProvider.select((s) => s.themeMode),
    );
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.themeSystem),
          icon: const Icon(Icons.brightness_auto_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.themeLight),
          icon: const Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.themeDark),
          icon: const Icon(Icons.dark_mode_outlined),
        ),
      ],
      selected: {mode},
      showSelectedIcon: false,
      onSelectionChanged: (s) =>
          _save(context, ref, (c) => c.copyWith(themeMode: s.single)),
    );
  }
}

class UnitSystemSelector extends ConsumerWidget {
  const UnitSystemSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final units = ref.watch(
      settingsControllerProvider.select((s) => s.unitSystem),
    );
    return RadioGroup<UnitSystem>(
      groupValue: units,
      onChanged: (u) {
        if (u != null) _save(context, ref, (c) => c.copyWith(unitSystem: u));
      },
      child: Column(
        children: [
          RadioListTile(
            value: UnitSystem.metric,
            title: Text(l10n.unitsMetric),
          ),
          RadioListTile(
            value: UnitSystem.imperial,
            title: Text(l10n.unitsImperial),
          ),
        ],
      ),
    );
  }
}

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(
      settingsControllerProvider.select((s) => s.localeCode),
    );
    String name(String c) => switch (c) {
      'hi' => l10n.languageHindi,
      // Endonyms: each language is named in its own script.
      'es' => 'Español',
      'pt' => 'Português',
      'id' => 'Bahasa Indonesia',
      'ar' => 'العربية',
      _ => l10n.languageEnglish,
    };

    return RadioGroup<String?>(
      groupValue: code,
      onChanged: (c) =>
          _save(context, ref, (s) => s.copyWith(localeCode: () => c)),
      child: Column(
        children: [
          RadioListTile<String?>(value: null, title: Text(l10n.languageSystem)),
          for (final c in supportedLanguageCodes)
            RadioListTile<String?>(value: c, title: Text(name(c))),
        ],
      ),
    );
  }
}

class TimeFormatSelector extends ConsumerWidget {
  const TimeFormatSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final value = ref.watch(
      settingsControllerProvider.select((s) => s.use24Hour),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<int>(
        key: const Key('time-format'),
        segments: [
          ButtonSegment(value: 0, label: Text(l10n.timeFormatDevice)),
          ButtonSegment(value: 12, label: Text(l10n.timeFormat12)),
          ButtonSegment(value: 24, label: Text(l10n.timeFormat24)),
        ],
        selected: {value == null ? 0 : (value ? 24 : 12)},
        onSelectionChanged: (s) => _save(
          context,
          ref,
          (cur) => cur.copyWith(
            use24Hour: () => switch (s.first) {
              24 => true,
              12 => false,
              _ => null,
            },
          ),
        ),
      ),
    );
  }
}

String accentLabel(AppLocalizations l, AppAccent a) => switch (a) {
  AppAccent.teal => l.accentTeal,
  AppAccent.ocean => l.accentOcean,
  AppAccent.indigo => l.accentIndigo,
  AppAccent.purple => l.accentPurple,
  AppAccent.rose => l.accentRose,
  AppAccent.coral => l.accentCoral,
  AppAccent.amber => l.accentAmber,
  AppAccent.forest => l.accentForest,
};

/// Colour swatches; the whole app re-tints at once.
class AccentColorSelector extends ConsumerWidget {
  const AccentColorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final current = AppAccent.fromName(
      ref.watch(settingsControllerProvider.select((s) => s.accent)),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final a in AppAccent.values)
            Semantics(
              selected: a == current,
              button: true,
              label: accentLabel(l10n, a),
              child: Tooltip(
                message: accentLabel(l10n, a),
                child: InkWell(
                  key: Key('accent-${a.name}'),
                  customBorder: const CircleBorder(),
                  onTap: () =>
                      _save(context, ref, (c) => c.copyWith(accent: a.name)),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: a.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: a == current ? scheme.onSurface : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: a == current
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TextSizeSelector extends ConsumerWidget {
  const TextSizeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scale = ref.watch(
      settingsControllerProvider.select((s) => s.textScale),
    );
    // The phone's own size, times this app's choice.
    final base = MediaQuery.textScalerOf(context).scale(100) / 100;
    final labels = [
      l10n.textSizeSmall,
      l10n.textSizeDefault,
      l10n.textSizeLarge,
      l10n.textSizeLarger,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SegmentedButton<double>(
        key: const Key('text-size'),
        segments: [
          for (var i = 0; i < AppSettings.textScales.length; i++)
            ButtonSegment(
              value: AppSettings.textScales[i],
              // Each label is drawn at its own size, as a preview.
              label: Text(
                labels[i],
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                textScaler: TextScaler.linear(
                  base / scale * AppSettings.textScales[i],
                ),
              ),
            ),
        ],
        selected: {scale},
        showSelectedIcon: false,
        onSelectionChanged: (s) =>
            _save(context, ref, (c) => c.copyWith(textScale: s.single)),
      ),
    );
  }
}

class ReduceMotionSwitch extends ConsumerWidget {
  const ReduceMotionSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final on = ref.watch(
      settingsControllerProvider.select((s) => s.reduceMotion),
    );
    return SwitchListTile(
      key: const Key('reduce-motion'),
      secondary: const Icon(Icons.motion_photos_off_outlined),
      title: Text(l10n.settingsReduceMotion),
      subtitle: Text(l10n.settingsReduceMotionInfo),
      value: on,
      onChanged: (v) => _save(context, ref, (c) => c.copyWith(reduceMotion: v)),
    );
  }
}
