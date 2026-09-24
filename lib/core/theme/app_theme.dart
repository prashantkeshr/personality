import 'package:flutter/material.dart';

/// Spacing scale on a 4-pt grid (docs/DESIGN_SYSTEM.md).
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

abstract final class AppRadius {
  static const input = 8.0;
  static const button = 12.0;
  static const card = 16.0;
  static const sheet = 24.0;
}

/// Adaptive layout breakpoints (logical pixels).
abstract final class AppBreakpoints {
  static const rail = 600.0;
  static const expanded = 840.0;
}

abstract final class AppTheme {
  static const seed = Color(0xFF0F6E6E);

  static ThemeData light() => _build(Brightness.light, highContrast: false);
  static ThemeData dark() => _build(Brightness.dark, highContrast: false);
  static ThemeData highContrastLight() =>
      _build(Brightness.light, highContrast: true);
  static ThemeData highContrastDark() =>
      _build(Brightness.dark, highContrast: true);

  static ThemeData _build(Brightness brightness, {required bool highContrast}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text.copyWith(
        displaySmall: text.displaySmall?.copyWith(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontSize: 18,
          height: 26 / 18,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 15, height: 22 / 15),
        labelMedium: text.labelMedium?.copyWith(fontSize: 13, height: 18 / 13),
        bodySmall: text.bodySmall?.copyWith(fontSize: 12, height: 16 / 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: highContrast
              ? BorderSide(color: scheme.outline)
              : BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: scheme.outlineVariant),
      ),
    );
  }
}
