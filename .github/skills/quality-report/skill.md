---
name: quality-report
description: >
  Generates a comprehensive code quality report aggregating findings from all
  sweep skills across multi-language mobile codebases. Produces a structured
  summary with per-language metrics, before/after comparisons, validation
  results, and the PR body content. Supports Flutter/Dart, React Native/TypeScript,
  and Kotlin/Android sections.
---

# Quality Report Skill

Aggregate all sweep findings into a comprehensive quality report with per-language sections.

## Language Detection

Before generating the report, confirm detected languages:

| Indicator | Language/Framework | Analyzer Command | Test Command |
|-----------|-------------------|-----------------|--------------|
| `pubspec.yaml` | Flutter/Dart | `flutter analyze` | `flutter test` |
| `package.json` + react-native | React Native/TypeScript | `npx eslint .` | `npx jest` |
| `build.gradle.kts` | Kotlin/Android | `./gradlew lint` | `./gradlew test` |

---

## Report Generation Process

### Step 1: Collect Results from All Skills

Gather findings from each skill, grouped by app and language:
- Unused imports audit
- Dead code audit
- Duplicated constants audit
- Duplicated logic audit
- Inconsistent patterns audit
- Spaghetti code audit

### Step 2: Calculate Metrics Per Language

#### Flutter/Dart Metrics

| Metric | How to Calculate |
|--------|-----------------|
| Total files scanned | Count all `.dart` files in `lib/` |
| Files modified | Count unique `.dart` files changed across all categories |
| Lines removed | Sum of all deleted lines (net) in `.dart` files |
| Lines added | Sum of all new lines in `.dart` files |
| Net line delta | Lines added - Lines removed |
| Issues found | Sum of all issues in Dart files |
| Issues fixed | Sum of all fixes applied to Dart files |

#### React Native/TypeScript Metrics

| Metric | How to Calculate |
|--------|-----------------|
| Total files scanned | Count all `.ts`, `.tsx`, `.js`, `.jsx` files in `src/` |
| Files modified | Count unique TS/JS files changed across all categories |
| Lines removed | Sum of all deleted lines (net) in TS/JS files |
| Lines added | Sum of all new lines in TS/JS files |
| Net line delta | Lines added - Lines removed |
| Issues found | Sum of all issues in TS/JS files |
| Issues fixed | Sum of all fixes applied to TS/JS files |

#### Kotlin/Android Metrics

| Metric | How to Calculate |
|--------|-----------------|
| Total files scanned | Count all `.kt` files in `src/main/kotlin/` |
| Files modified | Count unique `.kt` files changed across all categories |
| Lines removed | Sum of all deleted lines (net) in `.kt` files |
| Lines added | Sum of all new lines in `.kt` files |
| Net line delta | Lines added - Lines removed |
| Issues found | Sum of all issues in Kotlin files |
| Issues fixed | Sum of all fixes applied to Kotlin files |

### Step 3: Validation Summary Per Language

| Language | Analyzer | Command | Expected |
|----------|----------|---------|----------|
| Dart | Flutter Analyzer | `flutter analyze` | 0 new issues |
| Dart | Tests | `flutter test` | 0 new failures |
| TypeScript | ESLint | `npx eslint . --ext .ts,.tsx,.js,.jsx` | 0 new errors |
| TypeScript | Type Check | `npx tsc --noEmit` | 0 new errors |
| TypeScript | Tests | `npx jest --passWithNoTests` | 0 new failures |
| Kotlin | Android Lint | `./gradlew lint` | 0 new issues |
| Kotlin | Compilation | `./gradlew compileDebugKotlin` | Success |
| Kotlin | Tests | `./gradlew test` | 0 new failures |

### Step 4: Generate Report

---

## Output Format

```markdown
## Code Quality Sweep Report

### Overview

| Metric | Dart/Flutter | TypeScript/RN | Kotlin/Android | Total |
|--------|-------------|---------------|----------------|-------|
| Files scanned | [count] | [count] | [count] | [sum] |
| Files modified | [count] | [count] | [count] | [sum] |
| Lines removed | [count] | [count] | [count] | [sum] |
| Lines added | [count] | [count] | [count] | [sum] |
| **Net reduction** | **-[count]** | **-[count]** | **-[count]** | **-[sum]** |

### Apps Detected

| App | Language/Framework | Source Dir | Status |
|-----|-------------------|-----------|--------|
| apps/flutter-app | Flutter/Dart | lib/ | Swept |
| apps/rn-app | React Native/TypeScript | src/ | Swept |
| apps/android-app | Kotlin/Android | src/main/kotlin/ | Swept |

### Validation

#### Flutter/Dart
| Check | Status | Details |
|-------|--------|---------|
| `flutter analyze` | PASS/FAIL | [X] issues ([Y] pre-existing) |
| `flutter test` | PASS/FAIL | [X] passed, [Y] failed, [Z] skipped |

#### React Native/TypeScript
| Check | Status | Details |
|-------|--------|---------|
| `npx eslint .` | PASS/FAIL | [X] errors ([Y] pre-existing) |
| `npx tsc --noEmit` | PASS/FAIL | [X] errors |
| `npx jest` | PASS/FAIL | [X] passed, [Y] failed, [Z] skipped |

#### Kotlin/Android
| Check | Status | Details |
|-------|--------|---------|
| `./gradlew lint` | PASS/FAIL | [X] issues ([Y] pre-existing) |
| `./gradlew compileDebugKotlin` | PASS/FAIL | Compilation [success/failure] |
| `./gradlew test` | PASS/FAIL | [X] passed, [Y] failed, [Z] skipped |

---

### Changes by Category

#### 1. Unused Imports

| Language | Files Modified | Imports Removed |
|----------|---------------|-----------------|
| Dart | [count] | [count] |
| TypeScript | [count] | [count] |
| Kotlin | [count] | [count] |

#### 2. Dead Code

| Language | Files Deleted | Symbols Removed | Lines Removed |
|----------|--------------|-----------------|---------------|
| Dart | [count] | [count] | [count] |
| TypeScript | [count] | [count] | [count] |
| Kotlin | [count] | [count] | [count] |

<details>
<summary>Dead symbols removed (Dart)</summary>

| File | Symbol | Type | Lines |
|------|--------|------|-------|
| ... | ... | ... | ... |

</details>

<details>
<summary>Dead symbols removed (TypeScript)</summary>

| File | Symbol | Type | Lines |
|------|--------|------|-------|
| ... | ... | ... | ... |

</details>

<details>
<summary>Dead symbols removed (Kotlin)</summary>

| File | Symbol | Type | Lines |
|------|--------|------|-------|
| ... | ... | ... | ... |

</details>

#### 3. Duplicated Constants

| Language | Constants Centralized | Values Replaced | New Constant Files |
|----------|---------------------|-----------------|-------------------|
| Dart | [count] | [count] | [list] |
| TypeScript | [count] | [count] | [list] |
| Kotlin | [count] | [count] | [list] |

<details>
<summary>Centralized constants (all languages)</summary>

| Language | Value | Constant | Occurrences |
|----------|-------|----------|-------------|
| ... | ... | ... | ... |

</details>

#### 4. Duplicated Logic

| Language | Patterns Extracted | New Shared Files | Lines Saved |
|----------|-------------------|-----------------|-------------|
| Dart | [count] | [count] | [count] |
| TypeScript | [count] | [count] | [count] |
| Kotlin | [count] | [count] | [count] |

#### 5. Inconsistent Patterns

| Language | Naming Fixes | Async Standardizations | Import Fixes | Other |
|----------|-------------|----------------------|-------------|-------|
| Dart | [count] | [count] | [count] | [count] |
| TypeScript | [count] | [count] | [count] | [count] |
| Kotlin | [count] | [count] | [count] | [count] |

#### 6. Spaghetti Code

| Language | Functions Refactored | UI Methods Split | Nesting Reduced | Concerns Separated |
|----------|---------------------|-----------------|-----------------|-------------------|
| Dart | [count] | [count] | [count] | [count] |
| TypeScript | [count] | [count] | [count] | [count] |
| Kotlin | [count] | [count] | [count] | [count] |

---

### Commits

| # | Message | Dart Files | TS Files | Kotlin Files | Net Lines |
|---|---------|-----------|---------|-------------|-----------|
| 1 | refactor: remove unused imports | [X] | [X] | [X] | -[Y] |
| 2 | refactor: remove dead code and unused symbols | [X] | [X] | [X] | -[Y] |
| 3 | refactor: centralize duplicated constants and hardcoded values | [X] | [X] | [X] | +[A]/-[B] |
| 4 | refactor: extract duplicated logic into shared utilities | [X] | [X] | [X] | +[A]/-[B] |
| 5 | refactor: standardize naming conventions and patterns | [X] | [X] | [X] | ~[Y] |
| 6 | refactor: improve code structure and reduce complexity | [X] | [X] | [X] | +[A]/-[B] |

### Remaining Items (out of scope)

Items detected but intentionally not fixed:

#### Pre-existing Analyzer Warnings
| Language | Tool | Count |
|----------|------|-------|
| Dart | flutter analyze | [count] |
| TypeScript | eslint | [count] |
| Kotlin | gradle lint | [count] |

#### Kept for Testing
| Language | Symbol Count | Reason |
|----------|-------------|--------|
| Dart | [count] | Referenced in test files |
| TypeScript | [count] | Referenced in test files |
| Kotlin | [count] | Referenced in test files |

#### Requires Architectural Decisions
| Language | Item | Description |
|----------|------|-------------|
| ... | ... | ... |

---

> This sweep was performed by the code-quality-sweep agent.
> Languages analyzed: [list of detected languages].
> No business logic was changed. All modifications are structural refactoring only.
```
