# Phase Tracker

Each phase ends with: compile → analyze → test → run on the emulator → document → **owner approval** → next phase.

| Phase | Scope | Status |
|---|---|---|
| 0 Architecture | Architecture, data model, design system, core contracts (provenance, device tier, feature registry, pose + model-manager interfaces) | Done (approved) |
| 1 Foundation | Theme (light/dark/high contrast), localization (ARB, RTL-ready), GoRouter shell with 5 tabs, encrypted Drift database and migrations, secure key storage, units system, onboarding | Done (approved) |
| 2 Profile + Body | Profile, height system and history, weight, body measurements, proportions engine, goals | **Done — awaiting approval** |
| 3 Health | Water, meals, sleep, activity, exercise logging, habits | Planned |
| 4 Routines | Routine builder, reminders (local notifications), plan vs actual, adaptive reminder suggestions | Planned |
| 5 Camera | Camera, permissions, device capability probe, processing pipeline | Planned |
| 6 Posture | Pose model, landmarks, metrics, confidence, history, recommendations | Planned |
| 7 Exercise | Library (data-driven), animations, programs, progress, optional camera tracking | Planned |
| 8 Face + Grooming | Face geometry, hairstyle, grooming, eyewear | Planned |
| 9 Style | Proportion styling, height-aware clothing, color, accessories, outfit builder, wardrobe | Planned |
| 10 Context + Recs | Context engine, recommendation engine, Why-this, daily brief, evolution | Planned |
| 11 Optional AI | Model manager, AI router, local model, coach | Planned |
| 12 Health integrations | Health Connect (HealthKit when iOS is available) | Planned |
| 13 Backup | Encrypted export/restore | Planned |
| 14 Commerce | Affiliate architecture, labeling | Planned |
| 15 Subscriptions | RevenueCat | Planned |
| 16 Optimization | Battery, memory, ML, startup, accessibility | Planned |
| 17 QA + Release | Security, testing, store compliance | Planned |

## Phase 0 — completed 2026-09-24

- Toolchain: Flutter 3.47.5 / Dart 3.13.4, JDK 17, Android SDK 36, emulator `personality_pixel` (API 36). All installed in `C:\dev`.
- Project `com.dhurta.personality` (Android + iOS folders; iOS builds need macOS).
- Docs: `ARCHITECTURE.md`, `DATA_MODEL.md`, `DESIGN_SYSTEM.md`.
- Code contracts with tests:
  - `lib/domain/entities/provenance.dart`: `DataSource`, `Confidence`, `Measurement` (requires confidence for camera/AI values; estimate ranges)
  - `lib/core/device/device_tier.dart`: tier classification and processing policy
  - `lib/core/features/feature_registry.dart`: central feature states
  - `lib/ml/pose/pose_estimator.dart`: pose contract with explicit failure types and `UnavailablePoseEstimator`
  - `lib/ml/model_manager/model_descriptor.dart`: model manager contract
- Verification: `flutter analyze` reports no issues; `flutter test` passes 20/20; debug APK built and launched on the emulator.

## Phase 1 — completed 2026-09-24

- **Encrypted database**: Drift + SQLite3MultipleCiphers. The 256-bit key is created with `Random.secure()` and stored in `flutter_secure_storage` (Keystore). Startup fails closed if the cipher is missing or the key is wrong, and a stored key is never overwritten. Schema v1 (`app_settings`, `feature_flag`) is snapshotted in `drift_schemas/`.
- **Android backup**: `allowBackup=false` plus data-extraction rules, so personal data is never copied to Google cloud backup.
- **Settings**: theme (system/light/dark, plus automatic high contrast), units (metric/imperial), language (device/English/Hindi). Saved before the UI updates.
- **Localization**: ARB files for English and Hindi; no hard-coded UI strings; directional padding is RTL-ready.
- **Navigation**: GoRouter with an onboarding redirect; 5 tabs (Home, Health, Analyze, Coach, Style) that keep their own stacks; Settings as a secondary route. Bottom bar on phones, navigation rail at 600dp+, extended rail at 840dp+.
- **Onboarding**: welcome, privacy and preferences pages. Honors reduce motion.
- **Home**: date plus an honest empty state. Tabs list features with their real state from `FeatureRegistry` (currently all "Coming soon", shown disabled).
- **Units**: canonical metric storage and conversions (ft/in, lb, fl oz, miles).
- **Startup error screen**: shows no raw errors and offers Retry.
- **Logging**: event name plus error type only, never values.

Verification:
- `flutter analyze`: no issues. `flutter test`: 35/35 passed, including a real encryption test (wrong key and no key both fail, file header is not plaintext) and widget tests for onboarding, tabs, Hindi and the tablet rail.
- On the emulator (API 36): onboarding → Home works; the dark theme applies instantly; the app reopens on Home after a force-stop (persistence); switching to Hindi applies live; the on-device `personality.sqlite` has a random header and no plaintext setting keys.

Dev notes (Windows + OneDrive): OneDrive marks folders ReadOnly, which breaks `flutter gen-l10n` and `flutter test`. Fix it with `attrib -R "<project>\*" /S /D`.

## Phase 2 — completed 2026-09-25

- **Schema v2** adds `user_profile`, `goal`, `height_record`, `weight_record` and `body_measurement`, with a shared provenance block and `recorded_at` indexes. The v1 → v2 migration is non-destructive, covered by generated migration tests plus a data-integrity test using real settings rows, and verified on the emulator by upgrading a Phase 1 install in place.
- **Profile**: optional name, age range, activity level and goals.
- **Height system**:
  - The primary height is the pinned record; otherwise the latest manual one; otherwise the latest imported one. Camera estimates are never chosen automatically.
  - Full history with source and method; set a record as primary, or delete it with confirmation (deleting the pinned record clears the pin).
  - A note explains that normal daily variation (about 1–2 cm) is not growth.
- **Weight**: entries, history, Week/Month/3-month chart (entries plus 7-day moving average, optional goal band), trend change, goal range with neutral below/within/above wording.
- **Body measurements**: 9 standard types with how-to-measure help, custom measurements, and per-type history.
- **Proportions engine**: leg line (inseam ÷ height), shoulder breadth, chest-to-waist difference, hip-to-chest balance. Wording is neutral and there are no rankings. Results are CALCULATED, with confidence set by the weakest input, a list of the inputs used, and prompts for missing inputs.
- **Unit-aware input and display**: ft+in for height, lb, inches. Canonical metric storage. Range validation that catches typos without judging values.
- **Home** shows height and weight cards, or the spec's "Add your height…" empty state.
- All new strings are available in English and Hindi.

Verification:
- `flutter analyze`: no issues. `flutter test`: 60/60 pass (domain engines, repositories, migrations, and widget flows for height/imperial/weight/goal/proportions).
- Emulator: upgrade from Phase 1 kept onboarding and theme; added height 172 cm, weight 70.5 kg, and inseam/chest/waist; proportions showed "Balanced leg line" and "Moderate taper"; Home shows both metrics; no Flutter errors in logcat.

Dev note, widget tests with Drift: use `test/helpers/app_harness.dart`. Drift cancels streams with a zero-duration timer, so tests must pump after unmounting and before `db.close()`, or they deadlock.
