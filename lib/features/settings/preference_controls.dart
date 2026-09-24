import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/units/units.dart';
import '../../l10n/app_localizations.dart';
import 'app_settings.dart';

/// Supported UI languages, as language codes. Keep in sync with lib/l10n.
const supportedLanguageCodes = ['en', 'hi'];

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
    final mode = ref.watch(settingsControllerProvider.select((s) => s.themeMode));
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
            value: ThemeMode.system,
            label: Text(l10n.themeSystem),
            icon: const Icon(Icons.brightness_auto_outlined)),
        ButtonSegment(
            value: ThemeMode.light,
            label: Text(l10n.themeLight),
            icon: const Icon(Icons.light_mode_outlined)),
        ButtonSegment(
            value: ThemeMode.dark,
            label: Text(l10n.themeDark),
            icon: const Icon(Icons.dark_mode_outlined)),
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
    final units =
        ref.watch(settingsControllerProvider.select((s) => s.unitSystem));
    return RadioGroup<UnitSystem>(
      groupValue: units,
      onChanged: (u) {
        if (u != null) _save(context, ref, (c) => c.copyWith(unitSystem: u));
      },
      child: Column(
        children: [
          RadioListTile(value: UnitSystem.metric, title: Text(l10n.unitsMetric)),
          RadioListTile(
              value: UnitSystem.imperial, title: Text(l10n.unitsImperial)),
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
    final code =
        ref.watch(settingsControllerProvider.select((s) => s.localeCode));
    String name(String c) => switch (c) {
          'hi' => l10n.languageHindi,
          _ => l10n.languageEnglish,
        };

    return RadioGroup<String?>(
      groupValue: code,
      onChanged: (c) => _save(context, ref, (s) => s.copyWith(localeCode: () => c)),
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
