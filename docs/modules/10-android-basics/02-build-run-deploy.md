# Build, Run, and Deploy

## Running the app in development

```bash
# List available devices and emulators
flutter devices

# Run on a specific device
flutter run -d emulator-5554     # emulator
flutter run -d R58M123ABCD       # physical device (device ID)

# Run on all connected devices
flutter run -d all
```

When the app is running, the terminal shows a menu of commands:

```
Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate flutter run but leave app running).
c Clear the screen.
q Quit (terminate the app on the device).
```

## Hot Reload vs Hot Restart

**Hot Reload (`r`)** — The fastest way to see changes:
- Injects new code into the running Dart VM
- Rebuilds the widget tree
- Preserves state (scroll position, form data, navigation)
- Takes ~1 second
- Works for: widget changes, text changes, style changes

**Hot Restart (`R`)** — Restarts the app completely:
- Restarts the Dart VM
- Clears all state
- Takes ~3-5 seconds
- Works for: any change, including changes to `main()` or initialization code

Hot Reload does NOT work for:
- Changes to `main()`
- Changes to static fields
- Changes to enum values
- Adding a new native dependency

Use Hot Restart in those cases.

## Debug vs Profile vs Release

```bash
flutter run                    # debug (default) — slow, has dev tools overlay
flutter run --profile          # profile — release speed, keeps dev tools
flutter run --release          # release — maximum performance, no dev tools
```

Always test performance in `--profile` or `--release` mode. Debug mode has significant overhead (assertions, VM service, etc.) that makes it appear slower than the shipped app.

## Building APKs

```bash
# Debug APK — for testing on physical devices
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk

# Release APK — for distribution (requires signing key)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Split APKs by ABI (smaller downloads)
flutter build apk --split-per-abi
# Generates: app-arm64-v8a-release.apk, app-armeabi-v7a-release.apk, etc.
```

## Building App Bundle (for Play Store)

```bash
flutter build appbundle
# Output: build/app/outputs/bundle/release/app-release.aab
```

The App Bundle is the modern format for Play Store uploads. Google splits it per device architecture and screen density — users download a smaller app.

## Installing on a device

```bash
# Install a debug APK on a connected device
adb install build/app/outputs/flutter-apk/app-debug.apk

# Or just use flutter run — it installs and launches in one step
flutter run
```

## Signing for release

Debug builds are auto-signed with a debug key. For a Play Store release, you need a keystore:

```bash
# Generate a keystore (one-time setup)
keytool -genkey -v -keystore ~/finsight.jks -keyalg RSA -keysize 2048 -validity 10000 -alias finsight

# Reference it in android/key.properties:
storePassword=your_password
keyPassword=your_password
keyAlias=finsight
storeFile=/home/you/finsight.jks
```

Then reference `key.properties` in `android/app/build.gradle`.

## Flutter DevTools

DevTools is a browser-based suite of debugging tools:

```bash
# While the app is running:
flutter pub global run devtools
# Or: in VS Code, click "Open DevTools" in the Flutter panel
```

Key tools:
- **Widget Inspector** — shows the widget tree, select any widget to see its properties
- **Performance** — frame rendering timeline, identify jank (frames > 16ms)
- **Memory** — track allocations, find memory leaks
- **Network** — monitor HTTP requests (not relevant for Finsight — no network)
- **Logging** — all `print()` / `debugPrint()` output

## Common commands

```bash
flutter doctor          # check your development environment
flutter pub get         # install dependencies
flutter pub upgrade     # upgrade all dependencies to latest compatible versions
flutter clean           # delete build artifacts (fix weird build errors)
flutter analyze         # run the Dart static analyzer (lint checks)
dart format lib/        # format all Dart files
```

**`flutter clean` + `flutter pub get`** fixes most mysterious build errors.

---

**You've completed Module 10!** Move on to [Module 11 — Build a Feature](../11-build-a-feature/README.md).
