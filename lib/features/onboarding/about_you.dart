import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/units/units.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/provenance.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../health/body_providers.dart';

/// Answers from the onboarding "About you" page. Every field is optional.
class AboutYouData {
  final name = TextEditingController();
  final heightCm = TextEditingController();
  final heightFt = TextEditingController();
  final heightIn = TextEditingController();
  final weight = TextEditingController();
  Gender? gender;
  AgeRange? ageRange;
  ActivityLevel? activity;
  DietPreference? diet;
  Region? region;

  void dispose() {
    for (final c in [name, heightCm, heightFt, heightIn, weight]) {
      c.dispose();
    }
  }

  static double? _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  /// Height in cm, null when empty; throws [FormatException] when invalid.
  double? heightInCm(UnitSystem units) {
    double? cm;
    if (units == UnitSystem.metric) {
      if (heightCm.text.trim().isEmpty) return null;
      cm = _num(heightCm);
    } else {
      if (heightFt.text.trim().isEmpty && heightIn.text.trim().isEmpty) {
        return null;
      }
      final ft = heightFt.text.trim().isEmpty ? 0.0 : _num(heightFt);
      final inch = heightIn.text.trim().isEmpty ? 0.0 : _num(heightIn);
      if (ft != null && inch != null) {
        cm = UnitConversions.inchesToCm(ft * 12 + inch);
      }
    }
    if (cm == null || cm < BodyLimits.minHeightCm || cm > BodyLimits.maxHeightCm) {
      throw const FormatException('height');
    }
    return cm;
  }

  /// Weight in kg, null when empty; throws [FormatException] when invalid.
  double? weightInKg(UnitSystem units) {
    if (weight.text.trim().isEmpty) return null;
    final v = _num(weight);
    final kg = v == null
        ? null
        : units == UnitSystem.metric
            ? v
            : UnitConversions.poundsToKg(v);
    if (kg == null || kg < BodyLimits.minWeightKg || kg > BodyLimits.maxWeightKg) {
      throw const FormatException('weight');
    }
    return kg;
  }

  /// Validates, then stores the profile and any height/weight entered.
  /// Returns false (and stores nothing) when a number is invalid.
  Future<bool> save(WidgetRef ref, {DateTime? now}) async {
    final units = ref.read(settingsControllerProvider).unitSystem;
    final double? cm, kg;
    try {
      cm = heightInCm(units);
      kg = weightInKg(units);
    } on FormatException {
      return false;
    }
    final at = (now ?? DateTime.now()).toUtc();
    final profiles = ref.read(profileRepositoryProvider);
    final current = await profiles.load();
    await profiles.save(current.copyWith(
      displayName: () => name.text.trim().isEmpty ? null : name.text.trim(),
      gender: () => gender,
      ageRange: () => ageRange,
      activityLevel: () => activity,
      dietPreference: () => diet,
      region: () => region,
    ));
    if (cm != null) {
      await ref.read(heightRepositoryProvider).add(Measurement(
            value: cm,
            unit: CanonicalUnits.length,
            source: DataSource.userEntered,
            method: MeasurementMethod.selfMeasured.wireName,
            recordedAt: at,
          ));
    }
    if (kg != null) {
      await ref.read(weightRepositoryProvider).add(Measurement(
            value: kg,
            unit: CanonicalUnits.mass,
            source: DataSource.userEntered,
            method: MeasurementMethod.scale.wireName,
            recordedAt: at,
          ));
    }
    return true;
  }
}

class AboutYouPage extends ConsumerStatefulWidget {
  const AboutYouPage({super.key, required this.data});
  final AboutYouData data;

  @override
  ConsumerState<AboutYouPage> createState() => _AboutYouPageState();
}

class _AboutYouPageState extends ConsumerState<AboutYouPage> {
  AboutYouData get d => widget.data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final metric =
        ref.watch(settingsControllerProvider).unitSystem == UnitSystem.metric;
    final number = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    Widget label(String text) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
          child: Text(text, style: theme.textTheme.labelLarge),
        );
    Widget chips<T>(List<T> values, T? selected, String Function(T) name,
            void Function(T?) pick) =>
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final v in values)
              ChoiceChip(
                label: Text(name(v)),
                selected: selected == v,
                onSelected: (on) => setState(() => pick(on ? v : null)),
              ),
          ],
        );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Icon(Icons.person_outline, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.xl),
        Semantics(
          header: true,
          child: Text(l10n.onboardingAboutTitle, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.onboardingAboutBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          key: const Key('about-name'),
          controller: d.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.profileName),
        ),
        label(l10n.profileRegion),
        chips(Region.values, d.region, l10n.regionLabel, (v) => d.region = v),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.profileRegionHelp, style: theme.textTheme.bodySmall),
        label(l10n.profileGender),
        chips(Gender.values, d.gender, l10n.genderLabel, (v) => d.gender = v),
        label(l10n.profileAgeRange),
        chips(AgeRange.values, d.ageRange, l10n.ageRangeLabel, (v) => d.ageRange = v),
        const SizedBox(height: AppSpacing.xl),
        if (metric)
          TextField(
            key: const Key('about-height-cm'),
            controller: d.heightCm,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: number,
            decoration: InputDecoration(labelText: l10n.onboardingHeightCm),
          )
        else
          Row(children: [
            Expanded(
              child: TextField(
                key: const Key('about-height-ft'),
                controller: d.heightFt,
                keyboardType: TextInputType.number,
                inputFormatters: number,
                decoration: InputDecoration(labelText: l10n.onboardingHeightFt),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextField(
                key: const Key('about-height-in'),
                controller: d.heightIn,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: number,
                decoration: InputDecoration(labelText: l10n.onboardingHeightIn),
              ),
            ),
          ]),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          key: const Key('about-weight'),
          controller: d.weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: number,
          decoration: InputDecoration(
              labelText: metric ? l10n.onboardingWeightKg : l10n.onboardingWeightLb),
        ),
        label(l10n.profileActivityLevel),
        chips(ActivityLevel.values, d.activity, l10n.activityLabel, (v) => d.activity = v),
        label(l10n.profileDiet),
        chips(DietPreference.values, d.diet, l10n.dietLabel, (v) => d.diet = v),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
