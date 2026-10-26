# Phase Tracker

Each phase ends with: compile → analyze → test → run on the emulator → document → **owner approval** → next phase.

| Phase | Scope | Status |
|---|---|---|
| 0 Architecture | Architecture, data model, design system, core contracts (provenance, device tier, feature registry, pose + model-manager interfaces) | Done (approved) |
| 1 Foundation | Theme (light/dark/high contrast), localization (ARB, RTL-ready), GoRouter shell with 5 tabs, encrypted Drift database and migrations, secure key storage, units system, onboarding | Done (approved) |
| 2 Profile + Body | Profile, height system and history, weight, body measurements, proportions engine, goals | Done (approved) |
| 3 Health | Water, meals, sleep, activity, exercise logging, habits | Done (approved) |
| 4 Routines | Routine builder, reminders (local notifications), plan vs actual, adaptive reminder suggestions | Done (approved) |
| 5 Camera | Camera, permissions, device capability probe, processing pipeline | Done (approved) |
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

## Phase 3 — completed 2026-09-26

- **Schema v3** adds `water_log`, `meal`, `sleep_log`, `activity_log`, `exercise_session`, `habit` and `habit_completion`, with indexes. The v2 → v3 migration is non-destructive, with generated tests plus a data-integrity test using real Phase 2 profile and height rows. It was verified on the emulator by upgrading in place, and Phase 2 height and weight were kept.
- **Water**: progress ring against a target, quick add (250/500 ml, or 8/16 fl oz), a validated custom amount, a 7-day bar chart with a target line, and today's entries with delete.
- **Meals**: breakfast, lunch, snack, dinner or custom; food in your own words; optional quantity; calories optional; the meal type is suggested from the time of day; grouped by day.
- **Sleep**: bedtime and wake time (validated: wake after bed, at most 24 h), attributed to the wake day; last night against target; 7-night chart; bedtime consistency measured with circular statistics so bedtimes either side of midnight compare correctly; a wording note that makes no disorder claims.
- **Activity**: steps, duration and distance (km or mi) with a source label on every entry; steps and active minutes against targets; 7-day steps chart.
- **Exercise log**: name, category (spec §18 list), duration, sets and reps; weekly minutes. The guided library comes in Phase 7.
- **Habits**:
  - Weekday schedules, done or skip, undo, edit, archive or delete; completions are removed together with their habit.
  - Wording is neutral ("You completed 1 of 1 habits today", "3 of 5 this week").
  - Days before a habit was created never count as missed.
- **Daily targets**: water, sleep, steps and active minutes; editable, range-validated, and labelled as starting points rather than medical recommendations.
- **Home "Today"**: tiles for water, sleep, steps, active minutes, habits and meals, each against its target and linking to its screen, plus the Body section. It uses 2 columns, or 3 on wide screens.
- English and Hindi for all new strings, including plurals.

Bugs found by tests and fixed:
- The water custom dialog disposed its text controller while the dialog was still closing.
- Habit adherence counted days before the habit existed.
- The habit name was announced twice by screen readers.

Verification:
- `flutter analyze`: no issues. `flutter test`: 86/86 pass.
- Emulator: upgrade from Phase 2 kept all data; water 2 × 500 ml gave 1.0 L on the ring, the chart and Home; habit created and ticked gave "1 of 1" on the screen and on Home; no Flutter errors.

OneDrive note (2026-09-26): OneDrive restored stale Sep 24 copies of 7 files and renamed the current ones to `*-Shiva`. This was repaired from git (the pushed commits are the source of truth). Before every commit, check for `*-Shiva*` files.

## Phase 4 — completed 2026-09-30

- **Schema v4** adds `routine`, `routine_item` and `routine_completion`. The migration is non-destructive, with generated tests for every path from v1 to v4 plus a v3 → v4 data-integrity test that uses habits. It was verified on the emulator by upgrading in place.
- **Routine builder**: create, rename, choose days, pause, duplicate and delete routines; add, edit, duplicate and delete items (time, title, type, reminder on/off). A "Start from an example" option builds the spec §31 routine with localized titles.
- **Plan vs actual** (`PlanScreen`):
  - Today's items with upcoming / now / done / skipped / missed states, where "now" lasts 60 minutes after an item's time.
  - Actions: Done, Skip, Move to another time, Undo.
  - Summary counts for completed, skipped, missed, moved and remaining.
  - A 7-day adherence chart, kept separate from health performance (spec §34).
- **Reminders**:
  - Off by default. Notification permission is requested only when the user turns reminders on; if it is denied, a banner explains this and the plan keeps working.
  - Uses `flutter_local_notifications`, scheduled as absolute UTC instants over a rolling 7-day window. It re-syncs when the plan changes and when the app resumes.
  - Done and skipped items cancel their reminder for that day.
  - Scheduling is inexact, so no exact-alarm permission is needed; the app says reminders may arrive a few minutes late.
  - The Done action opens the app and records the outcome. Snooze reschedules in a background isolate without opening the database.
  - Notification taps deep-link to the plan.
- **Adaptive suggestions** (spec §33):
  - Uses the last 14 past days only, never today, and needs at least 4 scheduled days and at least 3 supporting occurrences.
  - Suggests either the time the user keeps moving the item to, the typical time it is actually done when done late, or one hour later when the item is usually missed.
  - Only changes anything when the user accepts. Dismissing hides the suggestion for 14 days.
  - Can be turned off. Home shows one suggestion; the plan screen shows all of them.
- **Home**: plan card ("Next: Posture break — 10:30 AM", "Completed x of y planned").
- English and Hindi for all new strings.

Bugs found by tests and fixed:
- Suggestions and "missed" counts included times before a routine item existed ("missed on 14 of the last 14 days" for a routine created minutes earlier). Items now count only from their creation instant.
- Home stacked many suggestion cards; it now shows one.
- Completing or skipping a moved item dropped the moved time (found on device). The moved time is now kept, so the plan and the suggestion evidence stay accurate.
- Test count: 115/115.
- Test harness: a failing widget test used to hang every later test. It now always unmounts and flushes Drift's timer in teardown (verified with a deliberate-failure probe).

Verification:
- `flutter analyze`: no issues. `flutter test`: 115/115 pass (plan engine, reminder planner, adaptive rules, repository, 9 migration tests, routine/reminder/suggestion widget flows).
- Emulator (API 36, software GPU — see note): the upgrade from Phase 3 worked. An example routine created at 09:28 showed 6 upcoming items and none falsely missed. Turning reminders on showed Android's permission prompt; after allowing, Android alarms were registered (the first one at 10:30 IST). Moving Posture break to 09:35 updated the plan ("moved from 10:30 AM"). The app was then sent to the background. **The real notification was posted at 09:37** (inexact, 2 min late) with the title, "Planned for 9:35 AM", and Done / Snooze 10 min. Tapping **Done** opened Today's plan with "Completed 1 of 6", and the notification was dismissed.

Emulator note: the emulator crashed inside the NVIDIA OpenGL driver (`nvoglv64.dll`) with host GPU rendering. Launch it with `-gpu swiftshader_indirect -memory 3072` (detached, via `Start-Process`).

## Phase 5 — completed 2026-10-05

- **Device capability probe** (spec §7): a native `personality/device` MethodChannel in `MainActivity` reads RAM, CPU cores, Android API level, free storage, Android's low-RAM flag and camera presence. It collects no identifiers and adds no extra dependency. Results feed `classifyDevice` → tier → `ProcessingPolicy` and the central `FeatureRegistry`. If the probe fails, the device is treated as unknown → low tier.
- **"This device" screen** (Settings): shows the detected hardware and the processing quality it selects.
- **Camera** (`camera` plugin / CameraX):
  - Behind a `CameraSource` interface, so screens and tests don't depend on the plugin.
  - Permission is requested only when you tap Start. If it's denied, the screen says "Camera access … Manual tracking remains available."
  - Devices without a camera get an honest "not supported" state.
  - Front/back switch; audio disabled.
- **Frame pipeline** (spec §16, §69): frame selection throttled to the power mode's rate (busy frames are dropped, never queued) → a real lighting/contrast check from the Y (brightness) plane → pose estimator only for usable frames → a `PipelineStatus` containing no image data. Frames are never copied, stored or uploaded.
- **Pose**: until the Phase 6 model ships, the pipeline reports "pose model required"; it never produces fabricated landmarks.
- **Camera power modes** (spec §68): Low power, Standard and High accuracy (5/10/15 analyses per second at 480p/720p/1080p), with explanations. The default follows the device tier; the choice is saved and applies immediately.
- **Privacy hardening**: the camera stops when you leave the screen or the app is hidden. Plugin-declared `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE` and the implied `READ_EXTERNAL_STORAGE` are removed. **The release APK has no INTERNET permission.** Its permissions are CAMERA, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, VIBRATE, plus `ACCESS_NETWORK_STATE`, a normal permission from androidx.media3 that I kept to avoid crashing that library; it reveals no personal data.

Bugs found and fixed:
- Changing the power mode restarted the camera with the old mode (a race with the saved setting). The new mode is now passed directly.
- Feature status chips overflowed list tiles on phone-width screens (a layout exception at 392 pt, worse with Hindi). They are now width-bounded and wrap.
- Over-bright frames were labelled "too dark"; quality issues now map to tooBright and lowContrast correctly.

Verification:
- `flutter analyze`: no issues. `flutter test`: 133/133 pass (frame quality on synthetic planes including row padding, sampler throttling and busy-drop, pipeline gating and fps, device rules, and camera screen flows with a fake camera on a phone-sized viewport).
- First release build compiled (67 MB) and its permissions were audited with aapt2.
- Emulator:
  - The camera permission prompt appeared only on Start. Real frames from the virtual camera gave "Good light" from measured brightness.
  - Leaving the screen made Android's CameraService log "Disconnected client for camera 1"; active camera clients: none.
  - "This device" showed 2.9 GB RAM (matching /proc/meminfo), 4 cores and API 36 → Basic tier, 5 analyses/s, 480p, and Low power as the default.

## Phase 6 — completed 2026-10-07

- **Pose model**: Google ML Kit BlazePose, bundled and on-device (no download). The accurate variant is used on high-tier devices. Landmarks are normalized to the upright image.
- **Posture engine** (pure Dart): head tilt, shoulder and hip level, torso lean and knee alignment (front view); head position and torso lean (side view).
  - Angles use real pixel proportions and handle mirrored selfie images.
  - Before measuring, each frame is checked for body out of frame, too far, too close, movement, an unclear view and low landmark visibility.
  - A capture is the median over 15 usable frames. Confidence comes from frame count, visibility and spread.
  - With insufficient evidence it returns no result and says "could not be reliably measured" with specific guidance.
- **Posture screen**: setup tips, a live skeleton overlay with a body guide and live guidance, and a 5-second countdown so you can step back after tapping Analyze. Results show bands, direction and confidence, labelled as a camera estimate. Save or Retake. Camera screens are locked to portrait.
- **History** (schema v5: `posture_session`, `posture_metric`, numbers only, never images): compares each check with the previous one of the same view; delete cascades.
- **Recommendations**: deterministic rules plus data-driven exercise content (9 gentle mobility exercises, English and Hindi, each with safety text). Each card has "Why this?", an alternative, and the safety note. Low-confidence results get no suggestions.
- **Privacy**: ML Kit's INTERNET permission is removed, so its telemetry upload can't reach the network. Release permissions: CAMERA, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, VIBRATE, plus library-declared ACCESS_NETWORK_STATE, WAKE_LOCK and FOREGROUND_SERVICE (WorkManager). The app has no INTERNET permission.

Bugs found on the physical phone (POCO X4 Pro 5G, Android 13 / HyperOS) and fixed:
- **Release crash at startup**: R8 stripped WorkManager's Room database. Fixed with keep rules in `proguard-rules.pro`.
- **Every frame failed analysis**: the device delivers 3-plane YUV_420_888 even when NV21 is requested. Frames are now converted to NV21 only when they reach the model (`yuv420ToNv21`, unit-tested with row/pixel strides).
- **Sideways preview when the phone rotated**: camera screens are now portrait-locked and capture orientation is locked.
- **The Analyze button was impossible to use alone** (it needed a usable frame while you stood at the phone): it is now always enabled, followed by a countdown.

Verification:
- `flutter analyze`: no issues. `flutter test`: 157/157 pass.
- On-device integration test (`integration_test/pose_device_test.dart`): ML Kit runs on the phone with NV21 frames.
- Real front-view check on the user's phone: hips 0.8°, torso 0.5°, knees 4.3°, all within typical range with high confidence. It was saved, and the camera was released afterwards (CameraService disconnect).

Device notes: Xiaomi needs "Install via USB" and "USB debugging (Security settings)" (applied only after a reboot) for installs and input. scrcpy v5.0 in C:\dev\scrcpy mirrors the phone (SHA-256 verified).

## Phase 7 — completed 2026-10-07

- **Exercise library** (`assets/content/exercises.json`): 14 exercises in English and Hindi, each with steps, dose and a safety note. 5 are camera-tracked. Filter: All / Camera-tracked. "Log as done" covers the rest.
- **Exercise tracker** (pure Dart, `exercise_tracker.dart`):
  - Squat, overhead arm raise and standing knee raise (alternating legs) count reps.
  - Plank and wall sit are timed holds.
  - Reps use joint angles with hysteresis, smoothing and a 600 ms minimum rep time, so jitter adds no reps. Partial movements aren't counted.
  - When joints aren't visible, tracking pauses instead of guessing.
- **Form cues**: go lower, knees in line with toes, chest up, raise higher, raise evenly, lift knee higher, keep body straight, get into position. All general guidance, never medical.
- **Tracking screen**: setup tips by view (front/side), lens choice, a 5-second countdown, a live counter or hold timer on the shared `CameraStage`, and auto-finish at the goal. The summary has save-to-log (source CAMERA_DERIVED) and retake. The camera is released on finish and when the app is hidden.
- **Exercise log** links to the library and shows camera-tracked sessions. The Analyze tab's "Exercise tracking" opens the camera-filtered library.

Bugs fixed:
- **Release builds couldn't recognize anyone**: R8 stripped ML Kit/MediaPipe classes that the native engine loads by name. Keep rules were added; the R8 `usage.txt` is now checked for removed ML Kit code. Verified on the user's phone that release posture analysis works.
- **"Log as done" dialog** disposed its controller while closing.
- **The uneven-arms cue** lagged behind smoothing.
- **Asset-loading test hang**: the cached rootBundle future crossed test zones; it now uses `cache: false`.

Verification:
- `flutter analyze`: no issues. `flutter test`: 169/169 pass, including tracker unit tests and a simulated 3-squat camera session saved as camera-derived.
- Release APK 64 MB with no INTERNET permission. Release posture analysis confirmed working on POCO X4 Pro 5G.

## Phase 8 — face shape and grooming (2026-10-08)

- **Face estimator**: Google ML Kit face detection (bundled, offline). Contours only: no smile/eye classification, no identity features. It sits behind the `FaceEstimator` contract. The frame pipeline runs face analysis instead of pose when a face estimator is given.
- **Face engine** (pure Dart):
  - Measures the outline width at fixed heights (forehead 12%, cheekbones as the widest point at 25–55%, jaw 80%) rather than relying on point indices.
  - Computes length/cheek, forehead/cheek and jaw/cheek ratios and ranks six reference shapes (oval, round, square, oblong, heart, diamond) by weighted distance.
  - Takes the median over 12 frames. Confidence comes from frames, the margin between shapes, and stability. Close calls report two shapes.
  - Frame checks: head turned/tilted, too far/close, outside the frame.
- **Face screen**: privacy explanation (no photo taken; proportions saved only on Save), tips, front camera with an outline overlay and oval guide, live guidance (no face / multiple faces / look straight / move closer), a 3-second countdown, then the result with shape, ratios, provenance chip and disclaimer ("says nothing about attractiveness").
- **Suggestions** (`assets/content/grooming.json`, English and Hindi):
  - Hairstyles, beard styles ("if you have or want facial hair") and glasses frames for each shape, with "Why this?".
  - Favourites (heart).
  - A simple grooming routine that can be added to Routines in one tap (reuses Phase 4).
  - Low-confidence results get no suggestions.
- **History**: schema v6 adds `face_analysis`, `face_metric` and `hairstyle_favorite` (proportions only, no images). History lists past estimates with delete (cascade).
- **Release**: R8 keep rules cover the face plugin; the `usage.txt` audit shows no ML Kit/MediaPipe classes removed. Release APK 90 MB (bundled face model) with no INTERNET permission.

Verification:
- `flutter analyze`: no issues. `flutter test`: 184/184 pass (face engine with exact synthetic outlines for every shape, in-between and unsteady cases; v5 → v6 migration integrity; repository; content completeness; full face-check widget flow including favourites and routine creation).
- On the user's phone: the first real check measured 1.27 / 0.83 / 0.78 (between oval and diamond), but low confidence hid all suggestions. Fix: confidence now reflects measurement stability only, and in-between faces show both shapes with merged suggestions. The re-check gave **Oval / Diamond, high confidence**, with suggestions; the camera was released.

## Phase 9 — visuals, try-on and progress snapshots (2026-10-08)

The original Style phase moves to Phase 10 at the user's request.

- **Scan visuals**: viewfinder corners, a sweeping scan line with a glow trail, a capture progress ring, a pop-in countdown, a glowing skeleton (posture/exercise) and the face outline as a mesh. All motion follows the OS reduce-motion setting.
- **Face result**: your measured outline animates over the reference silhouette, proportion bars animate, sections reveal in sequence.
- **Suggestion cards**: swipeable carousels (the centred card is enlarged); tapping flips a card in 3D to show details, "Why this?" and Try on; animated favourite.
- **Images**:
  - Hair/beard: 13 Unsplash-licence photos (720 px, about 1.05 MB total), credited on each card and in `assets/images/styles/CREDITS.md`.
  - Glasses and face shapes: precise vector art drawn in code.
- **Live try-on**: glasses anchored to the eye centres (scaled by eye distance, rotated by eye line) and beard shading clipped to the jaw region below the nose/lip with the mouth left clear. Press and hold to compare. Nothing is recorded. Realistic hair and body-transformation previews were declined because they would need heavy generative models; snapshots and measurements cover tracking real change instead.
- **Progress snapshots** (schema v7 `progress_snapshot`):
  - Opt-in consent screen. The JPEG is stored inside the encrypted database, never as a file or in the gallery.
  - Face, body front and body side, with a 3-second timer and a "ghost" overlay of the previous snapshot for consistent framing.
  - Before/after slider, a weekly reminder via Routines, delete one or all.
  - Photos are oriented, downscaled to 1080 px and re-encoded off the UI thread.

Verification:
- `flutter analyze`: no issues. `flutter test`: 196/196 pass (scan animation and reduce-motion behaviour, vector art for every style and shape, card flip and favourite, v6 → v7 migration, photo preparation including corrupt input, snapshot consent/capture/save flow, content requiring a credited photo for every hair/beard card).
- Release APK installed on the user's phone and launches cleanly. The R8 usage audit shows no ML Kit classes removed, and there is no INTERNET permission.

## Phase 10 — style: colour, wardrobe, outfits (2026-10-08)

- **Colour science** (pure Dart): sRGB → CIE Lab, ΔE76 distance, neutral detection (greys, beige/camel/brown, navy/denim), and hue-based harmony (neutral, monochrome, analogous, complementary, clash).
- **Colour quiz**: vein colour, jewellery and sun response give an undertone (mixed signals → neutral, with agreement), plus a depth choice (light/medium/deep, whole option tappable). That selects one of 9 curated palettes (best, neutrals, use sparingly); palette fit uses ΔE.
- **Palette screen**: animated swatch groups, style preferences (classic, minimal, smart casual, streetwear, traditional/ethnic, sporty), retake.
- **Live colour drape**: front camera with a fabric-like band under the chin that follows the face; swipe through palette and garment colours. Nothing is recorded.
- **Wardrobe** (schema v8 `wardrobe_item`, `outfit`, `outfit_item`, `outfit_wear`):
  - Add items with category (including Indian ethnic wear), colour from 24 named swatches, pattern, formality and occasions.
  - Optional photo (encrypted DB); the colour is sampled from the centre of the photo.
  - Tiles show the photo or a fabric-textured swatch, never icons.
- **Outfit engine**:
  - Builds top + bottom (or one-piece), with footwear and optional outer layer.
  - Rejects two patterns, colour clashes and formality spread > 2.
  - Scores harmony (all-neutral favoured for work/formal), asymmetric formality (dressing down penalised at work/formal, gently when casual), palette fit near the face, favourites, and variety (recently worn items lose).
  - Ideas are diverse per base and carry localized "Why this?" reasons.
- **Outfit ideas screen**: occasion chips, animated collages, save; saved tab with "Wore it today" and worn count; deleting a garment removes incomplete outfits.

Bugs found by tests and fixed:
- Scoring put a T-shirt top for work and buried classic neutral looks; rebalanced with real numbers, verified in a debug run.
- The depth label wasn't tappable (only the swatch).
- Saved outfits didn't refresh on "Wore it today" (the stream only watched one table).

Verification:
- `flutter analyze`: no issues. `flutter test`: 216/216 pass (colour science, quiz, every palette, outfit rules and ranking, repository incl. cascade and the wear log, v7 → v8 migration, quiz → palette flow, wardrobe → ideas → save → worn flow).
- Release APK 93 MB installed on the user's phone and launches cleanly; no ML Kit classes removed, no INTERNET permission.

## Phase 11 — journey & gamification (2026-10-08)

The original Phase 11 (local AI coach) moves later at the user's request.

- **Progress engine** (pure Dart, `progress_engine.dart`): everything is derived from existing records, so nothing can drift or be double-counted.
  - XP per action with caps (water target 20, meals 5 ×3, sleep 10, workouts 15 ×2, habits 10, plan items 5, posture 25 ×2, face 20, snapshots 20, outfits 10, weight 10).
  - Level n starts at 50·(n−1)² XP.
  - Streak: a day with ≥ 15 XP is active; today never breaks it; every 7 active days banks a rest day (max 2) that covers a missed day.
  - 3 daily quests, stable per day, weighted by goals and only offered when achievable (+15 XP each, +25 for all three).
  - 12 badges with progress.
- **Activity digest** (`ProgressRepository`): one SQL union over 13 tables, grouped by local day in Dart; a multi-table trigger keeps it live.
- **Home**:
  - Journey card: face time-lapse beside the level ring, XP to next level, streak and last-7-days dots.
  - Today's quests with animated progress; tapping a quest opens its feature.
  - "For you today": a horizontal row of photo cards chosen from what the user has and hasn't done.
  - A one-time badge celebration: a struck-metal medallion with a light sweep.
- **Journey screen** (also Health → Progress):
  - Time-lapse player with scrubber, and first-vs-latest comparison.
  - Level, rest days, total XP, best streak and active days.
  - 4-week XP chart and weight change.
  - Badge gallery with progress sheets.
- **Time-lapse alignment** (schema v9): eyes are found once per face snapshot by decoding the stored JPEG to NV21 in memory and running the same face detector. Frames are then transformed so the eyes are level, centred and equally spaced. Nothing is written to files.
- **Visual goal finder**: tap photo cards for goals (9) and looks (6 styles × 2 photos); saving updates the goals and style preferences that drive quests and outfit ideas.
  - 24 Unsplash photos, credited on the card and in `CREDITS.md`.

Bugs found and fixed:
- Long dropdown labels overflowed on phone-width forms. Tests now run at phone size (432 × 1280), and all 8 dropdowns expand to the field width.
- The journey card overflowed in Hindi; its height now follows the text.
- A badge celebration re-opened after closing, because the provider reports its previous value while refreshing.

Verification:
- `flutter analyze`: no issues. `flutter test`: 244/244 pass (XP caps, levels, streak and rest days, quests, badges, day digest, v8 → v9 migration, eye alignment maths, RGB → NV21, Home journey, quests, celebration shown once, time-lapse and compare, goal finder, every photo bundled and credited).
- Release APK (arm64, 96 MB) installed on the user's phone and launches without crashes. R8 removed only obfuscated ML Kit internals; there is no INTERNET permission.

## Phase 12 — personalisation, diet & body plans, UI refresh (2026-10-10)

- **About you** (onboarding page 4, all optional) and Profile: name, region, gender, age range, height, weight (in the chosen units), activity, food preference, and "show style examples for" (follows gender unless set).
- **Gender-aware style**: hairstyles, beard try-on and goal-finder looks follow menswear/womenswear; every face shape and every style has examples for both.
- **Region-aware suggestions** (13 regions; India split North/South/East/West): meals favour local cuisine (97 dishes across Indian regional and world cuisines), Indian regions get Surya Namaskar on mobility days, warm climates add 300 ml water and a cooler-hours tip.
- **Diet & body plan** (Health): lose fat / stay fit / gain weight / build muscle, pace and food preference → Mifflin–St Jeor targets (calories, protein, carbs, fat, water), safe calorie floors, blocked plans with reasons (under 18, underweight, BMI ≥ 25 for weight gain), timeline to a target weight.
  - Daily menu: protein-dense, near the target, never the same main ingredient twice a day, swappable per meal; one-tap logging into Meals.
  - Weekly training (strength days never back to back) that can be added to routines; targets update when weight changes by 2 kg.
- **UI**: floating navigation bar; tab screens with photo headers and image-card grids (photos or muted per-feature art); greeting by name; "Personalise your app" card; branded adaptive app icon (with monochrome), legacy PNGs from `tool/generate_icons.dart`, and splash for all Android versions.
- Schema v10: `user_profile` gains gender, diet_preference, style_fit, region; new `body_plan` table.

Bugs found and fixed:
- Long dropdown labels overflowed on phone-width forms (tests now run at phone size by default).
- A vegetarian day repeated paneer four times; meals now never repeat a main ingredient.
- The plan dashboard showed "maintenance 0 kcal".
- The emulator's software renderer crashed on the new Home; ANGLE graphics works (tooling only).

Verification:
- `flutter analyze`: no issues. `flutter test`: 272/272 pass (nutrition maths and safety blocks, menus for every region × diet, variety, training rules, plan flow end to end, onboarding with imperial units, style-fit filtering, v9 → v10 migration).
- Visually checked on the emulator in light and dark mode.

## Phase 13 — Today command center (2026-10-10)

- **Home as a timeline** (`DayAgenda`, pure Dart): plan items, habits, water, planned meals (with the dish for each slot) and the day's workout, grouped Morning / Afternoon / Evening / Any time on a rail, the next task highlighted.
  - The header shows a "Daily plan" % ring and a 7-day strip to look back (read-only).
  - One-tap actions: tick plan items and habits, +250 ml water, open the meal or workout.
  - Missed plan items offer **Reschedule** or **Skip today**; skipped items don't count against the day.
- **Day modes** (today only, reset tomorrow): Normal; Busy (essentials only, a 5-minute workout, extras moved to "optional today"); Low energy (gentle mobility instead of training).
- **Mood and energy check-in** (schema v11 `mood_log`): two rows of five, saved automatically. Low energy offers a low-energy day.
- **The 5-minute improvement**: one small step for right now (water if behind for the time of day, an open habit, 5-minute mobility, tomorrow's outfit in the evening, or a posture check).
- **Quick add "+"**: water 250/500 ml, meal, weight, sleep.
- **Smarter reminders**: quiet hours (e.g. 22:00–07:00, crossing midnight) suppress alerts but keep items in the plan; reminders are grouped; snooze already existed.

Verification:
- `flutter analyze`: no issues. `flutter test`: 293/293 pass (agenda grouping, completion, missed/skipped, busy and low-energy transforms, five-minute picks, quiet hours incl. midnight, check-ins and today-only mode, v10 → v11 migration, Home flow: check-in → low-energy switch, skip a missed item, tick a habit, quick-add water, look back, quiet-hours toggle).
- Checked on the emulator.

## Phase 14 — Insights & evolution (2026-10-10)

- **Insights** (Home → Insights, Journey, weekly review): Week / Month for plan items, habits, water, sleep, active minutes, meals and mood.
  - Each day is met, partly or not met, or **no data** (drawn as an empty outline), so unrecorded days never look like failures.
  - Shows met-on-N-of-M logged days, the average, and the trend against the previous period. Skipped plan items and habits leave the count; mood is never a goal.
- **Sleep score** (0–100): duration against the target (70) plus regular bedtimes (30) over the last 7 nights, with an honest note that sleep stages need a wearable.
- **Weekly review** (Home, Monday–Wednesday until closed): active days, water days met, average sleep, active days, best day, and one gentle suggestion for the area met least often.
- **Evolution timeline**: milestones derived from records (first log, first posture/face/snapshot/outfit, 7- and 30-day streaks, 30 habits, plan starts, every 2 kg weight change since the first weigh-in) plus the user's own notes (schema v12 `milestone_note`). Preview on the Journey screen; full screen with "Add a note".
- **Posture compare**: two checks of the same view side by side with the change per metric, and a same-setup reminder.
- Health history window widened to 62 days so a month can be compared with the one before.
- Fixed: Home's greeting and date used the device clock instead of the app clock.

Verification:
- `flutter analyze`: no issues. `flutter test`: 314/314 pass (day marks incl. no-data, week and month series with trends, sleep score, weekly review window and tip, milestone derivation, v11 → v12 migration, Monday review → insights → close, notes from Journey and Evolution, posture compare).

## Phase 15 — on-device health data (2026-10-10)

No extra app to install, no account, no cloud, and still no internet permission.

- **Phone sensors** (Health → Connected data):
  - **Steps**: the hardware step counter, sampled every 15 minutes by WorkManager and split by local day; reboots and glitches are handled.
  - **Walks, runs and rides**: Google Play services' on-device activity transitions; sessions of 10 minutes to 6 hours.
  - **Bed and wake times**: Play services' on-device sleep segments, merged across short wakes and labelled as estimates. The user's own nights always win.
  - Raw events wait in app-private storage until imported, are pruned after 3 days, and re-register after a reboot.
- **Health Connect** is used only if it's already on the phone (Android 14+ has it built in), never installed by us. Read-only: steps, workouts with distance, sleep, weight, height and water, through Android's own permission screen.
- **Import rules**:
  - Every imported row has a stable id (`ext:sensor:…` / `ext:hc:…`), so re-syncing updates rather than duplicates.
  - Steps use the larger of the user's own total and an imported daily total, never the sum. A Health Connect workout replaces the sensor's matching session.
  - Sync runs at start and on resume, plus "Sync now"; "Remove imported data" deletes exactly what a source brought in.
- Android: `FlutterFragmentActivity`, minSdk 26, connect-client 1.1.0, play-services-location 21.3.0, WorkManager; Health Connect rationale intent and permission-usage alias; R8 keeps the sensors package.
- Fixed: reading an unwatched provider's `future` could hang (Riverpod 3 pauses unwatched providers), so the importer reads the repository directly.

Verification:
- `flutter analyze`: no issues. `flutter test`: 320/320 pass (step day-splitting with reboot and glitch, session pairing, sleep merging, larger-of-two steps, importer de-duplication and source precedence, disconnect, Connected data screen with permission and sync).
- Emulator (Android 16): Health Connect permission screen, Physical activity prompt, and sync all work.
- Release APK on the phone launches cleanly. Permissions were checked with a direct aapt2 dump: no INTERNET.

## Phase 16 — data portability (2026-10-10)

There's no server, so moving to another phone or keeping a safe copy is done with files the user controls. Find it at Settings → Backup & export.

- **Encrypted backup** (`.personality`):
  - Contains every table, with progress photos optional.
  - Layout: `PRSNLTY1` magic, then a JSON header (format, PBKDF2-HMAC-SHA256 with 210,000 rounds, salt, nonce), then the AES-256-GCM ciphertext of gzipped JSON.
  - Key stretching and encryption run in a background isolate.
  - A lost passphrase can't be recovered.
  - Device-only settings (`sync.*`, `backup.*`) stay on the phone.
- **Restore** has two modes:
  - **Add**: `INSERT OR IGNORE`. It never duplicates.
  - **Replace**: wipes this phone's data, then inserts the backup.
  - Restore runs in one transaction with deferred foreign keys.
  - It writes only the tables and columns this version knows, so older backups restore and newer-schema backups are refused.
  - Settings reload afterwards.
  - Clear errors cover: not a backup, damaged file, wrong passphrase, newer version.
- **Export for other apps**:
  - CSV zip: one file per table, `*_at` columns as readable local times, plus a README. No photos.
  - JSON with everything.
- **Moving files**:
  - Android's own pickers (`ACTION_CREATE_DOCUMENT` / `ACTION_OPEN_DOCUMENT`) and the share sheet, through a `personality/files` channel and a FileProvider limited to `cache/share/`.
  - No storage permission and still no INTERNET.
- Packages: `cryptography` 2.9 and `archive` 4.4.

Verification:
- `flutter analyze`: no issues.
- `flutter test`: 326/326 pass. The new tests cover:
  - encrypted round trip with photos and settings;
  - wrong passphrase, foreign, truncated and tampered files;
  - merging twice without duplicates;
  - an older backup with retired columns and tables;
  - CSV quoting and times;
  - the screen flow (passphrase rules, save, wrong passphrase, restore).
- Emulator, release build:
  - Saved through the system picker; the file starts with `PRSNLTY1`.
  - Restored through the open picker; "Restored 8 records".
  - The CSV share sheet opens.
- Release APK installed on the phone. aapt2 shows no INTERNET or storage permission.

## Phase 17 — content packs and exercise studio (2026-10-13)

The exercise library goes from 22 to 1,526 exercises without growing the app: optional packs download from the public repo [prashantkeshr/personality-content](https://github.com/prashantkeshr/personality-content) only when the user taps Download.

- **Privacy change — INTERNET is now declared**, for one purpose: downloading packs.
  - Only HTTPS to `raw.githubusercontent.com` / `github.com` / `objects.githubusercontent.com` is allowed, redirects included, and it's enforced in code.
  - Requests carry no identifiers, and nothing about the user is ever sent. Health data and backups never touch the network.
  - "Wi-Fi only" is on by default, using `ACCESS_NETWORK_STATE`.
  - ML Kit's telemetry uploader is removed from the merged manifest: Google datatransport's `TransportBackendDiscovery`, `JobInfoSchedulerService`, `AlarmManagerSchedulerBroadcastReceiver`, and `MlKitRemoteWorkerService`. The merged release manifest has none of them.
- **Packs** (Settings → Content packs, or the download icon in the library):
  - Each pack is a zip listed in `manifest.json` with its size and SHA-256. Every download is verified before use and unzipped off the UI thread with a path-traversal check. A pack replaces its older version only once the new one is fully in place.
  - Packs are stored in app support, so they're not part of backups. The `content.*` settings stay on the device.
  - The packs:
    - `exercise-library`: 1,324 exercises, text only, from hasaneyldrm/exercises-dataset (MIT). Steps are in English, Hindi and Spanish. Its GIFs are © Gym visual and are **not** used.
    - `illustrations`: Everkinetic start/end drawings (CC BY-SA 4.0), converted to 360 px grayscale and tinted with the theme colour at runtime. 139 are matched to library exercises, plus 130 more illustrated exercises.
    - `yoga-stretch`, `cardio-hiit`, `martial-arts`, `face-jaw-neck`: our own content (MIT), in English and Hindi.
  - The face, jaw and neck routines carry an honest note: they relax and mobilise, but don't change bone, move teeth, or reshape the face, and "mewing" claims are unproven.
- **Animated figure**: our own vector figure (`lib/features/exercise/figure/`) draws 80+ motions from keyframes in `assets/content/motions.json`.
  - Views: side and front body, plus face and profile rigs for jaw, tongue posture, neck and face work.
  - Props: bench, box and step.
  - Reduced motion shows the key poses side by side instead of animating.
  - The pack builder maps 887 of the 1,324 dataset exercises to a figure motion by name, and gives no figure where it would be misleading (machines, twists).
- **Library**: search by name, muscle or equipment; filters for camera-tracked, no equipment and category; a lazy list with figure or illustration thumbnails. The detail page adds muscles, equipment and credits.
- **Guided workouts**: 6 built-in programs plus 9 from packs. The player runs get-ready, work and rest with a countdown, sides and rounds, next-up, pause, skip and previous, with haptics. A finished workout is logged automatically.
- New categories: Martial arts, and Face & jaw.
- Fixed during testing:
  - Closures passed to `Isolate.run` captured the progress callback, which holds UI state, so installs from the screen failed. Isolate work now goes through static helpers.
  - The catalog no longer waits on pack storage to show built-in content.

Verification:
- `flutter analyze`: no issues. `flutter test`: 337 pass, 1 skipped (the opt-in figure renderer). New tests cover:
  - every motion and interpolation;
  - workout segments (sides, rounds, rests);
  - installing the real face/jaw/neck pack;
  - update and remove;
  - checksum failure;
  - zip-slip rejection;
  - host allow-list;
  - the player run end to end and logged;
  - download → Wi-Fi gate → library and workouts.
- Live check: the manifest fetched from GitHub, and a downloaded pack matched its size and SHA-256.
- Emulator, release build: all 6 packs downloaded from GitHub; the library showed 1,526 exercises; Everkinetic illustrations rendered (after a tint fix); the jaw routine played with the face figure.
- Not yet verified: camera pose detection on a release build with the telemetry components removed. The emulator hung before that check; it needs a run on the phone.

## Phase 18 — My Growth, Blueprint and skills (2026-10-13)

- **Tabs**: Home · Health · Analyze · Style · **My Growth**. My Growth replaces the Coach tab; the AI coach is shown there as "coming soon".
- **My Growth** has:
  - one search bar;
  - the Blueprint;
  - the skills strip;
  - links to guided workouts, journey, insights, evolution, habits, routines and goals;
  - an avatar menu for profile, goals, backup, content packs and settings.
- **Blueprint** (`domain/services/blueprint_engine.dart`):
  - There is no overall score. Each of 9 areas (body, fitness, posture, sleep, hydration, habits, style, grooming, skills) shows its own progress for the last week or fortnight.
  - "No data" is never shown as a failure.
  - Focus areas come from the user's goals and are listed first, weakest first. The single "next step" picks the weakest focus area.
- **Explainable recommendations**: tapping any area opens "Why am I seeing this?" with:
  - why it's shown (your goal, nothing recorded, on track, partly, falling behind);
  - what it helps with;
  - other ways to do it;
  - the action itself.
- **Skills & martial arts**: 13 disciplines, each on its own coloured card with its signature move.
  - **Indian**: Kalaripayattu, Silambam, Gatka, Mardani Khel, Thang-ta, Kushti (Pehlwani), Musti Yuddha, Lathi Khela.
  - **World**: boxing, kickboxing & Muay Thai, karate, kung fu, self-defence basics.
  - The overviews are built in (`assets/content/disciplines.json`): origin, what each trains, an honest safety note, and 46 tips & tricks in English and Hindi.
  - Each discipline page lists its techniques by kind (stances, techniques, drills, conditioning), its guided drills, and its tips.
  - Solo practice only. Partner work, sparring and weapons are left to a qualified teacher, and stick arts use a light bamboo or PVC stick.
- **Packs**:
  - `martial-arts` v2 tags every technique by discipline and adds Muay Thai and self-defence: 20 items, 5 routines.
  - New `indian-martial-arts` pack: 22 techniques and 4 routines (Kalari basics, akhara dand-baithak, stick drills, Gatka & Mardani Khel).
  - Installed v1 packs show "Update" — verified on the emulator.
- **Figure**: 18 new motions, including Kalari leg swing, the elephant, lion and horse stances, Silambam staff spin, Gatka and lathi strikes, stick twirl, dand, baithak, mugdar swing, wrestler's stance and sprawl, palm and elbow strikes. The figure can now hold a stick, staff or club that moves with its hands.
- **Global search** covers disciplines, every exercise and technique (including by discipline name, muscle or equipment), workouts, and tips.
- Fixed:
  - Discipline cards overflowed in the horizontal strip; they now have a fixed height.
  - Assets loaded with `rootBundle`'s cache never resolve in a later widget test, so the new loaders use `cache: false`, as the existing ones do.

Verification:
- `flutter analyze`: no issues. `flutter test`: 343 pass, 1 skipped. New tests cover:
  - Blueprint rules: no data isn't failure, focus-first ordering, next step, targets;
  - discipline content: bilingual, real motions;
  - My Growth end to end: why-sheet → action, skills hub → discipline → tips, search, avatar menu;
  - a discipline with the real Indian pack installed, including the kind filter, technique detail and drill.
- Live packs verified (size and SHA-256).
- Emulator, release build:
  - the My Growth tab and Blueprint;
  - discipline cards;
  - the martial-arts update and Indian pack download from GitHub;
  - the Kalaripayattu page with techniques, drill and tips;
  - searching "lathi";
  - no crashes in the log.
- Still to verify on the phone: Phase 15 sensors, and Phase 17/18 camera features with telemetry components removed.

## Phase 19 — Style DNA (2026-10-17)

- **Style DNA** (Style → Style DNA): the colour palette, face shape and style picks the app already had, plus new choices: fits (slim → tailored), occasions, cultural wear (Indian ethnic, modest, western, fusion), coverage (relaxed → fully covered) and budget.
  - Works for every gender and can be edited any time.
  - A completeness ring shows how much is filled in.
  - Every suggestion follows it.
- **"Get ready for…"**: 10 events (interview, presentation, office day, date, wedding, festival, party, day out, gym, travel). Each gives one checklist:
  - **Outfit**: the outfit planned for today, else the best one from your wardrobe, else written guidance. Traditional wear for weddings and festivals if you chose Indian ethnic. Your coverage and fit preferences. Ironing and shoe care.
  - **Grooming**: the hairstyle and beard style that suit your face shape and style fit, plus skin, sunscreen and nails.
  - **Posture, breath and voice** for speaking events: stand tall, 4-6 breathing, a face and voice warm-up, pace, eye contact, three key points.
  - **Before you leave**: documents, gift, water, phone, leaving early.
  - Outfits are drawn on a body silhouette. Ticks are kept for the day, and lines link to the screen that helps.
- **Outfit calendar**: two weeks at a time, occasion tabs, plan a saved outfit for any day, "Wore it" for today and past days (counted in wear stats). One plan per day and occasion.
- **Wardrobe stats**: items, total wears, neutral share; gaps based on your Style DNA and climate (bottoms, shoes, work top, formal wear, festive or traditional wear, neutral basics, workout clothes, outerwear) with advice; most worn; best value (cost per wear); not worn yet. Prices are optional and shown in your region's currency.
- **Glasses finder**: 20 frames across 11 shapes. Six shapes are new: aviator, cat-eye, oval, square, geometric, rimless.
  - Frames are ranked "Great / Good / Less balancing" for your face shape, using contrast rules.
  - It says plainly that this is fit guidance, not a judgement of looks, and adds a sizing tip.
  - "Try on live" opens the camera try-on with that frame shape and colour.
- **Outfit silhouette**: outfits drawn on a neutral mannequin, with layering by category (trousers, dress, kurta with churidar, top, open jacket, shoes) and stripes, checks or print shown. Used on saved outfits, the calendar and Get ready.
- **Schema v13**: `wardrobe_item.price` and an `outfit_plan` table, which is cascade-deleted with its outfit. A data-integrity migration test covers v12 → v13.
- Fixed: the price dialog disposed its controller during its closing animation. The dialog now owns its controller.

Verification:
- `flutter analyze`: no issues. `flutter test`: 369 pass, 2 skipped (the opt-in preview renderers). New tests cover:
  - wear counting and cost per wear, and gaps;
  - checklist rules: planned outfit first, speaking events, Style DNA, gym;
  - the glasses catalogue and fit rules (every face shape has at least 4 great frames);
  - the repository round trip: DNA, prices, plans, cascade;
  - 5 end-to-end flows: DNA save, Get ready with ticks kept, calendar plan and worn, glasses sheet, stats gaps and price.
- Emulator, release build: the Style tab's new cards, the Interview checklist, and the glasses finder. No crashes.

## Phase 20 — Lock, widget, languages (2026-10-17)

- **App lock** (Settings → Security): a 4–8 digit PIN, with optional fingerprint unlock.
  - The PIN is stored only as a PBKDF2 hash (60,000 iterations) in Android secure storage and checked in constant time.
  - The app locks on start and after 30 seconds away. While you switch apps, a cover hides the screen.
  - Every 5 wrong tries adds a 30-second wait, growing each time.
  - While locked, the app behind the cover is hidden from screen readers and keyboard focus.
  - A forgotten PIN can't be reset. The screen explains the options: fingerprint, or clear the app's data and restore a backup.
- **Home-screen widget** (3×2): water today with a "+ Glass" button that adds 250 ml, and the next plan item. The next item is hidden while the app lock is on.
- **12/24-hour time**: Same as device, 12-hour or 24-hour, applied across the app (reminders, backups, posture history, connected data).
- **Goals-first onboarding**: goals come straight after the welcome screen. The body questions (height, weight) are asked only when a goal needs them (weight, fitness, flexibility, hydration) or when no goal is picked.
- **"Why am I seeing this?"** on every For-you card: why it was suggested and what it helps with.
- **New languages**: Spanish, Portuguese, Indonesian and Arabic. All 1,492 strings are translated, with placeholders and plural forms checked by script.
  - Language names are shown in their own script.
  - The widget's description is translated too.
  - Arabic lays out right to left: start/end padding and alignment throughout, and `supportsRtl` for the widget.
  - The PIN keypad keeps 1-2-3 order. Day chips use the one-letter Arabic weekday, because every Arabic weekday begins with "ال".

Verification:
- `flutter analyze`: no issues. `flutter test`: 383 pass, 2 skipped. New tests cover:
  - PIN hashing; lock on start, unlock, and the wrong-PIN wait; fingerprint unlock;
  - nothing from the app reaches the semantics tree while locked (this test fails without the fix);
  - the keypad order in Arabic;
  - the widget bridge (adding water; hiding the next item when locked);
  - goals-first onboarding, including a style-only path;
  - each new locale, Arabic right-to-left, and short weekday names.
- Emulator, release build:
  - Arabic home: mirrored layout, Arabic numerals, distinct day letters.
  - Lock: set a PIN, relock after 36 s away, unlock with the PIN; only the lock is visible to accessibility.
  - Widget: added from the launcher; shows in Arabic; "+ Glass" added 250 ml after unlocking.
- Release permissions: `USE_BIOMETRIC` and `USE_FINGERPRINT` are new (fingerprint unlock). Nothing else changed.

## Phase 21 — Phone lock, weight journey, goal reminders (2026-10-18)

Also in this release (e73955f): the new app icon generated from tool/branding/icon_source.png, and the dhurta.Inc contact details (support@dhurta.org) in Settings → About.

- **Phone's own screen lock** as the app lock. Turning the lock on now asks how to unlock:
  - **Phone's screen lock** (recommended): fingerprint, face, or the phone's PIN, pattern or password, through Android's own prompt. The app keeps no secret for this.
  - **App PIN**: as before.
  - The lock screen opens the system prompt by itself; cancelling leaves an Unlock button.
  - Switching method or turning the lock off first asks for whatever unlocks it now.
  - If the phone's screen lock is removed later, the app lock turns itself off and says so, since there is nothing left to check against.
- **Weight journey** (Health → Weight):
  - An illustrated trail from the starting weight to the goal, with flags at 25/50/75%. A walker moves along it as the 7-day trend gets closer. Tap a flag to see its weight.
  - The start is the active body plan's start, otherwise the first weigh-in. The target is the plan's target, otherwise the nearer edge of the goal range. Moving away from the goal never shows as negative progress.
  - Stats: this week, since start, to go, and a weigh-in streak in weeks.
  - **Step on the scale**: a drawn scale and a draggable ruler (0.1 kg or 0.2 lb steps) with haptic ticks and − / + buttons, and slider semantics for screen readers.
  - Passing a milestone shows a short celebration. Reduced motion is respected.
  - The chart now has touch tooltips and a dashed target line. The detailed form (date, notes) moved to the app bar.
- **Goal reminders** (Health → Goal reminders, and a weigh-in card on the weight screen): weigh-in (Mondays 7:30), drink water (4 times a day), bedtime wind-down, move breaks and posture breaks.
  - Your own goals are listed first.
  - Each one is an ordinary routine, so quiet hours, Done / Snooze and history all work.
  - Days and times can be edited in place.
- **Database self-repair**: when the database opens at the current version, any missing optional column is added back. The emulator's database, made by a pre-release Phase 12 build, lacked `user_profile.region`, so every profile save failed ("Could not save" on the goal range). Published builds were never affected.
- Fixed: AnimatedSize with reduced motion threw during layout, so reduced motion now skips the animation. The scale sheet opens above the floating tab bar.

Verification:
- `flutter analyze`: no issues. `flutter test`: 405 pass, 2 skipped. New tests:
  - phone-lock mode (no PIN stored, a PIN can't stand in, auto-prompt, a failed prompt, the phone lock being removed, switching method);
  - weight journey maths (range edges, plan override, trend, never-negative progress, streak, milestones, ruler snapping);
  - weight screen (trail percent, scale buttons and drag, celebration, set-goal link, weigh-in reminder);
  - goal reminders (on / remove a time / days / off);
  - schema self-repair (fails without the fix).
- Emulator, release build (with a test screen-lock PIN):
  - switched from the app PIN to the phone's lock; relocked after 36 s and unlocked through Android's prompt; cancelling shows Unlock;
  - set the goal range; weighed in 70 → 67.8 kg and saw "50% of the way!";
  - turned on the weigh-in reminder, which appears under Next reminders (Mon 7:30).
- Release permissions unchanged.

## Phase 22 — Recommended for now, meal reminders, permissions (2026-10-19)

- **"Recommended for now" on Home** replaces the single "Got 5 minutes?" card. Up to four swipeable cards suit the time of day, each with an illustration (the animated figure for movement) and **Do it** / ✕ (not now).
  - **Meals:** breakfast 7:00–10:30, lunch 12:30–15:00, dinner 19:30–22:00, each until a meal is logged. A 10-minute walk is suggested in the hour after a meal.
  - **Morning:** posture check (until one is saved today), weigh-in (weight goal, until weighed today), wake-up stretch.
  - **Day:** a micro set, rotating daily and between the two halves of the day: push-ups, squats, plank, glute bridges, lunges.
  - **Skills:** the user's chosen skills come up in the evening. Skill pages now have a **Practise regularly** switch.
  - **Other:** a yoga flow for a flexibility goal, the weekly face snapshot, a wind-down at night, water when behind, and a one-off offer of meal-time reminders.
- **Micro sets start small and grow by themselves**: 5 push-ups, 15 squats or a 20 s plank for a new user (more for active profiles), plus one step every two sets logged, with a cap.
  - Done logs an exercise session.
  - Holds count down, buzz and log themselves.
- **Goal reminder presets added**:
  - meal times (8:30 breakfast, 13:00 lunch, 20:00 dinner; each notification is named by its time);
  - morning posture check (8:00 daily);
  - weekly face snapshot (Sundays 9:00; the snapshots screen's weekly reminder now uses it, so it can't be added twice).
- **Permissions**:
  - A 6th onboarding step explains notifications, camera and physical activity, each with Allow (or Open settings once Android stops asking) and Allow all. Two starter reminders, meal times and the morning posture check, are pre-ticked and switched on if notifications are allowed.
  - The About-you numbers are now checked when leaving that page.
  - Home shows a gentle card while something is off, at most once every 3 days after "Later". Settings has a Permissions section. Both re-check when the app returns from Android settings.
  - Android can't deliver a notification about a refused notification permission, so the re-ask is in-app by design.
- Native (`personality/device`): `permissions` (granted plus askable, tracking "asked before" so a permanent refusal opens settings), `requestCamera`, `markAsked`, `openAppSettings`.
- Removed the now-unused FiveMinute picker and card.

Verification:
- `flutter analyze`: no issues. `flutter test`: 419 pass, 2 skipped. New tests:
  - the engine for every window (meal logged, walk window, weigh-in rules, micro-set growth and cap, rotation, skills, handled and never-again, max four);
  - Home (lunch / not now, a counted set logged and the counter growing, a plank countdown that logs itself, a chosen skill in the evening, the permission card with Later and Allow);
  - onboarding (validation on Next, starter reminders created or skipped).
- Emulator, release build, clock set to 11:05: water, posture check, the meal-reminder offer and a 30 s plank (moderate profile). Revoking the camera showed the Home card; Allow opened Android's prompt and the card went away. The Settings Permissions section shows the ticks.

## Phase 23 — About Your Personality, Analyze photo, backup password (2026-10-19)

- **About Your Personality** (Home card → `/home/about`): one read-only page of what the user's own checks have shown, with no score.
  - **Header:** latest face snapshot (or initial), name and goals.
  - **Face:** shape, secondary shape, ratios, date.
  - **Body:** height, weight, change since the first weigh-in, BMI with the caveat that it's a rough guide, and up to four proportions.
  - **Posture:** view, each metric in degrees with its band colour, date.
  - **Style:** undertone, depth, best-colour swatches, preferred styles.
  - **Progress:** total XP, level, current and best streak, posture checks, progress photos.
  - **Room to grow:** the blueprint areas not on track (your focus first), each with a Go button.
  - Every part has "Check now" when empty or "See more" when filled.
- **Analyze tab:** the Exercise tracking card uses a new photo of someone exercising in front of a phone on a tripod (Vitaly Gariev, Unsplash `KvAvnp99-_0`, approved by the user, credited in assets/images/goals/CREDITS.md). The other cards are unchanged, at the user's request.
- **Backup & restore:** "passphrase" is now "password" in all six languages ("Set a password for your data", "Wrong password.", and so on).

Verification: `flutter analyze` clean; `flutter test` 421 pass, 2 skipped (new: the About page empty and filled, with the BMI value and caveat). Emulator release build: the About page with real data (172 cm, 67.8 kg, BMI 22.9, warm/medium palette) and the new Analyze card.

## Phase 24 — Yoga skill and poses, add a skill to my day, more focus goals (2026-10-19)

- **Yoga & mind-body** is a new section in Skills (before Indian and world martial arts). It is built in, so no pack download is needed. The optional extra pack is `yoga-stretch`.
  - **15 new poses**, each with an animated figure, steps, dose and safety note: mountain, tree, warrior I, warrior II, triangle, chair, goddess, downward dog, low lunge, cobra, bridge, boat, forward fold, seated fold and seated breathing. Child's pose, cat–cow and sun salutation also belong to yoga now.
  - **3 new motions:** `boat_pose`, `low_lunge` and `goddess_pose`.
  - **3 flows:** Sun flow, Balance and Evening calm.
- **Add to my day** on every skill page: pick a time (default 18:00) and a length (5/10/15/20 min).
  - The practice goes into one "My practice" routine that runs every day, so it gets a reminder and shows on the day plan.
  - The skill is also added to the Home recommendations.
  - Notification permission is asked for once if needed.
- **Find your focus** has six more goals: strength, calm & mindfulness, energy, eat better, skin care and confidence. Each has its own icon and colour art, a blueprint area and quest weights. Mindfulness also recommends yoga.

## Phase 25 — Habit ideas, meal ideas, sample day (2026-10-19)

- **Habit ideas** (lightbulb in Habits, and on the empty state): 14 common habits in four groups (food, body, mind, sleep). Picking one opens the habit editor already filled in, so the name and days can be changed before saving.
- **Meals screen:**
  - **Ideas for <meal>:** dishes for the meal that fits the current time. They are filtered by diet, with local cuisine first, rotate daily, and can be logged with calories in one tap.
  - **Sample day:** a full day of meals sized to the body plan's targets, or else the estimated maintenance, or else 2,000 kcal. "Another" shows a different combination, and each dish can be logged.

Verification: `flutter analyze` clean; `flutter test` 426 pass, 2 skipped (new: content integrity, yoga add-to-day, new goals, habit idea edit, meal idea log and sample day). Emulator release build: Yoga section with 18 techniques; boat pose, low lunge and goddess pose figures checked.

## Phase 26 — Skills by popularity, pack downloads on mobile data (2026-10-19)

- **Skills** is one list ordered by popularity (Yoga, Self-defence, Boxing, Karate, Kickboxing & Muay Thai, Kung fu, then the Indian arts). The order lives in `disciplines.json` and also drives the My Growth carousel.
- **Content pack downloads:**
  - On mobile data with "Wi-Fi only" on (the default), every download used to fail, even 7 KB packs. Packs under 2 MB now always download; bigger ones ask "Use mobile data?" (Download now / Wait for Wi-Fi).
  - Downloads give up after 30 s without progress (DNS, connect or data), and the pack list no longer auto-retries (Riverpod's default retried up to 10 times, so it looked like an endless spinner). Failures show "You're offline" with Retry.
- The privacy note no longer shows the GitHub address ("Personality's official content library").

Verification: `flutter analyze` clean; `flutter test` 426 pass, 2 skipped (download test covers a small pack on mobile data and the mobile-data prompt). Emulator: skills order, new disclaimer, offline error with Retry. Phone: on Airtel 4G (metered) GitHub is reachable; download to be confirmed by hand (MIUI blocks adb taps).

## Phase 27 — Notification sounds and app customisation (2026-10-19)

- **Settings → Notifications & sounds** (`/settings/notifications`, `lib/features/settings/notification_settings.dart`):
  - **Sound:** phone default, silent, or one of 12 sounds made for the app (chime, bell, marimba, kalimba, singing bowl, water drop, soft pop, rising notes, harp, sparkle, pulse, birdsong). They are synthesised by a script, so there are no licences, and stored as `res/raw/snd_*.wav` (608 KB, kept from resource shrinking in `raw/keep.xml`). Each has a preview (native `playSound` on `personality/device`, MediaPlayer with notification audio attributes).
  - **Vibration:** off, gentle, normal or strong. **Pop up on screen** (high importance). **Hide details on lock screen** (private visibility). **Snooze** 5/10/15/30 min; the Snooze button shows the chosen length and the background snooze uses it.
  - **Send a test notification**, and a link to reminder times and quiet hours.
  - Android fixes a channel's sound, vibration and importance, so each combination gets its own channel (`reminders_<sound>_<vibration>_<pop|quiet>`), and older reminder channels are deleted after each sync. The style is stored as JSON in app_settings (`notif.style`), travels in each notification's payload for snoozes, and a change triggers a re-sync.
- **Appearance:**
  - **Accent colour** with 8 choices (`AppAccent`; the whole theme is built from the chosen seed).
  - **Text size:** Small, Default, Large or Larger, which multiplies the phone's own size. Each label is drawn at its own size.
  - **Reduce animations**, combined with the phone's own setting through `MediaQuery.disableAnimations`.

Verification: `flutter analyze` clean; `flutter test` 429 pass, 2 skipped (new: style round trip and channel ids, choosing sound/vibration/snooze plus the test notification, accent/text size/reduced motion applied app-wide). Emulator release build: settings render; the preview plays; the test notification pops up on channel `reminders_zenBowl_standard_pop` with `snd_zen_bowl`; the old `reminders` channel was deleted.

## Phase 28 — Pulse by default, About snapshot (2026-10-20)

- **Pulse** is the default reminder sound. Anyone who already picked a sound keeps it.
- **About Your Personality → Your snapshot** (`domain/services/personal_snapshot.dart`):
  - **Ratings** (Great / Good / Fair / Needs work, with a four-step meter and the number behind each) for body (BMI), posture (latest check's bands), activity (active minutes a day), sleep (hours a night), hydration (share of logged days on target) and consistency (streak). An area needs 3+ logged days this week before it is rated, and there is still no overall score.
  - **Key areas to improve:** up to 3, the user's focus goals first and then the worst, each with a practical tip.
  - **Exercises suggested for you:** up to 6, chosen from posture issues (e.g. forward head → chin tuck, wall angels), BMI (over the range → brisk walk, squat; under → incline push-up, squat), weak areas (sleep → seated breathing, child's pose) and goals. Each says why it was picked and opens the exercise.

Verification: `flutter analyze` clean; `flutter test` 434 pass, 2 skipped (new engine tests; the About test checks the BMI rating and suggestions).

## Phase 29 — Growth, exercise and weight widgets (2026-10-20)

Three new home-screen widgets, each with its own design and a graph drawn to a bitmap in Kotlin (`WidgetCharts.kt`; RemoteViews can't host custom views):

- **My growth:** a purple-to-teal gradient; level, progress bar to the next level with XP left, a streak flame, and a 7-day bar chart of the share of each day's plan completed. Opens My Growth.
- **Exercise:** a dark card with an orange accent; a progress ring for today's active minutes against the target (with %), "This week: N min", a **Start** button (opens Workouts) and a 7-day minutes chart. Opens the exercise log.
- **Weight:** a light blue card; the latest weight, change since the first of the last 30 weigh-ins, and a smooth line chart with a soft fill. Opens the weight screen.

How it works:
- The app writes translated text and chart values into the widget preferences (`g_`, `e_`, `w_` keys plus the shared `days` labels and `locked`). Widgets never read the encrypted database.
- With app lock on, they show only the "Unlock the app" text.
- Taps reach the app as `route:<path>` through the existing `takeAction` channel.
- Widget names and descriptions are in all six languages.

Verification: `flutter analyze` clean; `flutter test` 436 pass, 2 skipped (new: widget data for all three, and the route tap). Release build installed on the phone.

## Phase 30 — Water, sleep, focus and habits widgets (2026-10-20)

- **Water:** a light-blue card with a bottle drawing that fills (with a wave) toward today's target. Shows "1.2 / 2.5 L", "% of today's goal", and **+ 250 ml** and **+ 500 ml** buttons (action `add_water:<ml>`).
- **Sleep:** a night-sky gradient. Shows last night's duration, the nightly goal and a 7-night bar chart against the goal (lavender).
- **Your focus:** a warm cream card. Shows the top area to improve from the About snapshot with its tip, and **Try today**: one suggested exercise that changes daily, with its reason. Tapping the exercise opens it; tapping the card opens About.
- **Habits:** a soft green card. Up to 4 of today's habits with check circles and "2 of 4 done". Tapping a habit marks it done for today, or undoes it (action `habit:<id>`), and opens Habits.
- Widget taps now carry either a route or an action (`EXTRA_ACT`).
- With app lock on, sleep, focus and habits show only "Unlock the app". Water stays visible, like the Today widget.

Verification: `flutter analyze` clean; `flutter test` 438 pass, 2 skipped (new: habits data and tick toggle, bottle quick-add).

## Phases 31–33 — Face balance, 31 hairstyles, hair & makeup try-on, lookbook, style Q&A, trends (2026-10-21)

**Phase 31 — Balance & proportions**
- The face check now measures left/right **balance** for the eyes, cheeks, jaw and mouth, against a midline between the eye centre and the nose tip. Readings come only from frames turned less than 5°, and the result is a median over at least 3 of them.
- It also measures **proportions**: eye spacing to cheek width (closer-set / average / wide-set) and mouth width to eye spacing.
- Shown as "97% even" bars with the note that most faces measure 90–98%. It's for interest, never a score. Values are stored as `face_metric` rows (`balance.*`, `prop.*`), so the schema didn't change.

**Phase 32 — Hair and makeup**
- **31 hairstyles** (22 new: buzz, crew, French crop, pompadour, slick back, curly top, long-top undercut, top knot, textured fringe, afro, pixie, lob, wavy lob, long straight, long curls, curtain bangs, blunt bangs, shag, wolf cut, high ponytail, top bun, side braid). Each face shape suggests 7–16 of them.
- New styles have no photos, so they're drawn with the hair-silhouette engine (`shared/visual/hair_art.dart`, 31 shapes covering crown, volume, length, fringe, sweep, texture and buns/ponytail/braid).
- **Hair try-on** in the live camera: silhouettes fitted to the detected face outline, in 6 natural colours, and opened from any hairstyle card.
- **Makeup guide** (`/analyze/face/makeup`, `assets/content/makeup.json`):
  - A face map plus blush, contour and highlight placement for each of the 6 face shapes.
  - Lip, blush and eye shades for each undertone (warm, cool, neutral), with a note for each skin depth.
  - Basics, including patch-testing.
- **Lip and blush try-on:** sheer tints on the detected lips and cheeks. A shade can be opened straight in the try-on or saved with ♡.

**Phase 33 — Lookbook, Q&A, trends**
- **My lookbook** (`/style/lookbook`): every ♡ in one place, covering hairstyles, beards, glasses, makeup shades (`makeup:<id>` in the style favourites), favourite clothes, saved outfits and best colours. Tap to try on; tap the heart to remove.
- **Ask about style** (`/style/ask`): 30 built-in answers on skin, hair, makeup, beard, clothes, colour and glasses (en/hi, other languages fall back to English). Searchable and filterable by topic. Fully offline; searches never leave the phone.
- **Style trends** (`/style/trends`): 16 built-in trends for autumn–winter 2026. A downloaded `style-trends` pack (kind `trends`) replaces them when its `updated` date is newer. The pack is built by `personality-content/tools/build_trends.py` from `src/trends.json` (20 trends in v1).
- All four are cards on the Style tab.

Verification: `flutter analyze` clean; `flutter test` 451 pass, 2 skipped (new: balance engine, hair and makeup content integrity, saved balance and drawn hairstyle cards, Style tab entries, lookbook add/remove, Q&A search and topics, trends, makeup guide). Emulator release build: Style tab cards and the makeup guide checked visually. Live hair/lip/blush try-on still needs checking on a real phone (the emulator camera has no face).

## Phase 34 — Play Store release prep (2026-10-21)

- **Signing:** `android/app/build.gradle.kts` signs release builds with the upload key from `android/key.properties` when it exists, and falls back to the debug key otherwise. `tool/make_upload_key.ps1` creates the key and the properties file; the user types the password, and both files are git-ignored.
- **Builds:** `flutter build appbundle` → 139 MB AAB (Play serves each phone its own split: ~70 MB on arm64). `--split-per-abi` APKs: arm64 70 MB, armv7 63 MB, x86_64 74 MB. Target SDK 36, min SDK 26.
- **Store kit** in `docs/store/`:
  - `privacy-policy.html`, ready to host. Every claim was checked against the code: no data leaves the device, backup is off, the ML Kit uploader is removed, Health Connect is read-only, and pack downloads go to GitHub.
  - `PLAY_LISTING.md`: name, short and full descriptions, Hindi translation, data safety, content rating, target audience, permission declarations and the Health apps declaration.
  - `RELEASE_CHECKLIST.md`.
  - `graphics/icon-512.png` and `feature-graphic-1024x500.png`, made by `tool/store_graphics.py`.
  - `screenshots/`: 7 phone screenshots (1080×2400) with a demo status bar.

Still needs the user: create the upload key, host the privacy policy at a public URL, create the Play Console app and submit the forms.

## Phase 35 — On-device AI coach (2026-10-21)

- **Ask your AI coach** (`/growth/coach`, card at the top of My Growth). Every answer comes with picture cards and an **Open** button to the right screen. The pictures are the app's own: exercise figures, hairstyle drawings, style and section photos, colour swatches.
- **Grounded in the app's knowledge** (`features/coach/coach_knowledge.dart`). A BM25 search runs over everything built in or downloaded:
  - exercises (curated guides weigh 1.4, pack exercises 0.6), programs, yoga and martial arts;
  - style Q&A, makeup placement and shades, trends, hairstyles, beards and glasses;
  - meals, and 28 app sections (`assets/content/app_sections.json`).
  Personal questions also pull in the user's About-snapshot exercise suggestions.
- **The user's data** goes into the prompt as a short summary: ratings, areas to improve, goals, diet, region, undertone, and today's steps, active minutes and water. Chat history lives in memory only and is never stored.
- **Model:** Qwen2.5-0.5B-Instruct q4_0 GGUF (Apache-2.0, 409 MB), pinned by size and SHA-256.
  - Users download it once from Settings via Hugging Face; only `huggingface.co` and `*.hf.co` are allowed hosts. It streams to a `.part` file with chunked SHA-256 and gets a mobile-data prompt.
  - Inference uses `llamadart` 0.15.5 (llama.cpp, CPU only — the Vulkan module would add 26 MB) with a 2,048-token context, temperature 0.2 and a 220-token cap. The answer streams in and can be stopped.
  - The prompt keeps answers to 4 bullets, using only items, steps and figures from the notes, with no medical diagnosis.
- **Capability:** 3.4 GB+ RAM and not a low-RAM device. Phones that can't load the engine (e.g. 32-bit) use **smart search mode**, which quotes the best notes with the same cards.
- **Size:** arm64 APK 91 MB (+21 MB for the engine).
- **Privacy:** the policy and listing now cover the one-time model download. Prompts never leave the phone.

Verification: `flutter analyze` clean; `flutter test` 456 pass, 2 skipped. New tests cover search ranking, prompt content, search-mode answers with cards and navigation, a streamed answer from a fake model, and the My Growth entry.

On the emulator (x86_64, 4 GB, 6 cores) with the real model:
- The in-app download, including the Hugging Face → CDN redirect and checksum, finished in 210 s.
- Answers took 5–12 s (posture → chin tucks / gentle mobility / desk reset programs; round face → ponytail / afro / top bun drawings; high-protein dinner → meal photos).

## Phase 36 — Guided workouts on Home, tappable cards, "Let's try" (2026-10-25)

- **Workout ranking** (`features/exercise/workout_ranking.dart`):
  - Starts from a popularity order: Beginner full body, Morning sun flow, Quick energy boost, Desk reset, Morning mobility, Home strength, Wind down, Balance, Evening calm; pack workouts come after.
  - Usage then moves workouts up, scoring 3 per finished session and 1 per open. Counts are kept on the phone in app_settings (`workout.opened.<id>`, `workout.done.<id>`).
  - The guided workouts list uses the same order.
- **Home:**
  - A **"Let's try …"** card for the top-ranked workout, labelled "Your go-to workout" or "Most popular", with a play button.
  - A **Guided workouts** row in ranked order, with figures and minutes, plus "See all".
- **Tappable cards:**
  - Every timeline card opens its page (`agendaRoute`): water, meals, habits, posture check, sleep, and guided workouts for body-plan sessions. Plan items are matched by name to a skill (e.g. "Practise Self-defence") or an exercise ("8 reverse lunges each side"), with the longest name winning.
  - Right-now cards open their page from anywhere on the card, while "Do it" keeps its quick action.
- **Exercise card** on the Health tab is now **Exercise & workouts** and opens guided workouts. The workouts screen links to the exercise library and the exercise log.

Verification: `flutter analyze` clean; `flutter test` 459 pass, 2 skipped. New tests cover the ranking, timeline routes, and the "Let's try" card rising with use and counting opens. The exercise and content flow tests were updated for the new entry point.

## Phase 37 — Day-wise training plan with auto level-up; redesigned setup (2026-10-26)

- **Training engine** (`domain/services/training_engine.dart`):
  - **Settings:** level (beginner, intermediate, advanced), 2–6 days a week, 10/20/30/45 minutes, equipment (none, or chair & backpack) and focus area (balanced, upper, lower). The focus defaults from gender — lower body & glutes for women, upper body for men — and can be changed.
  - **The week:** training days are spread out (2 → Mon/Thu, 3 → Mon/Wed/Fri…) with rest days between. Session types follow the main goal:
    - strength: upper, lower, core and full-body days, tilted toward the focus area;
    - weight or energy: full body and cardio;
    - posture: posture, core and mobility;
    - flexibility, mindfulness or sleep: yoga and mobility.
  - **Exercises:** 3–6 per session depending on time, each with sets × reps, holds or minutes, scaled by level. Beginners get incline push-ups; ages 55+ get low impact plus balance work; chair and backpack moves are added only with that equipment.
  - **Auto-adjust:** after each plan session the user picks Too easy, Just right or Too hard.
    - Too easy, or two Just right in a row for that day type, raises each exercise one step: +2 reps, +5 s or +2 min, and +1 set every 3 steps (5 at most).
    - Too hard lowers it one step.
    - Once the plan averages 4 steps up, the level rises and the steps reset, with a "Level up!" message.
- **My training plan** (`/health/training`):
  - A week strip (today outlined), each day's exercises with doses, Start, and a settings sheet. Its card sits at the top of Guided workouts.
  - Plan days play in the workout player (one step per set) under localized titles ("Lower body & glutes session") without cluttering the guided lists.
  - The finish screen asks "How did that feel?".
- **Home:** a **Today's workout** card (today's session with its first exercises and a play button, or a rest-day note) above Let's try.
- **Redesigned setup:**
  - A progress bar replaces the plain step count.
  - The welcome page shows the app icon and three promises: private, a plan made for you, all in one place.
  - New order: welcome → goals → preferences (units before height and weight) → about you → **your training** → privacy → permissions.
  - The training page pre-sets the focus from the gender chosen in About you and shows a live preview of the week. The choices are saved on finish.

Verification: `flutter analyze` clean; `flutter test` 470 pass, 2 skipped. New tests: 9 engine tests, the plan screen and Home card, playing a plan day to the end and "too easy" stepping it up, and the setup saving a gender-based focus and 4 days.

## Phase 38 — Shorter Home, search, swipe actions, portrait lock

- **Shorter Home:** the top keeps only what's next: greeting and ring, day strip, a search bar, Right now, Today's workout, Let's try and the timeline. Everything else (weekly review, mood and day mode, suggestions, journey, insights, quests, body summary) sits under **More for you**, one tap away.
- **Trimmed timeline:** today shows the next three open items and a **Show the full day (n)** button. Past days still show the whole day.
- **Swipe actions:** swipe a timeline item right to mark it done (or undo), left to skip it for today. The card stays and its state changes.
- **Home search** (`/home/search`): one field searching exercises, workouts, skills, meals, styles, answers and app screens, on the phone. Results open their page, and the first row asks the coach.
- **Portrait lock:** phones (shortest side under 600 dp) stay in portrait; tablets rotate freely. Camera screens restore this on exit.

Verification: `flutter analyze` clean; `flutter test` 473 pass, 2 skipped. New tests: the folded Home and full-day button, swipe-left skipping a habit, and search results with the ask-the-coach row. The test harness can turn the compact Home off (`compactHome`), and `reveal` now scrolls back up when the target is above.

## Phase 39 — Build your own workout; voice cues

- **Build your own** (`/health/exercise/programs/build`, card at the top of Guided workouts):
  - Name the workout, add exercises from a searchable list (built in and from installed packs), and put them in order.
  - Per exercise: reps or time, rest (5 s steps), and "each side". Rounds 1–6. The estimated length updates live.
  - Saved on the phone in app_settings (`myworkout.<id>`, so backups include it). The category is the most common among the chosen exercises.
  - Own workouts join the ranked lists (marked "Mine"), Home's Let's try row, and the player. Their page has Edit; the editor has Delete.
- **Voice cues** in the workout player, through the phone's own text-to-speech (offline voices, new `personality/speech` channel; nothing is downloaded or sent):
  - "Get ready. First: …", "Squat. 10 reps" or "… 30 seconds", "Rest. Next: …", "Switch sides", "Other side", a 3-2-1 countdown, and "Workout complete".
  - On by default. A speaker button in the player turns them off, and the choice is remembered (`voice.cues`).
  - If the phone has no voice for the app's language, it stays quiet instead of reading with the wrong voice.

Verification: `flutter analyze` clean; `flutter test` 476 pass, 2 skipped. New tests: building, saving, listing, editing and deleting a workout; the player's spoken lines and countdown, and turning voice off; the switch-sides cue.

## Phase 40 — Weekly backup reminder; What's new

- **Weekly backup reminder:** a Home card ("Time for a backup", with how many days it has been) appears once 7 days pass without an encrypted backup.
  - Back up now opens Backup; Later hides the card for 3 days.
  - A new install starts counting from its first run instead of reminding at once.
  - Switch on the Backup screen, on by default. State is in `backup.*` device settings, which are never put in backups.
  - The backup is not made silently in the background: that would mean storing the backup password on the phone, which weakens the encryption. The reminder keeps it to one tap.
- **What's new:** after an update, a Home card opens a list of the new features (training plan, build your own, voice cues, search, shorter Home and swipes, backup reminder). Each item opens that feature.
  - Seen once per release (`whatsnew.seen`, `whatsNewRelease = 40`). Closing the card also counts as seen.
  - A fresh install marks it seen at the end of setup.
  - Settings has a What's new entry to reopen it.

Verification: `flutter analyze` clean; `flutter test` 483 pass, 2 skipped. New tests: reminder timing, snooze and turning it off, the reminder on Home with Later and the Backup switch, no reminder on a new install, and What's new opening, linking to a feature, and dismissing. The test harness hides the What's new card unless `whatsNew: true`.

## Phase 41 — Full Home again

- At the user's request, Home always shows in full again: weekly review, mood and day mode, Right now, the whole timeline, Today's workout, Let's try, suggestions, journey, insights, quests, For you and body summary.
- The "More for you" fold and the trimmed timeline are removed. The new features stay: search bar, swipe done/skip, What's new and backup reminder cards.

Verification: `flutter analyze` clean; `flutter test` 482 pass, 2 skipped.

## Phase 42 — Livelier Home

- **Next three tasks:** today's timeline opens with an "Up next" list of the next three open tasks. "Show the full day" expands smoothly to every task; "Show less" folds it back. The rest of Home stays in full.
- **Time-of-day header:** a gradient card (morning amber, afternoon sky, evening violet, night navy) with a sun or moon that eases in, the greeting, the date and the daily-plan ring on a light pill.
- **Motion:** Home sections fade and slide in one after another; a ticked task's check springs in and its timeline dot fills smoothly; when every task is done a "Day complete!" card grows in with a burst of dots.
- All motion turns off with Reduce animations (AnimatedSize is skipped then, since it cannot run with a zero duration).

Verification: `flutter analyze` clean; `flutter test` 483 pass, 2 skipped. New test: the next-three timeline, full day and show less, and the header. Harness: `trimAgenda` (default off).
