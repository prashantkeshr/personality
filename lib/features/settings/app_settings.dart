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
  });

  final bool onboardingCompleted;
  final UnitSystem unitSystem;
  final ThemeMode themeMode;

  /// Language code such as `en` or `hi`; null follows the device language.
  final String? localeCode;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);

  AppSettings copyWith({
    bool? onboardingCompleted,
    UnitSystem? unitSystem,
    ThemeMode? themeMode,
    String? Function()? localeCode,
  }) {
    return AppSettings(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      unitSystem: unitSystem ?? this.unitSystem,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode != null ? localeCode() : this.localeCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.onboardingCompleted == onboardingCompleted &&
      other.unitSystem == unitSystem &&
      other.themeMode == themeMode &&
      other.localeCode == localeCode;

  @override
  int get hashCode =>
      Object.hash(onboardingCompleted, unitSystem, themeMode, localeCode);
}
