# Monorepo Template

[![CI](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/ci.yml/badge.svg)](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/ci.yml)
[![Code Quality](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/code-quality-gate.yml/badge.svg)](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/code-quality-gate.yml)
[![Security](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/security-gate.yml/badge.svg)](https://github.com/jcoutsousa/mobile-monorepo-template/actions/workflows/security-gate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What is this

A production-ready monorepo template for mobile, web, and backend projects. It comes with CI/CD pipelines, infrastructure-as-code (Terraform for GCP), code quality automation, security scanning, and AI-powered code review -- all pre-configured and ready to use. Technology-agnostic: pick any combination of the 12 supported frameworks and the CI pipeline auto-detects what to run.

## Supported Stacks

| Category | Framework | Directory Prefix | Marker File |
|----------|-----------|-----------------|-------------|
| **Mobile** | Flutter | `flutter_` | `pubspec.yaml` |
| **Mobile** | React Native | `rn_` | `package.json` |
| **Mobile** | Kotlin / KMP | `kotlin_` | `build.gradle.kts` |
| **Mobile** | Swift / iOS | `ios_` | `Package.swift` |
| **Web** | React | `react_` | `package.json` |
| **Web** | Vue.js | `vue_` | `package.json` |
| **Web** | Next.js | `nextjs_` | `package.json` |
| **Web** | Angular | `angular_` | `package.json` |
| **Backend** | Node.js | `node_` | `package.json` |
| **Backend** | Python | `python_` | `pyproject.toml` |
| **Backend** | Go | `go_` | `go.mod` |
| **Backend** | Rust | `rust_` | `Cargo.toml` |

The CI pipeline uses directory prefixes and marker files to auto-detect frameworks. No workflow modifications are needed when you add a new project.

## Directory Structure

```
├── apps/                              # Mobile applications
│   ├── flutter_<name>/                #   Flutter apps (pubspec.yaml)
│   ├── rn_<name>/                     #   React Native apps (package.json)
│   ├── kotlin_<name>/                 #   Kotlin/KMP apps (build.gradle.kts)
│   └── ios_<name>/                    #   Swift/iOS apps (Package.swift)
│
├── web/                               # Web applications
│   ├── react_<name>/                  #   React apps
│   ├── vue_<name>/                    #   Vue.js apps
│   ├── nextjs_<name>/                 #   Next.js apps
│   └── angular_<name>/               #   Angular apps
│
├── backends/                          # Backend services
│   ├── node_<name>/                   #   Node.js + Express
│   ├── python_<name>/                 #   Python + FastAPI
│   ├── go_<name>/                     #   Go HTTP server
│   └── rust_<name>/                   #   Rust service
│
├── packages/                          # Shared libraries (any framework)
│
├── terraform/                         # Infrastructure-as-Code (GCP)
│   ├── environments/                  #   dev / staging / prod configs
│   └── modules/                       #   9 reusable Terraform modules
│
├── infrastructure/                    # Additional IaC (K8s, scripts)
│
├── scripts/                           # Utility scripts
│   ├── bootstrap.sh                   #   Create new app/package/service
│   └── setup-branch-protection.sh     #   Configure GitHub branch rules
│
├── docs/                              # Documentation
│   └── ARCHITECTURE.md                #   Full architecture reference
│
└── .github/
    ├── workflows/
    │   ├── ci.yml                     #   Auto-detect CI (lint + test + build)
    │   ├── code-quality-gate.yml      #   Quality checks (required gate)
    │   ├── security-gate.yml          #   Trivy security scan (required gate)
    │   ├── copilot-review-gate.yml    #   Copilot review enforcement
    │   ├── terraform-gate.yml         #   Terraform validate + plan
    │   ├── ai-compliance-gate.yml     #   EU AI Act checks (conditional)
    │   ├── cd-web.yml                 #   Web deployment (manual trigger)
    │   ├── cd-backend.yml             #   Backend deployment to Cloud Run
    │   ├── cd-android.yml             #   Android deployment to Play Store
    │   ├── cd-ios.yml                 #   iOS deployment to App Store
    │   ├── code-quality-review.md     #   Agentic workflow definition
    │   └── ai-compliance-review.md    #   Agentic workflow definition
    ├── agents/                        #   Copilot custom agents
    │   ├── code-quality-sweep.agent.md
    │   └── eu-ai-act-auditor.agent.md
    ├── skills/                        #   19 agent skills
    ├── instructions/                  #   Language-specific review rules
    │   ├── flutter.instructions.md
    │   ├── react-native.instructions.md
    │   ├── kotlin.instructions.md
    │   ├── web.instructions.md
    │   ├── backend.instructions.md
    │   └── security.instructions.md
    ├── copilot-instructions.md        #   Repo-wide review instructions
    ├── CODEOWNERS                     #   Code ownership rules
    ├── PULL_REQUEST_TEMPLATE.md       #   PR template
    └── ISSUE_TEMPLATE/                #   Bug report & feature request
```

## Quick Start

### 1. Create from template

Click **"Use this template"** on GitHub, or use the CLI:

```bash
gh repo create my-project --template jcoutsousa/mobile-monorepo-template --private
cd my-project
```

### 2. Bootstrap your first app

```bash
chmod +x scripts/bootstrap.sh

# Pick any framework — the script handles everything:
./scripts/bootstrap.sh flutter myapp       # → apps/flutter_myapp/
./scripts/bootstrap.sh react dashboard     # → web/react_dashboard/
./scripts/bootstrap.sh python api          # → backends/python_api/
```

### 3. Run locally

```bash
# Mobile
cd apps/flutter_myapp && flutter run

# Web
cd web/react_dashboard && npm install && npm start

# Backend
cd backends/python_api && pip install -e '.[dev]' && python src/main.py
```

### 4. Push and see CI work

```bash
git add .
git commit -m "feat: bootstrap initial apps"
git push
# Open a PR — CI auto-detects your frameworks and runs the right checks
```

### 5. Set up branch protection (optional)

```bash
chmod +x scripts/setup-branch-protection.sh
./scripts/setup-branch-protection.sh owner/repo
```

## Bootstrap Examples

All bootstrap commands follow the same pattern: `./scripts/bootstrap.sh <framework> <name>`.

For Makefile users: `make bootstrap-<framework> APP=<name>`.

### Mobile

```bash
make bootstrap-flutter APP=myapp        # → apps/flutter_myapp/
make bootstrap-rn APP=myapp             # → apps/rn_myapp/
make bootstrap-kotlin APP=myapp         # → apps/kotlin_myapp/
make bootstrap-swift APP=myapp          # → apps/ios_myapp/
```

### Web

```bash
make bootstrap-react APP=dashboard      # → web/react_dashboard/
make bootstrap-vue APP=portal           # → web/vue_portal/
make bootstrap-nextjs APP=marketing     # → web/nextjs_marketing/
make bootstrap-angular APP=admin        # → web/angular_admin/
```

### Backend

```bash
make bootstrap-node APP=api             # → backends/node_api/
make bootstrap-python APP=api           # → backends/python_api/
make bootstrap-go APP=api               # → backends/go_api/
make bootstrap-rust APP=api             # → backends/rust_api/
```

### Shared Packages

```bash
make bootstrap-package FW=flutter APP=utils   # → packages/flutter_utils/
make bootstrap-package FW=kotlin APP=core     # → packages/kotlin_core/
```

## CI/CD Pipeline

### Quality Gates

Every PR must pass these gates before merge:

| Gate | Workflow | Trigger | Blocks Merge |
|------|----------|---------|--------------|
| **CI Gate** | `ci.yml` | Every push and PR | Yes |
| **Code Quality** | `code-quality-gate.yml` | Every PR | Yes |
| **Security Scan** | `security-gate.yml` | Every push and PR | Yes |
| **Copilot Review** | `copilot-review-gate.yml` | Every PR | Yes |
| **Terraform** | `terraform-gate.yml` | PRs touching `terraform/` | Yes |
| **AI Compliance** | `ai-compliance-gate.yml` | PRs touching AI/ML code | Yes (conditional) |
| **Code Quality Review** | `code-quality-review.md` | Every PR | Informational |
| **AI Compliance Review** | `ai-compliance-review.md` | PRs touching AI code | Informational |

### Auto-Detection Flow

```
PR opened / updated
  │
  ├─ detect-changes job (dorny/paths-filter)
  │    Checks which directories were modified
  │
  ├─ CI Gate (ci.yml)
  │    ├─ flutter-ci     if apps/flutter_* or packages/flutter_* changed
  │    ├─ react-native-ci if apps/rn_* changed
  │    ├─ kotlin-ci      if apps/kotlin_* changed
  │    ├─ swift-ci        if apps/ios_* changed
  │    ├─ web-ci          if web/* changed
  │    └─ backend-ci      if backends/* changed
  │         Auto-detects Node/Python/Go/Rust by marker file
  │
  ├─ Code Quality Gate
  │    Duplicates, dead code, TODOs, framework-specific linters
  │
  ├─ Security Gate (Trivy)
  │    Vulnerabilities, secrets, misconfigs, licenses → SARIF to Security tab
  │
  ├─ Copilot Code Review
  │    Reviews using .github/copilot-instructions.md + language-specific rules
  │
  ├─ Terraform Gate (if terraform/ changed)
  │    fmt check → validate → plan for dev/staging/prod
  │
  └─ AI Compliance Gate (if AI/ML files changed)
       Risk classification, transparency, human oversight
```

### Deployment Workflows

CD workflows are triggered manually via `workflow_dispatch`:

| Workflow | Target | Trigger |
|----------|--------|---------|
| `cd-android.yml` | Google Play Store | Manual (select app + track) |
| `cd-ios.yml` | TestFlight / App Store | Manual (select app + environment) |
| `cd-web.yml` | Web hosting | Manual (select app + environment) |
| `cd-backend.yml` | GCP Cloud Run | Manual (select service + environment) |

## Infrastructure

The template includes 9 Terraform modules for GCP infrastructure, organized by environment (dev, staging, prod).

| Module | Purpose |
|--------|---------|
| `project-setup` | GCP APIs, billing budgets |
| `firebase` | Firebase project, apps, Auth, Firestore |
| `cloud-run` | Backend API services with auto-scaling |
| `artifact-registry` | Docker, npm, Python, Maven registries |
| `networking` | VPC, subnets, Cloud NAT, VPC connector |
| `iam` | Service accounts, Workload Identity Federation |
| `secret-manager` | Secrets with IAM and rotation |
| `monitoring` | Dashboards, alerts, uptime checks |
| `storage` | GCS buckets with lifecycle policies |

For full setup instructions, module details, and environment configuration, see [`terraform/README.md`](terraform/README.md).

For architecture and inter-module dependencies, see [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Makefile Commands

### Bootstrap

| Command | Description |
|---------|-------------|
| `make bootstrap-flutter APP=<name>` | Create a Flutter app in `apps/` |
| `make bootstrap-rn APP=<name>` | Create a React Native app in `apps/` |
| `make bootstrap-kotlin APP=<name>` | Create a Kotlin app in `apps/` |
| `make bootstrap-swift APP=<name>` | Create a Swift app in `apps/` |
| `make bootstrap-react APP=<name>` | Create a React app in `web/` |
| `make bootstrap-vue APP=<name>` | Create a Vue.js app in `web/` |
| `make bootstrap-nextjs APP=<name>` | Create a Next.js app in `web/` |
| `make bootstrap-angular APP=<name>` | Create an Angular app in `web/` |
| `make bootstrap-node APP=<name>` | Create a Node.js backend in `backends/` |
| `make bootstrap-python APP=<name>` | Create a Python backend in `backends/` |
| `make bootstrap-go APP=<name>` | Create a Go backend in `backends/` |
| `make bootstrap-rust APP=<name>` | Create a Rust backend in `backends/` |
| `make bootstrap-package FW=<fw> APP=<name>` | Create a shared package in `packages/` |

### Quality

| Command | Description |
|---------|-------------|
| `make lint` | Run linters for all detected projects |
| `make test` | Run tests for all detected projects |
| `make format` | Format code in all detected projects |
| `make clean` | Clean build artifacts for all projects |

Each quality command auto-detects the framework per project directory and runs the appropriate tool (e.g., `flutter analyze` for Flutter, `ruff check` for Python, `cargo clippy` for Rust).

### Setup

| Command | Description |
|---------|-------------|
| `make setup-protection REPO=owner/repo` | Configure GitHub branch protection rules |
| `make help` | Show all available commands |

## Copilot Agents

### Code Quality Sweep

Invoke interactively in Copilot Chat:

```
@code-quality-sweep run a full sweep
```

Performs 6-phase analysis: unused imports, dead code, duplicated constants, duplicated logic, inconsistent patterns, spaghetti code. Creates a branch, makes commits, and opens a PR.

### EU AI Act Auditor

For apps with AI/ML components:

```
@eu-ai-act-auditor audit this repository
```

Performs full EU AI Act (Regulation 2024/1689) compliance audit across 12 articles. Generates a compliance scorecard with remediation advice.

## Copilot Code Review

Language-specific review rules are in `.github/instructions/`:

| File | Applies To | Focus |
|------|-----------|-------|
| `flutter.instructions.md` | `*.dart` | Widget structure, state management, performance |
| `react-native.instructions.md` | `*.tsx`, `*.ts` | Hooks, TypeScript, FlatList, memo |
| `kotlin.instructions.md` | `*.kt` | Coroutines, Compose, sealed classes |
| `web.instructions.md` | `*.tsx`, `*.ts`, `*.vue` | Components, SSR, routing, state |
| `backend.instructions.md` | `*.py`, `*.go`, `*.rs`, `*.ts` | API design, error handling, middleware |
| `security.instructions.md` | All files | Secrets, HTTPS, storage, auth, GDPR |

## Agentic Workflows

Two agentic workflows are included as `.md` files in `.github/workflows/`:

- `code-quality-review.md` -- AI-powered quality review on every PR
- `ai-compliance-review.md` -- EU AI Act compliance review on AI-related PRs

To compile and activate (requires `gh-aw` extension):

```bash
gh extension install github/gh-aw
gh aw compile
git add .github/workflows/*.lock.yml
git commit -m "chore: compile agentic workflows"
git push
```

## Adding a New Framework

The CI pipeline auto-detects frameworks by directory prefix and marker file. To add support for a framework not yet included:

1. Define a prefix convention (e.g., `svelte_` for Svelte)
2. Add a detection filter in `ci.yml` for the appropriate directory (`apps/`, `web/`, or `backends/`)
3. Add a CI job with the framework's lint, test, and build commands
4. Add an instructions file in `.github/instructions/`
5. Update `scripts/bootstrap.sh` with the creation command
6. Update `Makefile` with a `bootstrap-<framework>` target

## Adopting Individual Components

You can copy individual pieces into an existing project:

```bash
# Quality agents + skills
cp -r .github/agents/ your-project/.github/
cp -r .github/skills/ your-project/.github/

# CI workflow
cp .github/workflows/ci.yml your-project/.github/workflows/

# CD workflows
cp .github/workflows/cd-web.yml your-project/.github/workflows/
cp .github/workflows/cd-backend.yml your-project/.github/workflows/
cp .github/workflows/cd-android.yml your-project/.github/workflows/
cp .github/workflows/cd-ios.yml your-project/.github/workflows/

# Quality and security gates
cp .github/workflows/code-quality-gate.yml your-project/.github/workflows/
cp .github/workflows/security-gate.yml your-project/.github/workflows/

# Copilot review instructions
cp -r .github/instructions/ your-project/.github/
cp .github/copilot-instructions.md your-project/.github/
```

## References

- [GitHub Copilot Custom Agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [Copilot Setup Steps](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/customize-the-agent-environment)
- [GitHub Copilot Coding Agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [EU AI Act Regulation](https://eur-lex.europa.eu/eli/reg/2024/1689/oj)

## License

MIT
