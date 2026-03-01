# Architecture

This document describes the monorepo structure, naming conventions, CI/CD architecture, and infrastructure layout. It serves as the technical reference for contributors and maintainers.

## Monorepo Structure

```
├── apps/                         # Mobile applications
│   ├── flutter_<name>/           #   Flutter apps (pubspec.yaml)
│   ├── rn_<name>/                #   React Native apps (package.json)
│   ├── kotlin_<name>/            #   Kotlin/KMP apps (build.gradle.kts)
│   └── ios_<name>/               #   Swift/iOS apps (Package.swift)
│
├── web/                          # Web applications
│   ├── react_<name>/             #   React apps (package.json)
│   ├── vue_<name>/               #   Vue.js apps (package.json)
│   ├── nextjs_<name>/            #   Next.js apps (package.json)
│   └── angular_<name>/           #   Angular apps (package.json)
│
├── backends/                     # Backend services
│   ├── node_<name>/              #   Node.js + Express (package.json)
│   ├── python_<name>/            #   Python + FastAPI (pyproject.toml)
│   ├── go_<name>/                #   Go HTTP server (go.mod)
│   └── rust_<name>/              #   Rust service (Cargo.toml)
│
├── packages/                     # Shared libraries (cross-project)
│   ├── flutter_<name>/           #   Dart/Flutter packages
│   ├── dart_<name>/              #   Dart-only packages
│   ├── rn_<name>/                #   JS/TS shared modules
│   ├── kotlin_<name>/            #   Kotlin shared modules
│   ├── kmp_<name>/               #   Kotlin Multiplatform modules
│   ├── swift_<name>/             #   Swift packages
│   ├── node_<name>/              #   Node.js shared packages
│   ├── python_<name>/            #   Python shared packages
│   ├── go_<name>/                #   Go shared modules
│   └── rust_<name>/              #   Rust shared crates
│
├── terraform/                    # Infrastructure-as-Code (GCP)
│   ├── environments/             #   Per-environment configurations
│   │   ├── dev/                  #     Development (minimal resources)
│   │   ├── staging/              #     Staging (mirrors prod, reduced scale)
│   │   └── prod/                 #     Production (HA, full monitoring)
│   ├── modules/                  #   Reusable infrastructure modules
│   │   ├── project-setup/        #     GCP APIs, billing budgets
│   │   ├── firebase/             #     Firebase project, apps, Auth, Firestore
│   │   ├── cloud-run/            #     Backend services with auto-scaling
│   │   ├── artifact-registry/    #     Docker, npm, Python, Maven registries
│   │   ├── networking/           #     VPC, subnets, Cloud NAT, VPC connector
│   │   ├── iam/                  #     Service accounts, Workload Identity Federation
│   │   ├── secret-manager/       #     Secrets with IAM and rotation
│   │   ├── monitoring/           #     Dashboards, alerts, uptime checks
│   │   └── storage/              #     GCS buckets with lifecycle policies
│   ├── backend.tf.example        #   Remote state backend template
│   └── variables-global.tf       #   Shared variable definitions
│
├── infrastructure/               # Additional IaC
│   ├── kubernetes/               #   K8s manifests / Helm charts (when needed)
│   └── scripts/                  #   Infrastructure utility scripts
│
├── scripts/                      # Utility scripts
│   ├── bootstrap.sh              #   Project scaffolding tool
│   └── setup-branch-protection.sh #  GitHub branch rules setup
│
├── docs/                         # Documentation
│   └── ARCHITECTURE.md           #   This file
│
└── .github/                      # GitHub configuration
    ├── workflows/                #   CI/CD pipeline definitions
    ├── agents/                   #   Copilot custom agents (2)
    ├── skills/                   #   Copilot agent skills (19)
    ├── instructions/             #   Language-specific review rules (6)
    ├── ISSUE_TEMPLATE/           #   Bug report, feature request
    ├── PULL_REQUEST_TEMPLATE.md  #   PR checklist
    ├── CODEOWNERS                #   Code ownership rules
    └── copilot-instructions.md   #   Repo-wide Copilot instructions
```

## Naming Conventions

### Mobile (`apps/`)

| Prefix | Framework | Marker File | Example |
|--------|-----------|-------------|---------|
| `flutter_` | Flutter/Dart | `pubspec.yaml` | `apps/flutter_myapp` |
| `rn_` | React Native | `package.json` | `apps/rn_myapp` |
| `react_native_` | React Native (alt) | `package.json` | `apps/react_native_myapp` |
| `kotlin_` | Kotlin | `build.gradle.kts` | `apps/kotlin_myapp` |
| `kmp_` | Kotlin Multiplatform | `build.gradle.kts` | `apps/kmp_myapp` |
| `ios_` | Swift/iOS native | `Package.swift` | `apps/ios_myapp` |
| `swift_` | Swift (non-iOS) | `Package.swift` | `apps/swift_myapp` |

### Web (`web/`)

| Prefix | Framework | Marker File | Example |
|--------|-----------|-------------|---------|
| `react_` | React | `package.json` | `web/react_dashboard` |
| `vue_` | Vue.js | `package.json` | `web/vue_portal` |
| `nextjs_` | Next.js | `package.json` | `web/nextjs_marketing` |
| `angular_` | Angular | `package.json` | `web/angular_admin` |

### Backends (`backends/`)

| Prefix | Stack | Marker File | Example |
|--------|-------|-------------|---------|
| `node_` | Node.js + Express | `package.json` | `backends/node_api` |
| `python_` | Python + FastAPI | `pyproject.toml` | `backends/python_api` |
| `go_` | Go | `go.mod` | `backends/go_api` |
| `rust_` | Rust | `Cargo.toml` | `backends/rust_api` |

### Shared Packages (`packages/`)

| Prefix | Framework | Example |
|--------|-----------|---------|
| `flutter_` / `dart_` | Dart | `packages/dart_utils` |
| `rn_` | JS/TS (React Native) | `packages/rn_shared` |
| `kotlin_` / `kmp_` | Kotlin | `packages/kmp_core` |
| `swift_` | Swift | `packages/swift_networking` |
| `node_` | Node.js / JS/TS | `packages/node_common` |
| `python_` | Python | `packages/python_helpers` |
| `go_` | Go | `packages/go_utils` |
| `rust_` | Rust | `packages/rust_common` |

The CI pipeline uses these prefixes combined with marker files to auto-detect frameworks and run the appropriate tools. No workflow modifications are needed when adding a new project.

## CI/CD Architecture

### Overview

The CI/CD pipeline is built around **auto-detection**: the `detect-changes` job in `ci.yml` uses `dorny/paths-filter` to determine which directories have changed, then conditionally runs only the relevant CI jobs.

### Change Detection Flow

```
dorny/paths-filter analyzes changed files:

  apps/flutter_*/**         → triggers flutter-ci
  apps/rn_*/**              → triggers react-native-ci
  apps/kotlin_*/**          → triggers kotlin-ci
  apps/ios_*/**             → triggers swift-ci
  web/**                    → triggers web-ci
  backends/**               → triggers backend-ci
  terraform/**              → triggers terraform-gate
  AI/ML-related files       → triggers ai-compliance-gate
```

### CI Jobs by Framework

| CI Job | Trigger Paths | Steps |
|--------|--------------|-------|
| `flutter-ci` | `apps/flutter_*`, `packages/flutter_*`, `packages/dart_*` | `flutter pub get` → `flutter analyze` → `flutter test --coverage` |
| `react-native-ci` | `apps/rn_*`, `apps/react_native_*` | `npm ci` → `eslint` → `tsc --noEmit` → `npm test --coverage` |
| `kotlin-ci` | `apps/kotlin_*`, `apps/kmp_*` | `gradlew detekt` → `gradlew test` |
| `swift-ci` | `apps/ios_*`, `apps/swift_*` | `swift build` → `swift test` (or `xcodebuild`) |
| `web-ci` | `web/*`, `packages/node_*` | `npm ci` → `eslint` → `tsc --noEmit` → `npm test` → `npm run build` |
| `backend-ci` | `backends/*`, `packages/python_*`, `packages/go_*`, `packages/rust_*` | Auto-detects stack per directory (see below) |

### Backend Auto-Detection

The `backend-ci` job iterates over each directory in `backends/` and detects the stack by marker file:

| Marker File | Stack | Lint | Test |
|-------------|-------|------|------|
| `package.json` | Node.js | `eslint` | `npm test` |
| `pyproject.toml` / `requirements.txt` | Python | `ruff check` / `flake8` | `pytest` |
| `go.mod` | Go | `golangci-lint` / `go vet` | `go test ./...` |
| `Cargo.toml` | Rust | `cargo clippy` | `cargo test` |

### Gate Workflows

All gate workflows run on PRs to `main` and `develop`:

| Workflow | File | What It Checks |
|----------|------|----------------|
| CI Gate | `ci.yml` | Framework-specific lint, test, build (aggregated gate job) |
| Code Quality Gate | `code-quality-gate.yml` | Duplicated code, dead code, TODO comments, framework linters |
| Security Gate | `security-gate.yml` | Trivy: vulnerabilities, secrets, misconfigs, licenses (SARIF upload) |
| Copilot Review Gate | `copilot-review-gate.yml` | Enforces Copilot code review findings |
| Terraform Gate | `terraform-gate.yml` | `terraform fmt` → `terraform validate` → `terraform plan` (per environment) |
| AI Compliance Gate | `ai-compliance-gate.yml` | EU AI Act: risk classification, transparency, human oversight |

### Deployment Workflows

CD workflows are manually triggered (`workflow_dispatch`) and target specific environments:

| Workflow | Target Platform | Environments |
|----------|----------------|--------------|
| `cd-android.yml` | Google Play Store | internal, alpha, beta, production |
| `cd-ios.yml` | TestFlight / App Store | testflight, app_store |
| `cd-web.yml` | Web hosting | staging, production |
| `cd-backend.yml` | GCP Cloud Run | dev, staging, production |

### Agentic Workflows

Two Copilot agentic workflows provide additional AI-powered analysis as PR comments (informational, non-blocking):

- **Code Quality Review** (`code-quality-review.md`): Runs quality analysis on every PR
- **AI Compliance Review** (`ai-compliance-review.md`): Runs EU AI Act compliance analysis on PRs that modify AI-related code

These require the `gh-aw` extension to compile and activate.

## Terraform Module Overview

### Module Dependency Graph

```
project-setup
  │
  ├── firebase (requires APIs from project-setup)
  │
  ├── networking (VPC, subnets)
  │     │
  │     ├── cloud-run (requires VPC connector from networking)
  │     │     │
  │     │     └── monitoring (monitors Cloud Run services)
  │     │
  │     └── iam (references VPC for access policies)
  │
  ├── artifact-registry (Docker/package registries)
  │
  ├── secret-manager (secrets for Cloud Run, IAM access)
  │
  └── storage (GCS buckets for state, assets, backups)
```

### Module Summary

| Module | Key Resources | Depends On |
|--------|--------------|------------|
| `project-setup` | GCP API enablement, billing budgets | None |
| `firebase` | Firebase project, mobile apps, Auth, Firestore | `project-setup` |
| `cloud-run` | Cloud Run services, auto-scaling, health checks | `networking`, `iam` |
| `artifact-registry` | Docker, npm, Python, Maven registries | `project-setup` |
| `networking` | VPC, subnets, Cloud NAT, Serverless VPC connector | `project-setup` |
| `iam` | Service accounts, roles, Workload Identity Federation | `project-setup` |
| `secret-manager` | Secrets, IAM bindings, rotation schedules | `iam` |
| `monitoring` | Dashboards, alert policies, uptime checks | `cloud-run` |
| `storage` | GCS buckets, lifecycle rules, versioning | `iam` |

### Environment Configuration

Each environment (`dev`, `staging`, `prod`) has its own `main.tf` and `terraform.tfvars` in `terraform/environments/<env>/`.

| Feature | Dev | Staging | Prod |
|---------|-----|---------|------|
| Cloud Run min instances | 0 | 0 | 1 |
| Cloud Run max instances | 3 | 5 | 20 |
| CPU | 1 | 1 | 2 |
| Memory | 512Mi | 512Mi | 1Gi |
| VPC connector throughput | 200-300 Mbps | 200-300 Mbps | 200-800 Mbps |
| Budget | 50 EUR | 150 EUR | 500 EUR |
| Uptime check period | 5 min | 5 min | 1 min |
| Error rate threshold | 1/sec | 1/sec | 0.5/sec |
| WIF branch restriction | Any branch | Any branch | `main` only |
| Storage versioning | No | Yes | Yes |
| Backup bucket | No | No | Yes |

For complete Terraform setup instructions and variable reference, see [`terraform/README.md`](../terraform/README.md).

## Copilot Integration

### Agents

| Agent | File | Purpose |
|-------|------|---------|
| Code Quality Sweep | `.github/agents/code-quality-sweep.agent.md` | 6-phase code quality analysis with automated fix PRs |
| EU AI Act Auditor | `.github/agents/eu-ai-act-auditor.agent.md` | Full EU AI Act compliance audit across 12 articles |

### Skills

19 skills provide specialized capabilities to the agents, organized in `.github/skills/`. Each skill has its own `skill.md` definition file.

### Code Review Instructions

Language-specific review rules in `.github/instructions/` are automatically applied during Copilot code review based on file type:

| Instruction File | Applies To | Key Checks |
|-----------------|-----------|------------|
| `flutter.instructions.md` | `*.dart` | Widget structure, state management, `const` constructors |
| `react-native.instructions.md` | `*.tsx`, `*.ts` | Hooks, TypeScript strictness, `React.memo`, FlatList |
| `kotlin.instructions.md` | `*.kt` | Coroutines, Jetpack Compose, sealed classes |
| `web.instructions.md` | `*.tsx`, `*.ts`, `*.vue` | Components, SSR, routing, state management |
| `backend.instructions.md` | `*.py`, `*.go`, `*.rs`, `*.ts` | API design, error handling, middleware patterns |
| `security.instructions.md` | All files | Secrets, HTTPS, secure storage, auth, GDPR |

## Adding a New Project

### App or Service

```bash
./scripts/bootstrap.sh <framework> <name>
```

The bootstrap script:
1. Determines the target directory based on framework category (mobile, web, backend)
2. Scaffolds the project with the framework's CLI or a minimal template
3. Adds a Dockerfile for backend services

The CI pipeline auto-detects the new project on the next PR.

### Shared Package

```bash
./scripts/bootstrap.sh <framework> <name> --package
```

Creates the package in `packages/` with the framework prefix. Reference it from apps using the framework's dependency mechanism (e.g., `pubspec.yaml` path dependency for Flutter, `package.json` workspace for Node.js).

### New Framework Support

To add a framework not currently supported:

1. Define a prefix convention (e.g., `svelte_` for Svelte)
2. Add path filters in `ci.yml` under `detect-changes`
3. Add a CI job with the framework's lint, test, and build commands
4. Create `.github/instructions/<framework>.instructions.md` for Copilot review
5. Add the scaffolding logic to `scripts/bootstrap.sh`
6. Add a `bootstrap-<framework>` target to the `Makefile`
7. Update documentation
