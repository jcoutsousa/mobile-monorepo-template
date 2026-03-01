# Packages — Shared Libraries

This directory holds shared libraries and utilities used across multiple projects in the monorepo. Any framework's shared code can live here, consumed by apps in `apps/`, `web/`, or `backends/`.

## Naming Convention

Use the same prefix convention as the consuming framework:

| Prefix | Framework | Example |
|--------|-----------|---------|
| `flutter_` / `dart_` | Dart / Flutter | `dart_utils/`, `flutter_widgets/` |
| `rn_` | JS/TS (React Native) | `rn_shared/` |
| `kotlin_` / `kmp_` | Kotlin / KMP | `kmp_core/` |
| `swift_` | Swift | `swift_networking/` |
| `node_` | Node.js / JS/TS | `node_common/` |
| `python_` | Python | `python_helpers/` |
| `go_` | Go | `go_utils/` |
| `rust_` | Rust | `rust_common/` |

## Bootstrap Commands

```bash
# Using the bootstrap script with --package flag
./scripts/bootstrap.sh flutter utils --package    # → packages/flutter_utils/
./scripts/bootstrap.sh kotlin core --package      # → packages/kotlin_core/
./scripts/bootstrap.sh node common --package      # → packages/node_common/
./scripts/bootstrap.sh python helpers --package   # → packages/python_helpers/
./scripts/bootstrap.sh go utils --package         # → packages/go_utils/
./scripts/bootstrap.sh rust common --package      # → packages/rust_common/

# Using the Makefile
make bootstrap-package FW=flutter APP=utils
make bootstrap-package FW=kotlin APP=core
```

## Cross-Stack Sharing Patterns

Reference packages from apps using each framework's native dependency mechanism:

| Framework | How to Reference |
|-----------|-----------------|
| Flutter / Dart | `pubspec.yaml` path dependency: `path: ../../packages/dart_utils` |
| React Native / Node.js | `package.json` workspace or relative path |
| Kotlin / KMP | Gradle composite build or project dependency |
| Swift | `Package.swift` local package dependency |
| Python | `pip install -e ../../packages/python_helpers` or path dependency in `pyproject.toml` |
| Go | `go.mod` replace directive for local path |
| Rust | `Cargo.toml` path dependency: `path = "../../packages/rust_common"` |

## What CI Runs

Packages are included in CI based on their prefix:

| Package Prefix | Included In CI Job |
|---------------|--------------------|
| `flutter_*`, `dart_*` | `flutter-ci` |
| `rn_*` | `react-native-ci` |
| `kotlin_*`, `kmp_*` | `kotlin-ci` |
| `swift_*` | `swift-ci` |
| `node_*` | `web-ci` and `backend-ci` |
| `python_*`, `go_*`, `rust_*` | `backend-ci` |

When a package changes, CI runs for both the package and any apps/services that depend on it (via the path filter grouping in `ci.yml`).

## Guidelines

- Packages must not depend on app-specific code. Dependencies flow one way: apps depend on packages.
- Keep packages focused -- one responsibility per package.
- All packages must have tests.
- Use semantic versioning if publishing packages to a registry.
