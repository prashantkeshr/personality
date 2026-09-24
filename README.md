# Personality

A private, offline-first personal wellness and style app. It covers body, posture, health, habits, routines, grooming and clothing, with optional on-device AI.

- **Privacy first**: camera analysis runs on-device, and frames are discarded by default.
- **Offline first**: all core tracking works without internet.
- **AI optional**: deterministic engines drive every result; local AI only explains.

## Development

Toolchain lives in `C:\dev` (Flutter, JDK 17, Android SDK, Gradle and pub caches).

```bash
flutter pub get
flutter analyze
flutter test
flutter emulators --launch personality_pixel
flutter run
```

Docs: [Architecture](docs/ARCHITECTURE.md) · [Data model](docs/DATA_MODEL.md) · [Design system](docs/DESIGN_SYSTEM.md) · [Phases](docs/PHASES.md)

Wellness and lifestyle app. Not a medical device and does not provide diagnosis.
