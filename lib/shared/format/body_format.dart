import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/units/units.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/provenance.dart';
import '../../l10n/app_localizations.dart';

/// Locale- and unit-aware formatting of body values.
class BodyFormat {
  BodyFormat(this.l10n, this.system, Locale locale)
      : _tag = locale.toLanguageTag();

  factory BodyFormat.of(BuildContext context, UnitSystem system) => BodyFormat(
      AppLocalizations.of(context), system, Localizations.localeOf(context));

  final AppLocalizations l10n;
  final UnitSystem system;
  final String _tag;

  String _num(double v, int decimals) =>
      NumberFormat.decimalPatternDigits(locale: _tag, decimalDigits: decimals)
          .format(v);

  /// Height: "172 cm" or "5 ft 8 in".
  String height(double cm) {
    if (system == UnitSystem.metric) {
      return l10n.valueCm(_num(cm, cm == cm.roundToDouble() ? 0 : 1));
    }
    final fi = UnitConversions.cmToFeetInches(cm);
    return l10n.valueFtIn(fi.feet.toString(), fi.inches.toString());
  }

  /// Body measurement: "81.5 cm" or "32.1 in".
  String length(double cm) => system == UnitSystem.metric
      ? l10n.valueCm(_num(cm, 1))
      : l10n.valueIn(_num(UnitConversions.cmToInches(cm), 1));

  String weight(double kg) => system == UnitSystem.metric
      ? l10n.valueKg(_num(kg, 1))
      : l10n.valueLb(_num(UnitConversions.kgToPounds(kg), 1));

  /// Signed weight change, e.g. "+0.4 kg".
  String weightChange(double kg) {
    final v = system == UnitSystem.metric ? kg : UnitConversions.kgToPounds(kg);
    final s = '${v > 0 ? '+' : ''}${_num(v, 1)}';
    return system == UnitSystem.metric ? l10n.valueKg(s) : l10n.valueLb(s);
  }

  String date(DateTime d) => DateFormat.yMMMd(_tag).format(d.toLocal());

  String ratio(double r) => _num(r, 2);

  /// Numeric text for an input field in the user's unit.
  String weightInput(double kg) => (system == UnitSystem.metric
          ? kg
          : UnitConversions.kgToPounds(kg))
      .toStringAsFixed(1);
}

extension BodyLabels on AppLocalizations {
  String sourceLabel(DataSource s) => switch (s) {
        DataSource.userEntered => sourceUserEntered,
        DataSource.cameraDerived => sourceCameraDerived,
        DataSource.deviceDerived => sourceDeviceDerived,
        DataSource.healthPlatform => sourceHealthPlatform,
        DataSource.calculated => sourceCalculated,
        DataSource.imported => sourceImported,
        DataSource.aiGenerated => sourceAiGenerated,
      };

  String confidenceLabel(Confidence c) => switch (c) {
        Confidence.low => confidenceLow,
        Confidence.medium => confidenceMedium,
        Confidence.high => confidenceHigh,
      };

  String methodLabel(MeasurementMethod m) => switch (m) {
        MeasurementMethod.selfMeasured => methodSelfMeasured,
        MeasurementMethod.measuredByOther => methodMeasuredByOther,
        MeasurementMethod.professional => methodProfessional,
        MeasurementMethod.scale => methodScale,
        MeasurementMethod.estimated => methodEstimated,
      };

  String measurementName(BodyMeasurementType t, [String? customLabel]) =>
      switch (t) {
        BodyMeasurementType.shoulderWidth => mShoulderWidth,
        BodyMeasurementType.chest => mChest,
        BodyMeasurementType.waist => mWaist,
        BodyMeasurementType.hip => mHip,
        BodyMeasurementType.neck => mNeck,
        BodyMeasurementType.armLength => mArmLength,
        BodyMeasurementType.legLength => mLegLength,
        BodyMeasurementType.torsoLength => mTorsoLength,
        BodyMeasurementType.inseam => mInseam,
        BodyMeasurementType.custom => customLabel ?? measurementCustom,
      };

  String? measurementHelp(BodyMeasurementType t) => switch (t) {
        BodyMeasurementType.shoulderWidth => mShoulderWidthHelp,
        BodyMeasurementType.chest => mChestHelp,
        BodyMeasurementType.waist => mWaistHelp,
        BodyMeasurementType.hip => mHipHelp,
        BodyMeasurementType.neck => mNeckHelp,
        BodyMeasurementType.armLength => mArmLengthHelp,
        BodyMeasurementType.legLength => mLegLengthHelp,
        BodyMeasurementType.torsoLength => mTorsoLengthHelp,
        BodyMeasurementType.inseam => mInseamHelp,
        BodyMeasurementType.custom => null,
      };

  String ageRangeLabel(AgeRange a) => switch (a) {
        AgeRange.under18 => ageUnder18,
        AgeRange.from18to24 => age18to24,
        AgeRange.from25to34 => age25to34,
        AgeRange.from35to44 => age35to44,
        AgeRange.from45to54 => age45to54,
        AgeRange.from55to64 => age55to64,
        AgeRange.over65 => age65plus,
      };

  String activityLabel(ActivityLevel a) => switch (a) {
        ActivityLevel.sedentary => activitySedentary,
        ActivityLevel.light => activityLight,
        ActivityLevel.moderate => activityModerate,
        ActivityLevel.active => activityActive,
        ActivityLevel.veryActive => activityVeryActive,
      };

  String goalLabel(GoalType g) => switch (g) {
        GoalType.posture => goalPosture,
        GoalType.weightManagement => goalWeightManagement,
        GoalType.fitness => goalFitness,
        GoalType.flexibility => goalFlexibility,
        GoalType.hydration => goalHydration,
        GoalType.sleep => goalSleep,
        GoalType.habits => goalHabits,
        GoalType.style => goalStyle,
        GoalType.grooming => goalGrooming,
      };
}
