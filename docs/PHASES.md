# Phase Tracker

Each phase ends with: compile → analyze → test → run on the emulator → document → **owner approval** → next phase.

| Phase | Scope | Status |
|---|---|---|
| 0 Architecture | Architecture, data model, design system, core contracts (provenance, device tier, feature registry, pose + model-manager interfaces) | **Done — awaiting approval** |
| 1 Foundation | Theme (light/dark/high contrast), localization (ARB, RTL-ready), GoRouter shell with 5 tabs, encrypted Drift database and migrations, secure key storage, units system, onboarding | Planned |
| 2 Profile + Body | Profile, height system and history, weight, body measurements, proportions engine, goals | Planned |
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
- Verification: `flutter analyze` reports no issues; `flutter test` passes 20/20.
