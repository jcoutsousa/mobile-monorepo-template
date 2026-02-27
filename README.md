# Mobile Monorepo Template

Template repository for mobile application development in monorepo architecture. Language-agnostic — supports Flutter, React Native, Kotlin Multiplatform, and Swift.

Includes automated code quality enforcement and EU AI Act compliance checking via GitHub Copilot custom agents and agentic workflows.

## Quick Start

### 1. Create from template

Click **"Use this template"** on GitHub, or:

```bash
gh repo create my-mobile-app --template jcoutsousa/mobile-monorepo-template --private
cd my-mobile-app
```

### 2. Bootstrap your first app

```bash
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh flutter myapp       # Flutter app
./scripts/bootstrap.sh rn myapp            # React Native app
./scripts/bootstrap.sh kotlin myapp        # Kotlin app
./scripts/bootstrap.sh flutter utils --package  # Shared package
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
├── packages/                     # Shared libraries
│
├── infrastructure/               # IaC (Terraform, K8s)
│
├── docs/                         # Documentation
│
├── scripts/                      # Utility scripts
│   ├── bootstrap.sh              # Create new app/package
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
    │   └── security.instructions.md
    ├── copilot-instructions.md   # Repo-wide review instructions
    └── workflows/
        ├── ci-mobile.yml         # Auto-detect framework CI
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
| **Copilot Review** | Copilot Code Review | Every PR | Yes (via gate workflow) |
| **AI Compliance** | GitHub Action | PRs touching AI code | Yes (if AI detected) |
| **Code Quality Review** | Agentic Workflow | Every PR | Informational |
| **AI Compliance Review** | Agentic Workflow | PRs touching AI code | Informational |

### How enforcement works

```
PR opened/updated
  │
  ├─→ CI Gate (ci-mobile.yml)
  │     └─ Auto-detects framework → runs lint + test + analyze
  │
  ├─→ Code Quality Gate (code-quality-gate.yml)
  │     └─ Checks: secrets, duplicates, dead code, TODOs
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

Performs 6-phase analysis: unused imports → dead code → duplicated constants → duplicated logic → inconsistent patterns → spaghetti code. Creates a branch, makes commits, opens a PR.

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
| `security.instructions.md` | All files | Secrets, HTTPS, storage, auth, GDPR |

## Agentic Workflows (Technical Preview)

Two agentic workflows are included as `.md` files in `.github/workflows/`:

- `code-quality-review.md` — AI-powered quality review on every PR
- `ai-compliance-review.md` — EU AI Act compliance review on AI-related PRs

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

1. Define the prefix convention (e.g., `svelte_` for Svelte Native)
2. Add a detection filter in `ci-mobile.yml`
3. Add a CI job for the framework
4. Add an instructions file in `.github/instructions/`
5. Update `bootstrap.sh` with the creation command

## Makefile Commands

```bash
make help              # Show all commands
make bootstrap-flutter APP=myapp  # Create new Flutter app
make bootstrap-rn APP=myapp       # Create new React Native app
make bootstrap-kotlin APP=myapp   # Create new Kotlin app
make lint              # Run linters for all detected apps
make test              # Run tests for all detected apps
make format            # Format code in all detected apps
make clean             # Clean build artifacts
make setup-protection REPO=owner/repo  # Configure branch protection
```

## Adopting Individual Components

You can copy individual pieces into an existing project:

```bash
# Just the quality agents + skills
cp -r .github/agents/ your-project/.github/
cp -r .github/skills/ your-project/.github/

# Just the CI workflows
cp .github/workflows/ci-flutter.yml your-project/.github/workflows/

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
