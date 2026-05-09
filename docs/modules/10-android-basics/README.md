# Module 10 — Android Basics

Flutter compiles to Android (and iOS), but you need some understanding of the Android project structure, build system, and deployment.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-android-project-structure.md](01-android-project-structure.md) | AndroidManifest, gradle, why these files exist |
| [02-build-run-deploy.md](02-build-run-deploy.md) | Running the app, hot reload, building APKs, release builds |

## Project files to read alongside this module

- `android/app/src/main/AndroidManifest.xml` — app manifest
- `android/app/build.gradle` — build configuration
- `pubspec.yaml` — Flutter's package manifest

## Exercise for this module

1. Run the app on an emulator: `flutter run`
2. While it's running, press `r` to hot reload after changing some text in `accounts_page.dart`
3. Press `R` to hot restart and observe the difference
4. Build a debug APK: `flutter build apk --debug` — find it in `build/app/outputs/flutter-apk/`
