# Architecture

## Monorepo Structure

```
├── apps/                    # Applications (any framework)
│   ├── <prefix>_<name>/     # Prefix determined by framework plugin
│   └── ...
│
├── packages/                # Shared libraries
│   ├── <prefix>_<name>/     # Same prefix convention
│   └── ...
│
├── frameworks/              # Framework plugins (extensible)
│   ├── _template.sh         # Template for new frameworks
│   ├── flutter.sh
│   ├── react-native.sh
│   ├── kotlin.sh
│   ├── swift.sh
│   ├── python.sh
│   └── go.sh
│
├── infrastructure/          # Infrastructure-as-Code
│   ├── terraform/
│   ├── kubernetes/
│   └── scripts/
│
├── docs/                    # Documentation
│
├── scripts/                 # Utility scripts
│
└── .github/                 # GitHub configuration
    ├── agents/              # Copilot custom agents
    ├── skills/              # Copilot agent skills
    ├── instructions/        # Copilot code review rules (per language)
    ├── workflows/           # CI/CD + Agentic Workflows
    └── ISSUE_TEMPLATE/
```

## Plugin System

The `frameworks/` directory is the core extensibility mechanism. Each `.sh` file defines:

| Variable | Purpose | Example |
|----------|---------|---------|
| `FRAMEWORK_NAME` | Display name | `"Flutter"` |
| `FRAMEWORK_PREFIXES` | Directory prefixes | `("flutter_" "dart_")` |
| `FRAMEWORK_DETECT_FILE` | File that identifies projects | `"pubspec.yaml"` |
| `FRAMEWORK_EXTENSIONS` | Source file extensions | `(".dart")` |
| `FRAMEWORK_*_CMD` | Commands for lint, test, format, clean | `"flutter analyze"` |
| `scaffold()` | Function that creates new projects | Creates files/dirs |

### How detection works

1. **Bootstrap** reads plugins to discover available frameworks
2. **CI** reads plugins to detect which frameworks have changes and runs the appropriate commands
3. **Makefile** reads plugins to find apps by their detect file and run framework commands
4. **Quality gate** reads plugins to determine which linters to run based on changed file extensions

### Naming Conventions

Each framework plugin defines its prefixes. Built-in frameworks:

| Prefix | Framework | Detect File |
|--------|-----------|-------------|
| `flutter_`, `dart_` | Flutter/Dart | `pubspec.yaml` |
| `rn_`, `react_native_` | React Native | `package.json` |
| `kotlin_`, `kmp_` | Kotlin | `build.gradle.kts` |
| `ios_`, `swift_` | Swift | `Package.swift` |
| `py_`, `python_` | Python | `pyproject.toml` |
| `go_` | Go | `go.mod` |

## Quality Gates

Every PR must pass before merge:

1. **CI Gate** — Reads framework plugins, runs lint + test per detected framework
2. **Code Quality Gate** — Cross-language checks (secrets, TODOs, duplicates) + framework linters
3. **Copilot Review** — AI-powered code review with per-language instructions
4. **AI Compliance Gate** — EU AI Act checks (only for AI components)

## Adding a New Framework

1. Copy `frameworks/_template.sh` to `frameworks/<name>.sh`
2. Set variables and implement `scaffold()`
3. Optionally add `.github/instructions/<name>.instructions.md`
4. CI and Makefile pick it up automatically — no workflow changes needed

## Adding a New App

```bash
./scripts/bootstrap.sh <framework> <name>
```

The CI pipeline auto-detects the new app by its prefix and detect file.

## Adding a Shared Package

```bash
./scripts/bootstrap.sh <framework> <name> --package
```

Creates the package in `packages/` with the framework prefix. Reference it from apps using the framework's dependency mechanism.
