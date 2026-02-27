# Packages

Shared libraries and utilities used across multiple apps.

## Naming Convention

Same prefix convention as `apps/`:

| Prefix | Framework | Example |
|--------|-----------|---------|
| `flutter_` / `dart_` | Dart | `dart_utils/` |
| `rn_` | JS/TS | `rn_shared/` |
| `kotlin_` / `kmp_` | Kotlin | `kmp_core/` |
| `swift_` | Swift | `swift_networking/` |

## Create a New Package

```bash
./scripts/bootstrap.sh flutter utils --package
./scripts/bootstrap.sh kotlin core --package
```

## Guidelines

- Packages must not depend on app-specific code.
- Keep packages focused — one responsibility per package.
- All packages must have tests.
