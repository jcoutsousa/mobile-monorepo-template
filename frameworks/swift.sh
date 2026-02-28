#!/usr/bin/env bash
# ─── Swift / iOS ────────────────────────────────────────────

FRAMEWORK_NAME="Swift"
FRAMEWORK_PREFIXES=("ios_" "swift_")
FRAMEWORK_DETECT_FILE="Package.swift"
FRAMEWORK_EXTENSIONS=(".swift")

FRAMEWORK_INSTALL_CMD="swift package resolve"
FRAMEWORK_LINT_CMD="swift build 2>&1 | grep -E '(warning|error)' || true"
FRAMEWORK_TEST_CMD="swift test"
FRAMEWORK_FORMAT_CMD=""
FRAMEWORK_CLEAN_CMD="swift package clean"

ci_setup() {
  echo "# Swift is pre-installed on macos runners"
  echo "# Use: runs-on: macos-latest"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  mkdir -p "$target/Sources/${name}" "$target/Tests/${name}Tests"
  cat > "$target/Package.swift" << SWIFT
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "${name}",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "${name}", targets: ["${name}"]),
    ],
    targets: [
        .target(name: "${name}"),
        .testTarget(name: "${name}Tests", dependencies: ["${name}"]),
    ]
)
SWIFT
}
