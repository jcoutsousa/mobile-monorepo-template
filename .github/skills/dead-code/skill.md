---
name: dead-code
description: >
  Detects and removes dead code across multi-language codebases (mobile, web, backend).
  Supports Flutter/Dart (unused classes, functions, empty lifecycle overrides, part files),
  React Native/TypeScript (unused exports, components, hooks, type definitions),
  Kotlin/Android (unused activities, fragments, composables, extension functions),
  Python (unused functions, classes, variables), Go (unexported unused symbols),
  Rust (dead_code lint, unused items), and web frameworks (unused components, exports).
---

# Dead Code Skill

Remove all dead code while preserving symbols that are referenced anywhere in the project. This skill is **language-aware** and applies appropriate detection strategies per language.

## Language Detection

Before scanning, determine the language of each file:

| File Extension | Language | Source Directories |
|---------------|----------|-------------------|
| `.dart` | Dart | `lib/`, `bin/` |
| `.ts`, `.tsx` | TypeScript | `src/` |
| `.js`, `.jsx` | JavaScript | `src/` |
| `.kt` | Kotlin | `src/main/kotlin/`, `src/main/java/` |
| `.py` | Python | `src/`, `app/`, project root |
| `.go` | Go | project root, `internal/`, `cmd/`, `pkg/` |
| `.rs` | Rust | `src/` |
| `.vue` | Vue | `src/` |
| `.svelte` | Svelte | `src/` |

---

## Dart / Flutter

### Candidate Dead Code

#### Unused Functions & Methods
```
# Top-level functions
^[A-Za-z<>_]+ [a-z][a-zA-Z0-9_]*\(

# Private methods (underscore prefix)
_[a-z][a-zA-Z0-9_]*\(
```

#### Unused Classes, Mixins, Enums
```
^class [A-Z][a-zA-Z0-9_]+
^mixin [A-Z][a-zA-Z0-9_]+
^enum [A-Z][a-zA-Z0-9_]+
```

#### Unused Variables & Constants
```
^const [a-z]
^final [a-z]
^const [A-Z]
static const
static final
```

#### Entire Unused Files
A file is dead if:
- No other file in the project imports it
- It is not referenced in `pubspec.yaml` or build configuration
- It is not a generated file (`.g.dart`, `.freezed.dart`)

#### Empty Lifecycle Overrides
```dart
// Dead code if they only call super:
@override
void dispose() { super.dispose(); }

@override
void didChangeDependencies() { super.didChangeDependencies(); }

@override
void didUpdateWidget(covariant OldWidget oldWidget) { super.didUpdateWidget(oldWidget); }
```

#### Deprecated Wrappers
```
@deprecated
@Deprecated(
```

#### Verification Scope
Search `lib/`, `test/`, `integration_test/`, `bin/` for references.
Check re-exports, reflection usage, generated code (`.g.dart`, `.freezed.dart`), and `pubspec.yaml`.

#### Validation
```
flutter analyze   -- no new errors
flutter test      -- all tests still pass
```

---

## TypeScript / JavaScript (React Native)

### Candidate Dead Code

#### Unused Exported Functions & Components
```
# Named exports
export\s+(const|function|class|enum|type|interface)\s+[A-Za-z]

# Default exports
export\s+default\s+(function|class)

# Arrow function exports
export\s+const\s+\w+\s*=\s*(\(|async)
```

For each exported symbol, search all other project files for imports of that symbol.

#### Unused React Components
```
# Function components
export\s+(const|function)\s+[A-Z][a-zA-Z0-9]+

# Check if component is used as JSX: <ComponentName or <ComponentName>
```

#### Unused Custom Hooks
```
# Custom hooks (use* prefix convention)
export\s+(const|function)\s+use[A-Z][a-zA-Z0-9]+
```

#### Unused Type Definitions
```typescript
// Exported types and interfaces never imported elsewhere
export type [A-Z]
export interface [A-Z]
```

#### Entire Unused Files
A file is dead if:
- No other file imports from it (search for its path in all import statements)
- It is not referenced in configuration files (`package.json` scripts, `metro.config.js`, `babel.config.js`)
- It is not a dynamically loaded module
- It is not listed as an entry point

#### Dead Route/Screen Components
Components registered in navigation but never navigated to from any other screen.

#### Unused Event Handlers
```typescript
// Functions starting with handle/on that are defined but never passed as props or called
const handleSubmit = ...
const onPress = ...
```

#### Commented-Out Code
```
// Large blocks of commented-out code (>3 consecutive lines starting with //)
^\s*//\s*[a-zA-Z].*[\({=]
^\s*/\*[\s\S]*?\*/
```

#### Verification Scope
Search `src/`, `__tests__/`, `*.test.ts`, `*.spec.ts` for references.
Check barrel files (`index.ts`), dynamic imports, navigation configs, and `package.json`.

#### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx   -- no new errors
npx tsc --noEmit                       -- no type errors
npx jest --passWithNoTests             -- all tests pass
```

---

## Kotlin / Android

### Candidate Dead Code

#### Unused Functions & Methods
```
# Top-level functions
^fun [a-z][a-zA-Z0-9_]*\(

# Private functions
^private fun [a-z][a-zA-Z0-9_]*\(

# Extension functions
^fun [A-Z][a-zA-Z0-9_]*\.[a-z][a-zA-Z0-9_]*\(
```

#### Unused Classes, Objects, Interfaces
```
^class [A-Z][a-zA-Z0-9_]+
^data class [A-Z][a-zA-Z0-9_]+
^object [A-Z][a-zA-Z0-9_]+
^interface [A-Z][a-zA-Z0-9_]+
^sealed class [A-Z][a-zA-Z0-9_]+
^enum class [A-Z][a-zA-Z0-9_]+
^abstract class [A-Z][a-zA-Z0-9_]+
```

#### Unused Properties & Constants
```
^val [a-z]
^var [a-z]
^const val [A-Z]
companion object {
    const val
    val
}
```

#### Entire Unused Files
A file is dead if:
- No other file imports its symbols
- It is not registered in `AndroidManifest.xml` (activities, services, receivers)
- It is not referenced in `build.gradle.kts` or Dagger/Hilt modules
- It is not a generated file (Dagger, Room, databinding)

#### Unused Android Components
```kotlin
// Activities, Fragments, Services, BroadcastReceivers not referenced in:
// - AndroidManifest.xml
// - Navigation graphs
// - Other component code
```

#### Empty Override Methods
```kotlin
// Dead code if they only call super:
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
}

override fun onResume() { super.onResume() }
override fun onPause() { super.onPause() }
override fun onDestroy() { super.onDestroy() }
```

#### Deprecated Members
```
@Deprecated
```

#### Commented-Out Code
```
// Large blocks (>3 lines)
^\s*//\s*[a-zA-Z].*[\({=]
^\s*/\*[\s\S]*?\*/
```

#### Verification Scope
Search `src/main/`, `src/test/`, `src/androidTest/` for references.
Check `AndroidManifest.xml`, navigation graphs, Dagger/Hilt modules, Room database definitions, and `build.gradle.kts`.

#### Validation
```
./gradlew lint             -- no new issues
./gradlew compileDebugKotlin -- compiles successfully
./gradlew test             -- all tests pass
```

---

## Python

### Candidate Dead Code

#### Unused Functions & Methods
```
# Top-level functions
^def [a-z][a-zA-Z0-9_]*\(

# Private functions (underscore prefix convention)
^def _[a-z][a-zA-Z0-9_]*\(

# Class methods
^\s+def [a-z][a-zA-Z0-9_]*\(self
^\s+def _[a-z][a-zA-Z0-9_]*\(self
```

#### Unused Classes
```
^class [A-Z][a-zA-Z0-9_]+
```

#### Unused Variables & Constants
```
^[A-Z_]+ =          # Module-level constants
^[a-z_]+ =          # Module-level variables
```

#### Entire Unused Files
A file is dead if:
- No other file in the project imports from it
- It is not referenced in configuration files (`pyproject.toml`, `setup.py`, entry points)
- It is not a migration file, conftest, or `__init__.py`
- It is not dynamically loaded

#### Unused Route Handlers / Endpoints
```python
# FastAPI endpoints not registered or unreachable
@app.get("/unused-endpoint")
@router.post("/deprecated")
```

#### Commented-Out Code
```
# Large blocks of commented-out code (>3 consecutive lines starting with #)
^\s*#\s*[a-zA-Z].*[\({=]
```

#### Verification Scope
Search `src/`, `app/`, `tests/`, and project root for references.
Check `__init__.py` re-exports, `pyproject.toml` entry points, Alembic migrations, Celery tasks, and `conftest.py`.

#### Validation
```
ruff check .        -- no new errors
pytest              -- all tests still pass
```

---

## Go

### Candidate Dead Code

#### Unexported Unused Functions & Methods
```
# Unexported (lowercase) functions not called anywhere
^func [a-z][a-zA-Z0-9_]*\(

# Methods on types
^func \([a-z]+ \*?[A-Z][a-zA-Z0-9_]+\) [a-z][a-zA-Z0-9_]*\(
```

Note: Exported functions (PascalCase) may be part of the public API and should be kept unless confirmed unused across the entire module.

#### Unused Types & Interfaces
```
^type [A-Z][a-zA-Z0-9_]+ struct
^type [A-Z][a-zA-Z0-9_]+ interface
^type [a-z][a-zA-Z0-9_]+ struct    # unexported types
```

#### Unused Variables & Constants
```
^var [a-z]
^const [a-z]
^const \(
^var \(
```

#### Entire Unused Files
A file is dead if:
- No other file imports its package symbols
- It is not a `_test.go` file
- It is not referenced via `//go:generate` or build tags
- It is not a `main.go` entry point

#### Commented-Out Code
```
// Large blocks (>3 lines)
^\s*//\s*[a-zA-Z].*[\({=]
^\s*/\*[\s\S]*?\*/
```

#### Verification Scope
Search all `.go` files in the module for references.
Check `go.mod`, `main.go` entry points, `init()` functions, and build tags.

#### Validation
```
go build ./...     -- compiles successfully
go vet ./...       -- no new issues
go test ./...      -- all tests pass
```

---

## Rust

### Candidate Dead Code

#### Unused Functions & Methods
```
# Public functions (may be part of API)
^pub fn [a-z][a-z_0-9]*\(

# Private functions
^fn [a-z][a-z_0-9]*\(

# impl methods
^\s+pub fn [a-z][a-z_0-9]*\(
^\s+fn [a-z][a-z_0-9]*\(
```

#### Unused Structs, Enums, Traits
```
^pub struct [A-Z][a-zA-Z0-9_]+
^struct [A-Z][a-zA-Z0-9_]+
^pub enum [A-Z][a-zA-Z0-9_]+
^enum [A-Z][a-zA-Z0-9_]+
^pub trait [A-Z][a-zA-Z0-9_]+
^trait [A-Z][a-zA-Z0-9_]+
```

#### Unused Constants & Statics
```
^const [A-Z_]+:
^static [A-Z_]+:
^pub const [A-Z_]+:
^pub static [A-Z_]+:
```

#### Entire Unused Files (Modules)
A module file is dead if:
- No `mod` declaration references it in parent module
- It is not declared in `lib.rs` or `main.rs`
- It is not referenced by `Cargo.toml` (bin targets, examples)

#### Leverage Compiler Warnings
Rust's `dead_code` lint catches most unused items:
```
cargo clippy -- -W dead_code
```
Review and remove items flagged by the compiler.

#### Commented-Out Code
```
// Large blocks (>3 lines)
^\s*//\s*[a-zA-Z].*[\({=]
^\s*/\*[\s\S]*?\*/
```

#### Verification Scope
Search `src/`, `tests/`, `examples/`, and `benches/` for references.
Check `mod` declarations, `pub use` re-exports, `Cargo.toml` targets, and feature-gated code.

#### Validation
```
cargo check                     -- compiles successfully
cargo clippy -- -D warnings     -- no new warnings
cargo test                      -- all tests pass
```

---

## Web Frameworks (React / Vue / Angular)

### Candidate Dead Code

#### Unused Components
```
# React components (function/const exports)
export\s+(const|function)\s+[A-Z][a-zA-Z0-9]+

# Vue SFC files -- check if any other file imports the .vue file
# Angular components -- check if declared in any module and used in templates
```

For each exported component, search all project files for:
- JSX/TSX usage: `<ComponentName` or `<ComponentName>`
- Vue template usage: `<component-name` or `<ComponentName`
- Angular template usage: `<app-component-name`
- Dynamic imports: `() => import('./ComponentName')`

#### Unused Composables / Hooks
```
# React hooks (use* prefix)
export\s+(const|function)\s+use[A-Z][a-zA-Z0-9]+

# Vue composables (use* prefix)
export\s+(const|function)\s+use[A-Z][a-zA-Z0-9]+
```

#### Unused Store Modules / State
```
# Pinia stores, Vuex modules, Redux slices
export\s+const\s+use[A-Z][a-zA-Z0-9]+Store
createSlice\(\{.*name:\s*['"][^'"]+['"]
```

#### Unused Utility Functions & Types
```
export\s+(const|function|type|interface)\s+[a-zA-Z]
```

#### Dead Routes / Pages
Components registered in routing configuration but never navigated to from any other component.

#### Verification Scope
Search `src/`, `__tests__/`, `*.test.ts`, `*.spec.ts` for references.
Check router configs, barrel files (`index.ts`), lazy-loaded routes, and storybook files.

#### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx,.vue  -- no new errors
npx tsc --noEmit                           -- no type errors (React/Angular)
npx vue-tsc --noEmit                       -- no type errors (Vue)
npx jest --passWithNoTests                 -- all tests pass
```

---

## Cross-Language Rules

### Verification Before Removal (All Languages)

For every candidate symbol in any language:

1. **Search the entire project** (source + tests + config) for references
2. **Check re-exports / barrel files** -- symbol may be re-exported for external consumers
3. **Check reflection / annotation usage** -- frameworks may use symbols by name
4. **Check generated code** -- build tools may reference it
5. **Check configuration files** -- entry points, manifests, navigation configs

**Keep the symbol if:**
- It appears in any test file (even if unused in production code)
- It is part of a public API (exported from the package)
- It is used via reflection, code generation, or framework conventions
- You are not 100% certain it is unused

### Order of Removal (All Languages)

1. **Entire dead files** first (removes the most code)
2. **Dead classes, interfaces, types** (may cascade to removing related methods)
3. **Dead functions and methods**
4. **Dead variables, properties, and constants**
5. **Empty lifecycle/override methods**
6. **Commented-out code blocks** (>3 lines)

After removing, clean up any imports that become unused as a result.

## Output Format

```markdown
## Dead Code Audit

### Summary
- **Apps scanned**: [count]
- **Languages**: [list]
- **Symbols scanned**: [count per language]
- **Dead symbols found**: [count per language]
- **Dead files found**: [count per language]
- **Lines removed**: [count per language]

### Dart / Flutter -- [app name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| lib/utils/error_messages.dart | Zero imports across project | 45 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| lib/viewmodels/settings_viewmodel.dart | _onLegacyToggle() | method | 23 |

### TypeScript / React Native -- [app name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| src/utils/legacyHelper.ts | No imports found | 67 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| src/hooks/useOldAuth.ts | useOldAuth | hook | 34 |
| src/components/DeprecatedCard.tsx | DeprecatedCard | component | 55 |

### Kotlin / Android -- [app name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| ui/legacy/OldSettingsActivity.kt | Not in Manifest, no references | 120 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| data/repository/CacheManager.kt | clearLegacyCache() | function | 28 |

### Commented-Out Code Removed (All Languages)
| File | Language | Lines | Description |
|------|----------|-------|-------------|
| lib/views/home_screen.dart | Dart | 45-62 | Old navigation logic |
| src/screens/Settings.tsx | TypeScript | 23-40 | Previous auth flow |
| ui/MainFragment.kt | Kotlin | 88-105 | Deprecated menu setup |

### Python -- [service name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| app/utils/legacy_helpers.py | Zero imports across project | 89 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| app/services/cache.py | _rebuild_index() | function | 34 |

### Go -- [service name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| internal/legacy/converter.go | No references in module | 112 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| internal/handlers/user.go | formatLegacy() | unexported func | 22 |

### Rust -- [service name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| src/utils/old_parser.rs | No mod declaration | 78 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| src/handlers/auth.rs | validate_legacy_token() | function | 45 |

### Web (React/Vue/Angular) -- [app name]

#### Dead Files Removed
| File | Reason | Lines |
|------|--------|-------|
| src/components/OldDashboard.tsx | No imports found | 156 |

#### Dead Symbols Removed
| File | Symbol | Type | Lines |
|------|--------|------|-------|
| src/hooks/useDeprecatedAuth.ts | useDeprecatedAuth | hook | 42 |
| src/stores/legacyStore.ts | useLegacyStore | store | 67 |

### Kept (uncertain)
| Symbol | Language | Reason Kept |
|--------|----------|-------------|
| BaseService.init() | Dart | May be used via reflection |
| formatLegacyDate | TypeScript | Exported from barrel file |
| NetworkInterceptor | Kotlin | Referenced in Dagger module |
| register_events() | Python | May be called by framework at startup |
| init() | Go | Package init function (auto-called) |
| pub use crate::models | Rust | Public re-export for library API |
| DashboardWidget | Vue | Dynamically loaded via router |
```
