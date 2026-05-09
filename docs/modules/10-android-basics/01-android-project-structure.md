# Android Project Structure

When you create a Flutter app, a complete Android project is generated in the `android/` folder. You usually don't touch most of it, but knowing what's there prevents confusion.

## The android/ folder

```
android/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── AndroidManifest.xml    ← app declaration
│   │       ├── kotlin/                ← native Kotlin code (rarely touched)
│   │       └── res/                   ← app icon, launcher image
│   └── build.gradle                  ← app-level build config
├── build.gradle                       ← project-level build config
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties  ← which Gradle version to use
└── local.properties                   ← local paths (not committed to git)
```

## AndroidManifest.xml

The manifest declares your app to the Android OS. Open `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:name="${applicationName}"
        android:label="Finsight"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            <!-- This is the entry point — the app starts here -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

**You edit the manifest when you need to:**
- Add permissions: `<uses-permission android:name="android.permission.CAMERA"/>`
- Add deep link URL schemes
- Change app name or icon
- Configure launch mode

## build.gradle (app-level)

Controls how the app is compiled. The important settings:

```gradle
android {
    compileSdkVersion 34         // compile against Android 14 APIs
    
    defaultConfig {
        applicationId "com.yourname.finsight"  // unique app ID on Play Store
        minSdkVersion 21          // minimum: Android 5.0 (covers 99% of devices)
        targetSdkVersion 34       // target: Android 14
        versionCode 1             // integer version for Play Store updates
        versionName "1.0.0"       // human-readable version
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release  // for Play Store signing
        }
    }
}
```

**`minSdkVersion`** is the oldest Android version that can install the app. 21 (Android 5.0) is the standard minimum — it covers essentially all active devices.

**`versionCode`** must increment with every Play Store release. If you upload version code 1 then 2, users on 1 get the update. You can never go backward.

## pubspec.yaml — Flutter's manifest

Flutter uses `pubspec.yaml` instead of a separate manifest for package management:

```yaml
name: financier_mobile_app
description: Finsight personal finance app
version: 1.0.0+1        # versionName+versionCode

environment:
  sdk: ">=3.0.0 <4.0.0"  # Dart SDK version constraint

dependencies:
  flutter:
    sdk: flutter
  drift: ^2.22.1
  flutter_riverpod: ^2.6.1
  # ...

dev_dependencies:
  build_runner: ^2.4.14
  # ...
```

The `version: 1.0.0+1` format maps to:
- `versionName: 1.0.0` (shown to users)
- `versionCode: 1` (used by Play Store)

## App icons

The launcher icon (what appears on the home screen) is in `android/app/src/main/res/mipmap-*/ic_launcher.png`. There are different densities:
- `mipmap-mdpi` — 48×48px (low density)
- `mipmap-hdpi` — 72×72px
- `mipmap-xhdpi` — 96×96px
- `mipmap-xxhdpi` — 144×144px
- `mipmap-xxxhdpi` — 192×192px (high-end phones)

Android picks the right one for the screen density. Use the `flutter_launcher_icons` package to automate generating all sizes from one source image.

---

**Next:** [02-build-run-deploy.md](02-build-run-deploy.md)
