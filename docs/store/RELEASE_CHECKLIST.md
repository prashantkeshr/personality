# Release checklist — Google Play

## One-time setup

1. **Create the upload key** (you type the password; nothing is shared):
   ```
   powershell -ExecutionPolicy Bypass -File tool\make_upload_key.ps1
   ```
   This writes `android/upload-keystore.jks` and `android/key.properties` (both git-ignored).
   **Back up both files** in a password manager or another safe place.
2. **Host the privacy policy** (`docs/store/privacy-policy.html`) at a public URL, for example
   `https://personality.dhurta.org/privacy` or GitHub Pages, and paste the URL into Play Console and `PLAY_LISTING.md`.
3. **Play Console**: create the app ("Personality: Wellness & Style", Free, App), turn on **Play App Signing** (default), and fill in:
   store listing (`PLAY_LISTING.md`), graphics (`docs/store/graphics/`), data safety, content rating, target audience,
   health apps declaration and the Health Connect permissions form.

## Every release

1. Bump `version:` in `pubspec.yaml` (`1.0.0+1` → e.g. `1.0.1+2`; the number after `+` must always increase).
2. `flutter analyze` and `flutter test` must be clean.
3. Build the bundle (obfuscated, with symbols kept for crash reading):
   ```
   flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
   ```
   Output: `build/app/outputs/bundle/release/app-release.aab`. Keep `build/symbols` for this version.
4. Check it is signed with the upload key (not "Android Debug"):
   ```
   keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
   ```
5. Upload to **Internal testing** first, install from the Play link on a real phone, check camera features, reminders, widgets and pack downloads, then promote to Production.

## Sizes (Phase 34 build)

- App bundle: 139 MB (Play serves each phone only its own part).
- Typical download from Play (arm64): ~70 MB. Split APKs for side-loading:
  `flutter build apk --release --split-per-abi` → arm64 70 MB, armv7 63 MB, x86_64 74 MB.

## Not included / later

- iOS (needs a Mac and an Apple developer account).
- Photos for the 22 newer hairstyles (drawn illustrations are used until photos are approved).
