# Architecture

## Monorepo Structure

```
├── apps/                    # Mobile applications
│   ├── flutter_<name>/      # Flutter apps
│   ├── rn_<name>/           # React Native apps
│   ├── kotlin_<name>/       # Kotlin/KMP apps
│   └── ios_<name>/          # Swift/iOS apps
│
├── packages/                # Shared libraries
│   ├── flutter_<name>/      # Dart/Flutter packages
│   ├── rn_<name>/           # JS/TS shared packages
│   └── kotlin_<name>/       # Kotlin shared modules
│
├── infrastructure/          # Infrastructure-as-Code
│   ├── terraform/           # Terraform modules
│   ├── kubernetes/          # K8s manifests
│   └── scripts/             # Infra scripts
│
├── docs/                    # Documentation
│
├── scripts/                 # Utility scripts
│
└── .github/                 # GitHub configuration
    ├── agents/              # Copilot custom agents
    ├── skills/              # Copilot agent skills
    ├── instructions/        # Copilot code review rules
    ├── workflows/           # CI/CD + Agentic Workflows
    └── ISSUE_TEMPLATE/      # Issue templates
```

## Naming Conventions

| Prefix | Framework | Example |
|--------|-----------|---------|
| `flutter_` | Flutter/Dart | `apps/flutter_myapp` |
| `dart_` | Dart (non-Flutter) | `packages/dart_utils` |
| `rn_` | React Native | `apps/rn_myapp` |
| `react_native_` | React Native (alt) | `apps/react_native_myapp` |
| `kotlin_` | Kotlin | `apps/kotlin_myapp` |
| `kmp_` | Kotlin Multiplatform | `packages/kmp_shared` |
| `ios_` | Swift/iOS native | `apps/ios_myapp` |
| `swift_` | Swift (non-iOS) | `packages/swift_utils` |

The CI pipeline uses these prefixes to auto-detect frameworks and run the appropriate tools.

## Quality Gates

Every PR must pass before merge:

1. **CI Gate** — Framework-specific lint, analyze, and test
2. **Code Quality Gate** — Automated quality checks (duplicates, dead code, secrets)
3. **Copilot Review** — AI-powered code review with custom instructions
4. **AI Compliance Gate** — EU AI Act checks (only for AI components)

## Adding a New App

1. Create the app directory with the appropriate prefix:
   ```bash
   scripts/bootstrap.sh flutter myapp
   ```
2. The CI pipeline auto-detects the new app by its prefix.
3. No workflow modifications needed.

## Adding a Shared Package

1. Create the package in `packages/` with the framework prefix.
2. Reference it from apps using the framework's dependency mechanism.
3. CI will automatically include it in the relevant pipeline.
