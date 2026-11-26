# NutriAI

NutriAI generates meal plans and shopping lists from your food preferences,
allergies, and nutrition goals. The app supports English and Spanish. Meal
planning runs on the device and does not require a server or API key.

## Set up

Install [Flutter 3.41.0 (stable)](https://docs.flutter.dev/install/archive),
which includes Dart 3.11.0, and add Flutter to your PATH.

```sh
flutter --version
flutter doctor
flutter pub get --enforce-lockfile
```

## Run or build for web

Install Chrome, then run:

```sh
flutter run -d chrome
flutter build web --no-pub
```

The web build is generated in `build/web/`. Ads are disabled on web.

## Run or build for Android

Install JDK 17 and the [Flutter Android toolchain](https://docs.flutter.dev/platform-integration/android/setup),
including Android SDK Platform 36. Use a connected device or start an Android
emulator.

```sh
flutter doctor --android-licenses
flutter devices
flutter run -d emulator-5554
flutter build apk --release --no-pub
```

Replace `emulator-5554` with the device ID shown by `flutter devices`. The APK
is generated at `build/app/outputs/flutter-apk/app-release.apk`. Without local
release signing configuration, it uses the debug key and is not a store release.

## Checks

```sh
flutter analyze --no-pub
flutter test --no-pub
flutter build web --no-pub
```

GitHub Actions runs these checks on pushes and pull requests. The separate
APK workflow builds and uploads an Android APK on pushes.
