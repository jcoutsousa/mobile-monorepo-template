# Apps — Mobile Applications

This directory contains mobile and native applications. Each app lives in its own subdirectory, prefixed by framework name.

For web applications, see [`web/`](../web/). For backend services, see [`backends/`](../backends/). For shared libraries, see [`packages/`](../packages/).

## Naming Convention

| Prefix | Framework | Marker File | Example |
|--------|-----------|-------------|---------|
| `flutter_` | Flutter | `pubspec.yaml` | `flutter_myapp/` |
| `rn_` | React Native | `package.json` | `rn_myapp/` |
| `kotlin_` | Kotlin / KMP | `build.gradle.kts` | `kotlin_myapp/` |
| `ios_` | Swift / iOS | `Package.swift` | `ios_myapp/` |

Alternative prefixes also recognized by CI: `react_native_`, `kmp_`, `swift_`.

## Bootstrap Commands

```bash
# Using the bootstrap script directly
./scripts/bootstrap.sh flutter myapp       # → apps/flutter_myapp/
./scripts/bootstrap.sh rn myapp            # → apps/rn_myapp/
./scripts/bootstrap.sh kotlin myapp        # → apps/kotlin_myapp/
./scripts/bootstrap.sh swift myapp         # → apps/ios_myapp/

# Using the Makefile
make bootstrap-flutter APP=myapp
make bootstrap-rn APP=myapp
make bootstrap-kotlin APP=myapp
make bootstrap-swift APP=myapp
```

## What CI Runs

When files in `apps/` change on a PR, the CI pipeline auto-detects the framework and runs:

| Framework | CI Job | Steps |
|-----------|--------|-------|
| Flutter | `flutter-ci` | `flutter pub get` → `flutter analyze` → `flutter test --coverage` |
| React Native | `react-native-ci` | `npm ci` → `eslint` → `tsc --noEmit` → `npm test --coverage` |
| Kotlin | `kotlin-ci` | `gradlew detekt` (if configured) → `gradlew test` |
| Swift | `swift-ci` | `swift build` → `swift test` (or `xcodebuild` for `.xcodeproj`) |

No workflow modifications are needed when adding a new app. The CI pipeline detects it by the directory prefix.

## Deployment

Mobile apps are deployed via manual-trigger CD workflows:

- **Android**: `cd-android.yml` — deploys to Google Play Store (internal / alpha / beta / production tracks)
- **iOS**: `cd-ios.yml` — deploys to TestFlight or App Store

## Guidelines

- Each app should be self-contained with its own dependencies and configuration.
- Shared code belongs in [`packages/`](../packages/), not duplicated across apps.
- All apps must include tests. CI will run them automatically.
