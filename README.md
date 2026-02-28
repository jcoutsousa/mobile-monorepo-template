# Monorepo Template

Template repository for application development in monorepo architecture. Language-agnostic with a plugin system — add any framework by dropping a `.sh` file into `frameworks/`.

Ships with Flutter, React Native, Kotlin, Swift, Python, and Go. Includes automated code quality enforcement and EU AI Act compliance checking via GitHub Copilot custom agents and agentic workflows.

## Quick Start

### 1. Create from template

Click **"Use this template"** on GitHub, or:

```bash
gh repo create my-app --template jcoutsousa/mobile-monorepo-template --private
cd my-app
```

### 2. See available frameworks

```bash
./scripts/bootstrap.sh --list
```

### 3. Bootstrap your first app

```bash
./scripts/bootstrap.sh flutter myapp           # Flutter app
./scripts/bootstrap.sh react-native myapp      # React Native app
./scripts/bootstrap.sh kotlin myapp            # Kotlin app
./scripts/bootstrap.sh python ml-service       # Python service
./scripts/bootstrap.sh go api-gateway          # Go service
./scripts/bootstrap.sh flutter utils --package # Shared package
```

### 4. Set up branch protection

```bash
./scripts/setup-branch-protection.sh owner/repo
```

## Structure

```
├── apps/                         # Applications (any framework)
│   ├── flutter_<name>/
│   ├── rn_<name>/
│   ├── kotlin_<name>/
│   ├── py_<name>/
│   ├── go_<name>/
│   └── ...
│
├── packages/                     # Shared libraries
│
├── frameworks/                   # Framework plugins (the plugin system)
│   ├── _template.sh              # Copy this to add a new framework
│   ├── flutter.sh
│   ├── react-native.sh
│   ├── kotlin.sh
│   ├── swift.sh
│   ├── python.sh
│   └── go.sh
│
├── infrastructure/               # IaC (Terraform, K8s)
│
├── docs/                         # Documentation
│
├── scripts/
│   ├── bootstrap.sh              # Create new app/package (reads from frameworks/)
│   └── setup-branch-protection.sh
│
└── .github/
    ├── agents/                   # Copilot custom agents
    ├── skills/                   # Agent skills (19 total)
    ├── instructions/             # Code review rules per language
    │   ├── flutter.instructions.md
    │   ├── react-native.instructions.md
    │   ├── kotlin.instructions.md
    │   ├── python.instructions.md
    │   ├── go.instructions.md
    │   └── security.instructions.md
    ├── copilot-instructions.md
    └── workflows/
        ├── ci-mobile.yml           # Dynamic framework CI (reads plugins)
        ├── code-quality-gate.yml   # Quality checks (required)
        ├── ai-compliance-gate.yml  # EU AI Act (conditional)
        ├── copilot-review-gate.yml
        ├── code-quality-review.md  # Agentic Workflow
        └── ai-compliance-review.md # Agentic Workflow
```

## Plugin System

Each framework is defined as a shell script in `frameworks/`. The bootstrap script, Makefile, and CI workflows all read from these plugins automatically.

### Adding a new framework

1. Copy the template:
   ```bash
   cp frameworks/_template.sh frameworks/myframework.sh
   ```

2. Edit the plugin — set the name, prefixes, detect file, commands, and scaffold function.

3. Optionally add Copilot review instructions:
   ```bash
   # Create .github/instructions/myframework.instructions.md
   ```

That's it. The CI, Makefile, and bootstrap all pick it up automatically. No workflow modifications needed.

### Plugin anatomy

```bash
# frameworks/myframework.sh

FRAMEWORK_NAME="My Framework"              # Display name
FRAMEWORK_PREFIXES=("myfw_")               # Directory prefixes for CI detection
FRAMEWORK_DETECT_FILE="myfw.config"        # File that identifies projects
FRAMEWORK_EXTENSIONS=(".myfw")             # Source file extensions

FRAMEWORK_INSTALL_CMD="myfw install"       # Install dependencies
FRAMEWORK_LINT_CMD="myfw lint"             # Lint / static analysis
FRAMEWORK_TEST_CMD="myfw test"             # Run tests
FRAMEWORK_FORMAT_CMD="myfw format"         # Format source code
FRAMEWORK_CLEAN_CMD="myfw clean"           # Clean build artifacts

scaffold() {
  local target="$1" name="$2" is_package="$3"
  mkdir -p "$target"
  # Create initial project files...
}
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
  │     └─ Reads framework plugins → runs lint + test per detected framework
  │
  ├─→ Code Quality Gate (code-quality-gate.yml)
  │     └─ Checks: secrets, duplicates, TODOs + framework-specific linters
  │
  ├─→ Copilot Code Review (auto-requested via ruleset)
  │     └─ Reviews using language-specific .github/instructions/
  │
  ├─→ AI Compliance Gate [conditional]
  │     └─ Only if AI/ML files modified
  │
  └─→ Agentic Workflows [informational]
        ├─ Code Quality Review
        └─ AI Compliance Review
```

## Copilot Agents

### Code Quality Sweep

```
@code-quality-sweep run a full sweep
```

6-phase analysis: unused imports, dead code, duplicated constants, duplicated logic, inconsistent patterns, spaghetti code. Creates a branch, makes commits, opens a PR.

### EU AI Act Auditor

```
@eu-ai-act-auditor audit this repository
```

Full EU AI Act (Regulation 2024/1689) compliance audit across 12 articles.

## Copilot Code Review Instructions

| File | Applies To | Focus |
|------|-----------|-------|
| `flutter.instructions.md` | `*.dart` | Widget structure, state management, performance |
| `react-native.instructions.md` | `*.tsx, *.ts` | Hooks, TypeScript, FlatList, memo |
| `kotlin.instructions.md` | `*.kt` | Coroutines, Compose, sealed classes |
| `python.instructions.md` | `*.py` | Type hints, pytest, clean architecture |
| `go.instructions.md` | `*.go` | Error handling, concurrency, interfaces |
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

## Makefile Commands

```bash
make help                          # Show all commands
make list-frameworks               # List available framework plugins
make bootstrap FW=flutter APP=myapp # Create new app (any framework)
make bootstrap-package FW=go APP=shared # Create shared package
make lint                          # Lint all detected apps
make test                          # Test all detected apps
make format                        # Format all detected apps
make clean                         # Clean all build artifacts
make setup-protection REPO=owner/repo
```

## Adopting Individual Components

```bash
# Framework plugin system
cp -r frameworks/ your-project/

# Quality agents + skills
cp -r .github/agents/ your-project/.github/
cp -r .github/skills/ your-project/.github/

# CI + quality gate workflows
cp .github/workflows/ci-mobile.yml your-project/.github/workflows/
cp .github/workflows/code-quality-gate.yml your-project/.github/workflows/

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
