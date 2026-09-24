# Data Model & Database Design

Encrypted SQLite (Drift + SQLCipher). All ids are UUID v4 strings so records
survive export/backup merges. All timestamps are stored as UTC epoch millis.

## Common columns

Every table: `id`, `created_at`, `updated_at`.

Measurement tables additionally carry the **provenance block**:

| Column | Type | Notes |
|---|---|---|
| value | REAL | canonical unit (cm, kg, ml, minutes…) |
| unit | TEXT | canonical unit stored; display converts |
| source | TEXT | `USER_ENTERED`, `CAMERA_DERIVED`, `DEVICE_DERIVED`, `HEALTH_PLATFORM`, `CALCULATED`, `IMPORTED`, `AI_GENERATED` |
| method | TEXT? | e.g. "Manual measurement", "Pose landmarks + reference card" |
| confidence | TEXT? | `LOW` / `MEDIUM` / `HIGH`; required for camera/AI sources |
| lower_bound / upper_bound | REAL? | estimate range |
| recorded_at | INTEGER | when the observation applies |
| notes | TEXT? | |

Canonical storage units: cm, kg, ml, minutes, steps. Imperial is display-only.

## Entities by phase

| Phase | Tables |
|---|---|
| 1 Foundation | `app_settings`, `feature_flag`, `schema_meta` |
| 2 Profile + Body | `user_profile`, `goal`, `height_record`, `weight_record`, `body_measurement` (type column: shoulder, chest, waist, hip, arm, leg, torso, inseam, neck, custom), `body_proportion` (CALCULATED snapshots) |
| 3 Health | `water_log`, `meal`, `sleep_log`, `activity_log`, `exercise_session`, `habit`, `habit_completion` |
| 4 Routines | `routine`, `routine_item`, `routine_completion`, `reminder`, `reminder_history` |
| 6 Posture | `posture_session`, `posture_metric` |
| 7 Exercise | `exercise` (library, seeded from assets), `exercise_progress` |
| 8 Face + Grooming | `face_analysis`, `face_metric`, `hairstyle_favorite`, `grooming_routine` |
| 9 Style | `style_profile`, `color_profile`, `wardrobe_item`, `outfit`, `outfit_item`, `accessory` |
| 10 Recommendations | `recommendation`, `recommendation_history`, `evolution_event` |
| 11 AI | `ai_model`, `model_version`, `ai_conversation`, `ai_message` |
| 12 Health integrations | `health_platform_data` |
| 13 Backup | `backup_metadata` |

## Key rules

- **Height**: the canonical height is the most recent `USER_ENTERED` record unless the user explicitly selects another record. Camera estimates are stored as ranges and never silently replace manual values. Short-term variation is not presented as growth.
- **Plan vs actual**: completion tables store `status` (`completed`, `skipped`, `missed`, `rescheduled`) so adherence and performance stay separate.
- **Camera media**: no image columns. Saved photos (opt-in only) live in app-private storage with a `media` row, and they are deletable from the Privacy Center.
- **Indexes**: `(recorded_at)` on every log table, plus `(type, recorded_at)` on measurements.

## Migrations

`schemaVersion` starts at 1. Every change adds a step in `MigrationStrategy.onUpgrade`, with a Drift schema snapshot (`drift_schemas/`) and generated migration tests. Destructive migrations are forbidden; columns are added and data is copied forward.
