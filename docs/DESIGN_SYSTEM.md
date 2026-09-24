# Design System

Premium, calm, professional. No cartoon styling and no emoji in UI chrome.

## Foundations

| Token | Value |
|---|---|
| Typeface | Inter (UI), with the platform font as fallback. Tabular figures for metrics. |
| Type scale | Display 32/40 · Headline 24/32 · Title 18/26 · Body 15/22 · Label 13/18 · Caption 12/16 |
| Spacing | 4-pt grid: 4, 8, 12, 16, 24, 32, 48 |
| Radius | 8 (inputs), 12 (buttons), 16 (cards), 24 (sheets) |
| Elevation | Tonal surfaces (Material 3) instead of heavy shadows |
| Motion | 150–250 ms ease-out; disabled when the OS reduce-motion setting is on |
| Touch target | ≥ 48 × 48 dp |

## Color

Material 3 `ColorScheme.fromSeed` with a deep teal seed (`#0F6E6E`), in light and dark variants. Semantic tokens:

- `metricGood` / `metricWatch` / `metricNeutral` — never red for body metrics (no shame)
- Provenance chips: Measured, Estimated, Device, Calculated, AI. Each chip has an icon and a label, so meaning never depends on color alone.
- Minimum contrast 4.5:1 for text, plus a high-contrast theme option.

## Components (lib/shared)

`AppCard`, `MetricTile` (value, unit, target, provenance chip), `ProgressRing`, `SectionHeader`, `PrimaryButton` / `SecondaryButton`, `AppTextField` / `UnitField` (unit-aware input), `EmptyState`, `ErrorState`, `FeatureGate` (renders `FeatureState` messaging), `WhyThisSheet`, `ConfirmSheet`, `Toast`, and charts (line, bar and adherence) with accessible data tables.

## Adaptive layout

- < 600 dp: bottom navigation bar
- 600–840 dp: navigation rail
- > 840 dp: rail plus two-pane layouts (for example, list and detail)

## Copy rules

Neutral and factual: "You completed 3 of 5 planned routines", never judgmental. Estimates are always labeled as estimates. All strings go in ARB files.
