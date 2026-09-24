# Personality — Architecture

Privacy-first, offline-first, AI-optional personal wellness and style OS.
Flutter + Dart. Android first (iOS later — requires macOS for builds).

## Principles (non-negotiable)

| Principle | Consequence in code |
|---|---|
| Privacy first | Camera frames are processed in memory and discarded. Nothing is uploaded by default. No sensitive data in logs. |
| Offline first | Every core feature reads/writes the local encrypted database. Network is only used by optional modules (backup, model download, commerce, subscriptions). |
| AI optional | Deterministic engines are the source of truth. The AI Coach only *explains*; the app is fully usable with no model installed. |
| No fake functionality | Unfinished features report `FeatureState.comingSoon` / `modelRequired` / `deviceRequired` through `FeatureRegistry`. No placeholder results. |
| Provenance | Every value carries `source`, `unit`, `timestamp`, and `confidence`/`method` when applicable (`Measurement`). |

## Layering

```
UI (features/*/presentation)        widgets, screens — no business logic
        │ Riverpod providers
Application (features/*/application) controllers, use cases
        │
Domain (lib/domain)                  entities, repository interfaces, pure engines
        │
Data (lib/data)                      Drift tables, DAOs, repository implementations, migrations
        │
Platform (lib/core, lib/ml)          secure storage, notifications, camera, device probe, ML runtimes
```

Rules:
- Domain has no Flutter or plugin imports; engines are pure Dart and unit-tested.
- Features depend on domain interfaces, never on another feature's internals.
- Every ML runtime is behind an interface (`PoseEstimator`, `ModelManager`) with an honest "unavailable" implementation.

## Three engines

1. **Measurement engine** — height, weight, body measurements, posture metrics, face geometry, activity. Sources: user, camera, device, health platform, import.
2. **Recommendation engine** — deterministic rules producing `Recommendation { what, why[], confidence, alternative, action }`. Consumes a `Context` snapshot (user, time, goals, history, wardrobe, climate, occasion).
3. **AI Coach (optional)** — local small model (0.5B–4B, quantized). Receives a minimal structured context, never the raw database. Cannot write measurements or change routines without user approval.

### AI router (Phase 11)

```
question → database lookup? → rule engine? → local AI (if installed)? → fallback text
```

## Camera / ML pipeline

```
camera frame (memory) → quality filter → pose/face landmarks → temporal smoothing
→ metrics → confidence → structured result → frame discarded
```

Failure outcomes are explicit types (`NoPersonDetected`, `LowQualityFrame`, `PoseUnavailable`) so the UI shows guidance instead of numbers.

## Device capability

`DeviceCapabilityProbe` → `DeviceSpecs` → `classifyDevice()` → `DeviceTier` → `ProcessingPolicy` (pose model variant, analysis FPS, camera resolution, local AI allowed, reduced effects). Unknown hardware is treated as LOW.

## Feature capability

`FeatureRegistry.stateOf(feature, CapabilityContext)` is the single place that decides AVAILABLE / BETA / COMING_SOON / DEVICE_REQUIRED / MODEL_REQUIRED / ONLINE_REQUIRED / PREMIUM.

## Security

- Database: SQLite via Drift, encrypted with SQLite3MultipleCiphers (`hooks.user_defines.sqlite3.source: sqlite3mc`, MIT, no OpenSSL). 256-bit random key generated on first launch, stored in platform secure storage (Android Keystore-backed), applied with `PRAGMA hexkey`. Startup fails closed if the cipher is missing. Android cloud backup and device transfer are disabled for app data.
- Backups: encrypted before leaving the device, user-chosen destination (Phase 13).
- Models: SHA-256 verified before install (`ModelDescriptor.sha256`).
- No secrets in source; store keys (RevenueCat) injected at build time.

## Folder structure

```
lib/
  core/        database, security, localization, permissions, device, features,
               notifications, networking, logging, errors, theme
  domain/      entities, repositories, services, use_cases
  data/        local, repositories, models, migrations
  ml/          pose, face, inference, model_manager, preprocessing
  features/    onboarding, dashboard, profile, health/{height,weight,measurements,
               water,meals,sleep,activity,integrations}, posture, camera, exercise,
               habits, routines, reminders, face, grooming, hairstyle,
               styling/{clothing,color,accessories,outfits,wardrobe},
               recommendations, progress, calendar, evolution, presence,
               communication, ai, backup, subscriptions, privacy, settings
  shared/      widgets, components, charts, animations
assets/content/  data-driven exercises, hairstyles, style rules (JSON)
```

Folders are created when their phase lands (git does not track empty folders).

## Navigation

Primary (bottom bar / rail on large screens): **Home · Health · Analyze · Coach · Style**.
Secondary (from Home/profile menu): Exercise, Progress, Calendar, History, Profile, Privacy, Backup, Settings.
GoRouter with `StatefulShellRoute` so each tab keeps its stack; deep links for reminders (`/health/water`, `/analyze/posture`, …).

## Key dependencies

| Package | Why |
|---|---|
| flutter_riverpod | State + dependency injection, testable overrides |
| go_router | Declarative routing, deep links for reminders |
| drift / drift_flutter | Typed SQLite, migrations, reactive queries |
| flutter_secure_storage | DB key and secrets in Keystore/Keychain |
| intl / flutter_localizations | i18n, RTL, number/date formats |
| uuid | Stable record ids for export/backup merge |

Later phases add: camera, MediaPipe/LiteRT runtime, local notifications, health (Health Connect), RevenueCat. Each is added only in the phase that needs it.
