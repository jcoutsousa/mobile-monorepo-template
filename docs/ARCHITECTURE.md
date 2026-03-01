# Architecture

## Monorepo Structure

```
├── apps/                    # Mobile applications
│   ├── flutter_<name>/      # Flutter apps
│   ├── rn_<name>/           # React Native apps
│   ├── kotlin_<name>/       # Kotlin/KMP apps
│   └── ios_<name>/          # Swift/iOS apps
│
├── web/                     # Web applications
│   ├── react_<name>/        # React apps
│   ├── vue_<name>/          # Vue.js apps
│   ├── nextjs_<name>/       # Next.js apps
│   └── angular_<name>/      # Angular apps
│
├── backends/                # Backend services
│   ├── node_<name>/         # Node.js services
│   ├── python_<name>/       # Python services
│   ├── go_<name>/           # Go services
│   └── rust_<name>/         # Rust services
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

### Mobile (`apps/`)

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

### Web (`web/`)

| Prefix | Framework | Example |
|--------|-----------|---------|
| `react_` | React | `web/react_myapp` |
| `vue_` | Vue.js | `web/vue_myapp` |
| `nextjs_` | Next.js | `web/nextjs_myapp` |
| `angular_` | Angular | `web/angular_myapp` |

### Backends (`backends/`)

| Prefix | Stack | Example |
|--------|-------|---------|
| `node_` | Node.js | `backends/node_api` |
| `python_` | Python | `backends/python_api` |
| `go_` | Go | `backends/go_api` |
| `rust_` | Rust | `backends/rust_api` |

The CI pipeline uses these prefixes to auto-detect frameworks and run the appropriate tools.

## Quality Gates

Every PR must pass before merge:

1. **CI Gate** -- Framework-specific lint, analyze, and test
2. **Code Quality Gate** -- Automated quality checks (duplicates, dead code, secrets)
3. **Copilot Review** -- AI-powered code review with custom instructions
4. **AI Compliance Gate** -- EU AI Act checks (only for AI components)

## Adding a New App

1. Create the app directory with the appropriate prefix:
   ```bash
   scripts/bootstrap.sh flutter myapp     # Mobile app in apps/
   scripts/bootstrap.sh react myapp       # Web app in web/
   scripts/bootstrap.sh python api        # Backend in backends/
   ```
2. The CI pipeline auto-detects the new app by its prefix and directory.
3. No workflow modifications needed.

## Adding a Shared Package

1. Create the package in `packages/` with the framework prefix.
2. Reference it from apps using the framework's dependency mechanism.
3. CI will automatically include it in the relevant pipeline.
