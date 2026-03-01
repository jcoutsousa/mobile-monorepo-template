# Monorepo Template

Template repository for mobile, web, and backend application development in monorepo architecture. Technology-agnostic — supports Flutter, React Native, Kotlin, Swift, React, Vue, Next.js, Angular, Node.js, Python, Go, and Rust.

Includes automated code quality enforcement and EU AI Act compliance checking via GitHub Copilot custom agents and agentic workflows.

## Quick Start

### 1. Create from template

Click **"Use this template"** on GitHub, or:

```bash
gh repo create my-project --template jcoutsousa/mobile-monorepo-template --private
cd my-project
```

### 2. Bootstrap your first app

```bash
chmod +x scripts/bootstrap.sh

# Mobile
./scripts/bootstrap.sh flutter myapp       # Flutter app
./scripts/bootstrap.sh rn myapp            # React Native app
./scripts/bootstrap.sh kotlin myapp        # Kotlin app
./scripts/bootstrap.sh flutter utils --package  # Shared package

# Web
./scripts/bootstrap.sh react myapp         # React app
./scripts/bootstrap.sh vue myapp           # Vue.js app
./scripts/bootstrap.sh nextjs myapp        # Next.js app
./scripts/bootstrap.sh angular myapp       # Angular app

# Backend
./scripts/bootstrap.sh node api            # Node.js backend
./scripts/bootstrap.sh python api          # Python backend
./scripts/bootstrap.sh go api              # Go backend
./scripts/bootstrap.sh rust api            # Rust backend
```

### 3. Set up branch protection

```bash
chmod +x scripts/setup-branch-protection.sh
./scripts/setup-branch-protection.sh owner/repo
```

## Structure

```
├── apps/                         # Mobile applications
│   ├── flutter_<name>/           # Flutter apps
│   ├── rn_<name>/                # React Native apps
│   ├── kotlin_<name>/            # Kotlin/KMP apps
│   └── ios_<name>/               # Swift/iOS apps
│
├── web/                          # Web applications
│   ├── react_<name>/             # React apps
│   ├── vue_<name>/               # Vue.js apps
│   ├── nextjs_<name>/            # Next.js apps
│   └── angular_<name>/           # Angular apps
│
├── backends/                     # Backend services
│   ├── node_<name>/              # Node.js services
│   ├── python_<name>/            # Python services
│   ├── go_<name>/                # Go services
│   └── rust_<name>/              # Rust services
│
├── packages/                     # Shared libraries
│
├── infrastructure/               # IaC (Terraform, K8s)
│
├── docs/                         # Documentation
│
├── scripts/                      # Utility scripts
│   ├── bootstrap.sh              # Create new app/package/service
│   └── setup-branch-protection.sh # Configure GitHub rules
│
└── .github/
    ├── agents/                   # Copilot custom agents
    │   ├── code-quality-sweep.agent.md
    │   └── eu-ai-act-auditor.agent.md
    ├── skills/                   # Agent skills (19 total)
    ├── instructions/             # Code review rules per language
    │   ├── flutter.instructions.md
    │   ├── react-native.instructions.md
    │   ├── kotlin.instructions.md
    │   ├── web.instructions.md
    │   ├── backend.instructions.md
    │   └── security.instructions.md
    ├── copilot-instructions.md   # Repo-wide review instructions
    └── workflows/
        ├── ci.yml                # Auto-detect framework CI
        ├── cd-web.yml            # Web deployment
        ├── cd-backend.yml        # Backend deployment
        ├── code-quality-gate.yml # Quality checks (required)
        ├── ai-compliance-gate.yml # EU AI Act (conditional)
        ├── copilot-review-gate.yml # Enforce Copilot findings
        ├── code-quality-review.md  # Agentic Workflow
        └── ai-compliance-review.md # Agentic Workflow
```

## Quality Gates

Every PR must pass before merge:

| Gate | Type | Trigger | Blocks Merge |
|------|------|---------|--------------|
| **CI Gate** | GitHub Action | Every push | Yes |
| **Code Quality Sweep** | GitHub Action | Every PR | Yes |
| **Security Scan** | GitHub Action (Trivy) | Every PR + push | Yes |
| **Copilot Review** | Copilot Code Review | Every PR | Yes (via gate workflow) |
| **AI Compliance** | GitHub Action | PRs touching AI code | Yes (if AI detected) |
| **Code Quality Review** | Agentic Workflow | Every PR | Informational |
| **AI Compliance Review** | Agentic Workflow | PRs touching AI code | Informational |

### How enforcement works

```
PR opened/updated
  │
  ├─→ CI Gate (ci.yml)
  │     ├─ mobile-ci: Auto-detects framework in apps/ → runs lint + test + analyze
  │     ├─ web-ci: Auto-detects framework in web/ → runs lint + test + build
  │     └─ backend-ci: Auto-detects stack in backends/ → runs lint + test + build
  │
  ├─→ Code Quality Gate (code-quality-gate.yml)
  │     └─ Checks: duplicates, dead code, TODOs, framework linters
  │
  ├─→ Security Gate (security-gate.yml)
  │     └─ Trivy: vulnerabilities, secrets, misconfigs, licenses
  │     └─ Results uploaded to GitHub Security tab (SARIF)
  │
  ├─→ Copilot Code Review (auto-requested via ruleset)
  │     └─ Reviews code using .github/copilot-instructions.md
  │     └─ Copilot Review Gate checks for critical findings
  │
  ├─→ AI Compliance Gate (ai-compliance-gate.yml) [conditional]
  │     └─ Only runs if AI/ML files are modified
  │     └─ Checks: risk classification, transparency, oversight
  │
  └─→ Agentic Workflows [informational]
        ├─ Code Quality Review (code-quality-review.md)
        └─ AI Compliance Review (ai-compliance-review.md)
```

## Copilot Agents

### Code Quality Sweep

Invoked interactively in Copilot Chat:

```
@code-quality-sweep run a full sweep
```

Performs 6-phase analysis: unused imports -> dead code -> duplicated constants -> duplicated logic -> inconsistent patterns -> spaghetti code. Creates a branch, makes commits, opens a PR.

### EU AI Act Auditor

For apps with AI/ML components:

```
@eu-ai-act-auditor audit this repository
```

Performs full EU AI Act (Regulation 2024/1689) compliance audit across 12 articles. Generates a compliance scorecard with remediation advice.

## Copilot Code Review Instructions

Language-specific review rules are in `.github/instructions/`:

| File | Applies To | Focus |
|------|-----------|-------|
| `flutter.instructions.md` | `*.dart` | Widget structure, state management, performance |
| `react-native.instructions.md` | `*.tsx, *.ts` | Hooks, TypeScript, FlatList, memo |
| `kotlin.instructions.md` | `*.kt` | Coroutines, Compose, sealed classes |
| `web.instructions.md` | `*.tsx, *.ts, *.vue` | Components, SSR, routing, state |
| `backend.instructions.md` | `*.py, *.go, *.rs, *.ts` | API design, error handling, middleware |
| `security.instructions.md` | All files | Secrets, HTTPS, storage, auth, GDPR |

## Agentic Workflows (Technical Preview)

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

The CI pipeline auto-detects frameworks by directory prefix. To add support for a new framework:

1. Define the prefix convention (e.g., `svelte_` for Svelte)
2. Add a detection filter in `ci.yml` for the appropriate directory (`apps/`, `web/`, or `backends/`)
3. Add a CI job for the framework
4. Add an instructions file in `.github/instructions/`
5. Update `bootstrap.sh` with the creation command

## Makefile Commands

```bash
make help                        # Show all commands

# Mobile
make bootstrap-flutter APP=myapp # Create new Flutter app
make bootstrap-rn APP=myapp      # Create new React Native app
make bootstrap-kotlin APP=myapp  # Create new Kotlin app

# Web
make bootstrap-react APP=myapp   # Create new React app
make bootstrap-vue APP=myapp     # Create new Vue.js app
make bootstrap-nextjs APP=myapp  # Create new Next.js app
make bootstrap-angular APP=myapp # Create new Angular app

# Backend
make bootstrap-node APP=api      # Create new Node.js backend
make bootstrap-python APP=api    # Create new Python backend
make bootstrap-go APP=api        # Create new Go backend
make bootstrap-rust APP=api      # Create new Rust backend

# Quality
make lint                        # Run linters for all detected apps
make lint-mobile                 # Run linters for mobile apps only
make lint-web                    # Run linters for web apps only
make lint-backend                # Run linters for backends only
make test                        # Run tests for all detected apps
make test-mobile                 # Run tests for mobile apps only
make test-web                    # Run tests for web apps only
make test-backend                # Run tests for backends only
make format                      # Format code in all detected apps
make format-mobile               # Format mobile apps only
make format-web                  # Format web apps only
make format-backend              # Format backends only
make clean                       # Clean build artifacts
make clean-mobile                # Clean mobile build artifacts
make clean-web                   # Clean web build artifacts
make clean-backend               # Clean backend build artifacts
make setup-protection REPO=owner/repo  # Configure branch protection
```

## Adopting Individual Components

You can copy individual pieces into an existing project:

```bash
# Just the quality agents + skills
cp -r .github/agents/ your-project/.github/
cp -r .github/skills/ your-project/.github/

# Just the CI workflow
cp .github/workflows/ci.yml your-project/.github/workflows/

# Just the CD workflows
cp .github/workflows/cd-web.yml your-project/.github/workflows/
cp .github/workflows/cd-backend.yml your-project/.github/workflows/

# Just the quality gate
cp .github/workflows/code-quality-gate.yml your-project/.github/workflows/

# Just Copilot review instructions
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
