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
