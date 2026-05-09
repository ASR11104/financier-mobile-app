# Finsight — Local Development Setup Guide

This guide walks you through setting up everything needed to run the Finsight app on your local machine.

---

## Prerequisites

### 1. Flutter SDK

Install Flutter SDK (version 3.38+ recommended):

```bash
# Option A: Using the official installer
# Download from https://docs.flutter.dev/get-started/install/linux/android

# Option B: Using snap (Ubuntu/Debian)
sudo snap install flutter --classic

# Option C: Manual install
cd ~/Developer  # or wherever you want Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/Developer/flutter/bin"
```

Add Flutter to your PATH permanently:
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/Flutter/flutter/bin"  # Adjust path to your installation
```

Verify installation:
```bash
flutter --version
```

### 2. Android Studio

Required for Android SDK, emulator, and build tools.

1. **Download**: [https://developer.android.com/studio](https://developer.android.com/studio)
2. **Install**:
   ```bash
   # Extract to /opt (or your preferred location)
   sudo tar -xzf android-studio-*.tar.gz -C /opt/
   /opt/android-studio/bin/studio.sh  # Launch and complete setup wizard
   ```
3. **During Setup Wizard**, install:
   - Android SDK (API 34 or latest)
   - Android SDK Command-line Tools
   - Android SDK Build-Tools
   - Android Emulator
   - Android SDK Platform-Tools

### 3. Android SDK Configuration

Set environment variables (add to `~/.bashrc` or `~/.zshrc`):
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

Accept Android licenses:
```bash
flutter doctor --android-licenses
```

### 4. Enable KVM (Required for Android Emulator on Linux)

The Android emulator requires hardware virtualization (KVM) on Linux:

```bash
# Check if your CPU supports virtualization
egrep -c '(vmx|svm)' /proc/cpuinfo
# If output > 0, your CPU supports it

# Install KVM
sudo apt install -y qemu-kvm libvirt-daemon-system

# Add yourself to the kvm group
sudo adduser $USER kvm

# Load the KVM kernel module
sudo modprobe kvm
sudo modprobe kvm_intel    # Intel CPUs
# sudo modprobe kvm_amd   # AMD CPUs (use this instead if you have AMD)

# Verify KVM is working
ls -la /dev/kvm
```

> [!IMPORTANT]
> If `modprobe kvm_intel` fails, you need to **enable VT-x/AMD-V in your BIOS**:
> 1. Reboot → enter BIOS (usually F2, Del, or F10)
> 2. Find **Intel Virtualization Technology (VT-x)** or **AMD-V/SVM**
> 3. Enable it → Save & Exit
>
> After changing the kvm group, **log out and log back in** for the change to take effect.

### 5. Android Emulator Setup

1. Open Android Studio → **Virtual Device Manager** (Tools > Device Manager)
2. Click **Create Virtual Device**
3. Select a device (e.g., **Pixel 8** or **Pixel 7 Pro**)
4. Select a system image (e.g., **API 34** with Google Play)
5. Finish and launch the emulator

Or via command line:
```bash
# List available system images
sdkmanager --list | grep system-images

# Install a system image
sdkmanager "system-images;android-34;google_apis;x86_64"

# Create AVD
avdmanager create avd -n Pixel_8_API_34 -k "system-images;android-34;google_apis;x86_64" -d "pixel_8"

# Launch emulator
emulator -avd Pixel_8_API_34
```

### 5. Verify Everything

Run Flutter doctor to check all dependencies:
```bash
flutter doctor -v
```

You should see green checkmarks (✓) for:
- ✓ Flutter
- ✓ Android toolchain
- ✓ Android Studio
- ✓ Connected device (when emulator is running)

> [!NOTE]
> Chrome and Linux toolchain are optional — we only need Android for this project.

---

## Running the Project

### First Time Setup

```bash
cd financier-mobile-app

# Get all dependencies
flutter pub get

# Run code generation (Drift, freezed, etc.)
dart run build_runner build --delete-conflicting-outputs

# Verify no lint errors
flutter analyze
```

### Running the App

```bash
# Start the emulator first (if not already running)
emulator -avd Pixel_8_API_34 &

# Run the app in debug mode with hot reload
flutter run

# Or specify a device if multiple are connected
flutter devices                    # List devices
flutter run -d <device_id>         # Run on specific device
```

### Useful Development Commands

```bash
# Hot reload (in running terminal)
r                                  # Hot reload
R                                  # Hot restart

# Code generation (run after changing Drift tables, freezed classes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation (auto-regenerates on file changes)
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|:---|:---|
| `flutter doctor` shows Android license issues | Run `flutter doctor --android-licenses` and accept all |
| Emulator won't start (KVM error) | Enable virtualization in BIOS, install KVM: `sudo apt install qemu-kvm` |
| `build_runner` fails | Run with `--delete-conflicting-outputs` flag |
| Hot reload not working | Try hot restart (`R`) or stop and re-run `flutter run` |
| Gradle build fails | Delete `.gradle` folder and run `flutter clean && flutter pub get` |
