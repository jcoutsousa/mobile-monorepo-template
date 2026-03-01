---
name: quality-report
description: >
  Generates a comprehensive code quality report aggregating findings from all
  sweep skills. Produces a structured summary with metrics, before/after
  comparisons, and the PR body content.
---

# Quality Report Skill

Aggregate all sweep findings into a comprehensive quality report.

## Report Generation Process

### Step 1: Collect Results from All Skills

Gather findings from:
- Unused imports audit
- Dead code audit
- Duplicated constants audit
- Duplicated logic audit
- Inconsistent patterns audit
- Spaghetti code audit

### Step 2: Calculate Metrics

| Metric | How to Calculate |
|--------|-----------------|
| Total files scanned | Count source files per language (`.dart` in `lib/`, `.py`, `.go`, `.rs`, `.ts`/`.tsx`/`.vue` in `src/`) |
| Files modified | Count unique files changed across all categories |
| Lines removed | Sum of all deleted lines (net) |
| Lines added | Sum of all new lines (shared utilities, constants files) |
| Net line delta | Lines added - Lines removed |
| Issues found | Sum of all issues across categories |
| Issues fixed | Sum of all fixes applied |

### Step 3: Validation Summary

| Check | Command | Expected |
|-------|---------|----------|
| Dart analysis | `flutter analyze` | 0 new issues |
| Dart tests | `flutter test` | 0 new failures |
| TS/JS linting | `npx eslint .` | 0 new errors |
| TS/JS tests | `npx jest` | 0 new failures |
| Kotlin analysis | `./gradlew lint` | 0 new issues |
| Kotlin tests | `./gradlew test` | 0 new failures |
| Python linting | `ruff check .` | 0 new issues |
| Python tests | `pytest` | 0 new failures |
| Go analysis | `go vet ./...` | 0 new issues |
| Go tests | `go test ./...` | 0 new failures |
| Rust analysis | `cargo clippy -- -D warnings` | 0 new warnings |
| Rust tests | `cargo test` | 0 new failures |
| Web linting | `npx eslint .` | 0 new errors |
| Web tests | `npx jest` or `npx vitest run` | 0 new failures |
| Pre-existing issues | — | Documented, not introduced |

### Step 4: Generate Report

## Output Format

```markdown
## Code Quality Sweep Report

### Overview

| Metric | Value |
|--------|-------|
| Files scanned | [count] |
| Files modified | [count] |
| Lines removed | [count] |
| Lines added | [count] |
| **Net reduction** | **-[count] lines** |

### Validation

| Check | Status | Details |
|-------|--------|---------|
| `flutter analyze` | PASS/FAIL | [X] issues (Y pre-existing) |
| `flutter test` | PASS/FAIL | [X] passed, [Y] failed, [Z] skipped |
| `npx eslint .` (RN) | PASS/FAIL | [X] errors (Y pre-existing) |
| `npx jest` (RN) | PASS/FAIL | [X] passed, [Y] failed |
| `./gradlew lint` | PASS/FAIL | [X] issues (Y pre-existing) |
| `./gradlew test` | PASS/FAIL | [X] passed, [Y] failed |
| `ruff check .` | PASS/FAIL | [X] issues (Y pre-existing) |
| `pytest` | PASS/FAIL | [X] passed, [Y] failed |
| `go vet ./...` | PASS/FAIL | [X] issues (Y pre-existing) |
| `go test ./...` | PASS/FAIL | [X] passed, [Y] failed |
| `cargo clippy` | PASS/FAIL | [X] warnings (Y pre-existing) |
| `cargo test` | PASS/FAIL | [X] passed, [Y] failed |
| `npx eslint .` (Web) | PASS/FAIL | [X] errors (Y pre-existing) |
| `npx jest/vitest` (Web) | PASS/FAIL | [X] passed, [Y] failed |

### Changes by Category

#### 1. Unused Imports
- **Files modified**: [count]
- **Imports removed**: [count]

#### 2. Dead Code
- **Files deleted**: [count]
- **Symbols removed**: [count]
- **Lines removed**: [count]

<details>
<summary>Dead symbols removed</summary>

| File | Symbol | Type | Lines |
|------|--------|------|-------|
| ... | ... | ... | ... |

</details>

#### 3. Duplicated Constants
- **Constants centralized**: [count]
- **Hardcoded values replaced**: [count]
- **New constant classes**: [list]

<details>
<summary>Centralized constants</summary>

| Value | Constant | Occurrences |
|-------|----------|-------------|
| ... | ... | ... |

</details>

#### 4. Duplicated Logic
- **Patterns extracted**: [count]
- **New shared files**: [count]
- **Lines saved**: [count]

#### 5. Inconsistent Patterns
- **Naming fixes**: [count]
- **Async standardizations**: [count]
- **Import fixes**: [count]

#### 6. Spaghetti Code
- **Functions refactored**: [count]
- **Build methods split**: [count]
- **Nesting reduced**: [count]
- **Concerns separated**: [count]

### Commits

| # | Message | Files | Lines |
|---|---------|-------|-------|
| 1 | refactor: remove unused imports | [X] | -[Y] |
| 2 | refactor: remove dead code and unused symbols | [X] | -[Y] |
| 3 | refactor: centralize duplicated constants and hardcoded values | [X] | +[A]/-[B] |
| 4 | refactor: extract duplicated logic into shared utilities | [X] | +[A]/-[B] |
| 5 | refactor: standardize naming conventions and patterns | [X] | ~[Y] |
| 6 | refactor: improve code structure and reduce complexity | [X] | +[A]/-[B] |

### Per-Language Metrics

#### Mobile
| Language | Files Scanned | Files Modified | Lines Removed | Lines Added |
|----------|--------------|----------------|---------------|-------------|
| Dart (.dart) | [count] | [count] | [count] | [count] |
| TypeScript/RN (.ts/.tsx) | [count] | [count] | [count] | [count] |
| Kotlin (.kt) | [count] | [count] | [count] | [count] |

#### Web
| Language | Files Scanned | Files Modified | Lines Removed | Lines Added | Bundle Size Delta |
|----------|--------------|----------------|---------------|-------------|-------------------|
| React (.tsx) | [count] | [count] | [count] | [count] | [delta] |
| Vue (.vue) | [count] | [count] | [count] | [count] | [delta] |
| Angular (.ts) | [count] | [count] | [count] | [count] | [delta] |

#### Backend
| Language | Files Scanned | Files Modified | Lines Removed | Lines Added |
|----------|--------------|----------------|---------------|-------------|
| Python (.py) | [count] | [count] | [count] | [count] |
| Go (.go) | [count] | [count] | [count] | [count] |
| Rust (.rs) | [count] | [count] | [count] | [count] |

### Remaining Items (out of scope)

Items detected but intentionally not fixed:
- Pre-existing `flutter analyze` warnings: [count]
- Pre-existing `ruff check` warnings: [count]
- Pre-existing `go vet` warnings: [count]
- Pre-existing `cargo clippy` warnings: [count]
- Pre-existing `eslint` warnings: [count]
- Test-only symbols (kept for testing): [count]
- Patterns requiring architectural decisions: [list]

---

> This sweep was performed by the [code-quality-sweep](https://github.com/nosportugal/code-quality-sweep) agent.
> No business logic was changed. All modifications are structural refactoring only.
```
