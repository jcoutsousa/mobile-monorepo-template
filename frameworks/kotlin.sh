#!/usr/bin/env bash
# ─── Kotlin / KMP ──────────────────────────────────────────

FRAMEWORK_NAME="Kotlin"
FRAMEWORK_PREFIXES=("kotlin_" "kmp_")
FRAMEWORK_DETECT_FILE="build.gradle.kts"
FRAMEWORK_EXTENSIONS=(".kt" ".kts")

FRAMEWORK_INSTALL_CMD=""
FRAMEWORK_LINT_CMD="./gradlew detekt 2>/dev/null || echo 'detekt not configured, skipping'"
FRAMEWORK_TEST_CMD="./gradlew test"
FRAMEWORK_FORMAT_CMD="./gradlew ktlintFormat 2>/dev/null || true"
FRAMEWORK_CLEAN_CMD="./gradlew clean"

ci_setup() {
  echo "uses: actions/setup-java@v4"
  echo "with:"
  echo "  distribution: temurin"
  echo "  java-version: 17"
  echo "  cache: gradle"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  mkdir -p "$target/src/main/kotlin" "$target/src/test/kotlin"
  cat > "$target/build.gradle.kts" << GRADLE
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

  cat > "$target/settings.gradle.kts" << SETTINGS
rootProject.name = "${name}"
SETTINGS
}
