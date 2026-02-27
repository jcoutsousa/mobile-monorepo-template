#!/usr/bin/env bash
set -euo pipefail

# ─── Mobile Monorepo Bootstrap Script ───────────────────────
# Usage:
#   ./scripts/bootstrap.sh <framework> <app-name> [--package]
#
# Examples:
#   ./scripts/bootstrap.sh flutter myapp          # Creates apps/flutter_myapp
#   ./scripts/bootstrap.sh rn myapp               # Creates apps/rn_myapp
#   ./scripts/bootstrap.sh kotlin myapp            # Creates apps/kotlin_myapp
#   ./scripts/bootstrap.sh flutter utils --package # Creates packages/flutter_utils

FRAMEWORK="${1:-}"
APP_NAME="${2:-}"
IS_PACKAGE="${3:-}"

if [ -z "$FRAMEWORK" ] || [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <framework> <app-name> [--package]"
  echo ""
  echo "Frameworks: flutter, rn, kotlin, swift"
  echo ""
  echo "Examples:"
  echo "  $0 flutter myapp          # New Flutter app"
  echo "  $0 rn myapp               # New React Native app"
  echo "  $0 kotlin myapp            # New Kotlin app"
  echo "  $0 flutter utils --package # New shared Flutter package"
  exit 1
fi

# Determine target directory
if [ "$IS_PACKAGE" = "--package" ]; then
  TARGET="packages/${FRAMEWORK}_${APP_NAME}"
else
  TARGET="apps/${FRAMEWORK}_${APP_NAME}"
fi

if [ -d "$TARGET" ]; then
  echo "Error: $TARGET already exists"
  exit 1
fi

echo "Creating $TARGET..."

case "$FRAMEWORK" in
  flutter)
    if [ "$IS_PACKAGE" = "--package" ]; then
      flutter create --template=package "$TARGET"
    else
      flutter create --org com.example "$TARGET"
    fi
    echo "✅ Flutter project created at $TARGET"
    echo "   Run: cd $TARGET && flutter pub get"
    ;;

  rn|react-native)
    if command -v npx &>/dev/null; then
      npx react-native init "${APP_NAME}" --directory "$TARGET"
    else
      echo "Error: npx not found. Install Node.js first."
      exit 1
    fi
    echo "✅ React Native project created at $TARGET"
    echo "   Run: cd $TARGET && npm install"
    ;;

  kotlin|kmp)
    mkdir -p "$TARGET/src/main/kotlin" "$TARGET/src/test/kotlin"
    cat > "$TARGET/build.gradle.kts" << 'GRADLE'
plugins {
    kotlin("jvm") version "1.9.22"
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}
GRADLE
    echo "✅ Kotlin project created at $TARGET"
    echo "   Run: cd $TARGET && ./gradlew build"
    ;;

  swift|ios)
    mkdir -p "$TARGET/Sources" "$TARGET/Tests"
    cat > "$TARGET/Package.swift" << SWIFT
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "${APP_NAME}",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "${APP_NAME}", targets: ["${APP_NAME}"]),
    ],
    targets: [
        .target(name: "${APP_NAME}"),
        .testTarget(name: "${APP_NAME}Tests", dependencies: ["${APP_NAME}"]),
    ]
)
SWIFT
    echo "✅ Swift project created at $TARGET"
    echo "   Run: cd $TARGET && swift build"
    ;;

  *)
    echo "Error: Unknown framework '$FRAMEWORK'"
    echo "Supported: flutter, rn, kotlin, swift"
    exit 1
    ;;
esac

echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Start developing"
echo "  3. CI will auto-detect the new project on your next PR"
