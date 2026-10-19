import 'package:flutter/material.dart';

import '../../core/units/units.dart';

/// User-controlled application preferences.
@immutable
class AppSettings {
  const AppSettings({
    this.onboardingCompleted = false,
    this.unitSystem = UnitSystem.metric,
    this.themeMode = ThemeMode.system,
    this.localeCode,
    this.use24Hour,
    this.accent = 'teal',
    this.textScale = 1.0,
    this.reduceMotion = false,
  });

  /// Text size steps offered in Settings (multiplies the phone's own size).
  static const textScales = [0.9, 1.0, 1.15, 1.3];

  final bool onboardingCompleted;
  final UnitSystem unitSystem;
  final ThemeMode themeMode;

  /// Language code such as `en` or `hi`; null follows the device language.
  final String? localeCode;

  /// Clock style; null follows the device.
  final bool? use24Hour;

  /// [AppAccent] name; unknown names fall back to teal.
  final String accent;
  final double textScale;

  /// Turns off non-essential motion, on top of the phone's own setting.
  final bool reduceMotion;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);

  AppSettings copyWith({
    bool? onboardingCompleted,
    UnitSystem? unitSystem,
    ThemeMode? themeMode,
    String? Function()? localeCode,
    bool? Function()? use24Hour,
    String? accent,
    double? textScale,
    bool? reduceMotion,
  }) {
    return AppSettings(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      unitSystem: unitSystem ?? this.unitSystem,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode != null ? localeCode() : this.localeCode,
      use24Hour: use24Hour != null ? use24Hour() : this.use24Hour,
      accent: accent ?? this.accent,
      textScale: textScale ?? this.textScale,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.onboardingCompleted == onboardingCompleted &&
      other.unitSystem == unitSystem &&
      other.themeMode == themeMode &&
      other.localeCode == localeCode &&
      other.use24Hour == use24Hour &&
      other.accent == accent &&
      other.textScale == textScale &&
      other.reduceMotion == reduceMotion;

  @override
  int get hashCode => Object.hash(
    onboardingCompleted,
    unitSystem,
    themeMode,
    localeCode,
    use24Hour,
    accent,
    textScale,
    reduceMotion,
  );
}
