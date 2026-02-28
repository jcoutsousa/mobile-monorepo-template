#!/usr/bin/env bash
# ─── Flutter / Dart ─────────────────────────────────────────

FRAMEWORK_NAME="Flutter"
FRAMEWORK_PREFIXES=("flutter_" "dart_")
FRAMEWORK_DETECT_FILE="pubspec.yaml"
FRAMEWORK_EXTENSIONS=(".dart")

FRAMEWORK_INSTALL_CMD="flutter pub get"
FRAMEWORK_LINT_CMD="flutter analyze --no-fatal-infos"
FRAMEWORK_TEST_CMD="flutter test"
FRAMEWORK_FORMAT_CMD="dart format ."
FRAMEWORK_CLEAN_CMD="flutter clean"

ci_setup() {
  echo "uses: subosito/flutter-action@v2"
  echo "with:"
  echo "  channel: stable"
  echo "  cache: true"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  if [ "$is_package" = "true" ]; then
    flutter create --template=package "$target"
  else
    flutter create --org com.example "$target"
  fi
}
