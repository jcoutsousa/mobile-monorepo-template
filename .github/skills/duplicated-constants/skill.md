---
name: duplicated-constants
description: >
  Detects hardcoded values and duplicated constants scattered across files in
  multi-language codebases (mobile, web, backend). Supports Flutter/Dart (Color,
  EdgeInsets, TextStyle, Duration), React Native/TypeScript (style objects, theme values,
  API URLs), Kotlin/Android (color resources, dimension values, string literals),
  Python (magic numbers, hardcoded strings), Go (constants), Rust (const values),
  and web frameworks (CSS values, theme tokens).
---

# Duplicated Constants Skill

Find hardcoded values repeated across files and centralize them into a single source of truth. This skill is **language-aware** and applies appropriate detection patterns and centralization strategies per language.

## Language Detection

| File Extension | Language | Constants Location |
|---------------|----------|--------------------|
| `.dart` | Dart | `constants.dart`, `theme.dart` |
| `.ts`, `.tsx` | TypeScript | `constants.ts`, `theme.ts`, `config.ts` |
| `.js`, `.jsx` | JavaScript | `constants.js`, `theme.js`, `config.js` |
| `.kt` | Kotlin | `Constants.kt`, `Theme.kt`, `res/values/` |
| `.py` | Python | `constants.py`, `config.py`, `settings.py` |
| `.go` | Go | `constants.go`, `config.go` |
| `.rs` | Rust | `constants.rs`, `config.rs` |
| `.vue`, `.svelte` | Web | `constants.ts`, `theme.ts`, CSS variables |

---

## Dart / Flutter

### Step 1: Scan for Hardcoded Values

#### Colors
```
Color\(0x[0-9A-Fa-f]+\)
Color\.fromARGB\(\s*\d+
Color\.fromRGBO\(\s*\d+
Colors\.[a-zA-Z]+
```

#### Magic Numbers (Padding, Margin, Radius)
```
EdgeInsets\.(all|symmetric|only|fromLTRB)\(\s*\d+
BorderRadius\.circular\(\s*\d+
SizedBox\((width|height):\s*\d+
```

#### Hardcoded Strings
```
https?://[^\s'"]+
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
'/api/[^\s'"]+
"/api/[^\s'"]+
```

#### TextStyle Definitions
```
TextStyle\(
  fontSize:\s*\d+
  fontWeight:\s*FontWeight\.\w+
```

#### Duration Values
```
Duration\((milliseconds|seconds|minutes):\s*\d+\)
```

### Centralization Targets

| Category | Target File | Class Pattern |
|----------|-------------|---------------|
| Colors | `constants.dart` or `theme.dart` | `class AppColors { static const Color primary = ...; }` |
| Spacing/sizing | `constants.dart` | `class AppSpacing { static const double sm = 8.0; }` |
| URLs/endpoints | `constants.dart` | `class ApiEndpoints { static const String baseUrl = ...; }` |
| Strings | `constants.dart` or localization | `class AppStrings { static const String appName = ...; }` |
| Durations | `constants.dart` | `class AppDurations { static const Duration short = ...; }` |
| TextStyles | `theme.dart` | `class AppTextStyles { static const TextStyle heading = ...; }` |

### Validation
```
flutter analyze   -- no new errors
flutter test      -- all tests pass
```

---

## TypeScript / JavaScript (React Native)

### Step 1: Scan for Hardcoded Values

#### Colors
```typescript
// Hex color strings
['"]#[0-9A-Fa-f]{3,8}['"]

// RGB/RGBA values
rgba?\(\s*\d+

// Color names in style objects
color:\s*['"][a-zA-Z]+['"]
backgroundColor:\s*['"]#
```

#### Magic Numbers (Spacing, Sizing)
```typescript
// Style object numeric values
padding:\s*\d+
margin:\s*\d+
borderRadius:\s*\d+
fontSize:\s*\d+
width:\s*\d+
height:\s*\d+

// StyleSheet.create values
StyleSheet\.create\(
```

#### Hardcoded Strings
```typescript
// URLs
['"]https?://[^\s'"]+['"]

// API paths
['"]\/api\/[^\s'"]+['"]

// Email addresses
['"][a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}['"]

// Storage keys
AsyncStorage\.(getItem|setItem)\(['"][^'"]+['"]\)
```

#### Font Configurations
```typescript
fontFamily:\s*['"][^'"]+['"]
fontWeight:\s*['"][^'"]+['"]
fontSize:\s*\d+
lineHeight:\s*\d+
```

#### Duration/Timing Values
```typescript
// Animation durations
duration:\s*\d+
delay:\s*\d+
setTimeout\([^,]+,\s*\d+
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| Colors | `src/theme/colors.ts` | `export const Colors = { primary: '#1A237E', ... } as const;` |
| Spacing | `src/theme/spacing.ts` | `export const Spacing = { sm: 8, md: 16, ... } as const;` |
| Typography | `src/theme/typography.ts` | `export const Typography = { heading: { fontSize: 24, ... }, ... } as const;` |
| URLs/Endpoints | `src/config/api.ts` | `export const ApiEndpoints = { baseUrl: '...', ... } as const;` |
| Strings | `src/constants/strings.ts` | `export const Strings = { appName: '...', ... } as const;` |
| Durations | `src/constants/animations.ts` | `export const Durations = { short: 200, medium: 400, ... } as const;` |
| Storage keys | `src/constants/storageKeys.ts` | `export const StorageKeys = { authToken: 'auth_token', ... } as const;` |

### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx   -- no new errors
npx tsc --noEmit                       -- no type errors
npx jest --passWithNoTests             -- all tests pass
```

---

## Kotlin / Android

### Step 1: Scan for Hardcoded Values

#### Colors
```kotlin
// Hex color values in code
Color\(0x[0-9A-Fa-f]+\)
Color\.parseColor\(['"]#[0-9A-Fa-f]+['"]\)
Color\.[A-Z]+   // Color.RED, Color.BLACK

// Compose color literals
Color\(0xFF[0-9A-Fa-f]{6}\)
```

#### Magic Numbers (Dimensions, Padding)
```kotlin
// Compose dp/sp values
\.dp\b
\.sp\b
\d+\.dp
\d+\.sp

// View dimensions in code
setPadding\(\s*\d+
setMargin\(\s*\d+
layoutParams.*=.*\d+
```

#### Hardcoded Strings
```kotlin
// URLs
"https?://[^\s"]+

// API paths
"/api/[^\s"]+

// SharedPreferences keys
getString\(\s*"[^"]+
putString\(\s*"[^"]+
```

#### Font/Text Values
```kotlin
fontSize\s*=\s*\d+\.sp
fontWeight\s*=\s*FontWeight\.\w+
TextStyle\(
```

#### Duration Values
```kotlin
// Coroutine delays
delay\(\s*\d+
// Animation durations
durationMillis\s*=\s*\d+
tween\(durationMillis\s*=\s*\d+
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| Colors | `ui/theme/Color.kt` or `res/values/colors.xml` | `object AppColors { val Primary = Color(0xFF1A237E) }` |
| Dimensions | `ui/theme/Dimensions.kt` or `res/values/dimens.xml` | `object Dimens { val SpacingSm = 8.dp }` |
| Typography | `ui/theme/Type.kt` | `object AppTypography { val Heading = TextStyle(...) }` |
| URLs/Endpoints | `data/config/ApiConfig.kt` | `object ApiConfig { const val BASE_URL = "..." }` |
| Strings | `res/values/strings.xml` or `Constants.kt` | XML resources or `object AppStrings { const val APP_NAME = "..." }` |
| Durations | `ui/theme/Animations.kt` | `object AnimDurations { const val SHORT = 200L }` |
| Preferences keys | `data/config/PrefsKeys.kt` | `object PrefsKeys { const val AUTH_TOKEN = "auth_token" }` |

### Validation
```
./gradlew lint                   -- no new issues
./gradlew compileDebugKotlin     -- compiles successfully
./gradlew test                   -- all tests pass
```

---

## Python

### Step 1: Scan for Hardcoded Values

#### Magic Numbers
```python
# Numeric literals used in logic (exclude 0, 1, -1 which are idiomatic)
timeout=\d{2,}
max_retries\s*=\s*\d+
limit\s*=\s*\d+
sleep\(\d+
range\(\d{2,}
```

#### Hardcoded Strings
```python
# URLs and API paths
['"]https?://[^\s'"]+['"]
['"]\/api\/[^\s'"]+['"]

# Email addresses
['"][a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}['"]

# Environment variable keys
os\.environ\.get\(['"][^'"]+['"]
os\.getenv\(['"][^'"]+['"]

# Status codes and error messages
status_code\s*=\s*\d{3}
detail\s*=\s*['"][^'"]+['"]
```

#### Configuration Values
```python
# Database URLs, Redis URLs, etc.
['"]postgresql://
['"]redis://
['"]mongodb://

# Repeated settings
max_length\s*=\s*\d+
min_length\s*=\s*\d+
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| API URLs | `config.py` or `settings.py` | `BASE_URL = "..."` |
| Timeouts/retries | `constants.py` | `MAX_RETRIES = 3` |
| Status messages | `constants.py` | `ERROR_NOT_FOUND = "Resource not found"` |
| Env var keys | `settings.py` | `DB_HOST_KEY = "DATABASE_HOST"` |
| Numeric limits | `constants.py` | `MAX_PAGE_SIZE = 100` |

### Validation
```
ruff check .   -- no new errors
pytest         -- all tests pass
```

---

## Go

### Step 1: Scan for Hardcoded Values

#### Magic Numbers
```go
// Numeric literals in logic
timeout.*\d{2,}
maxRetries.*=\s*\d+
time\.(Sleep|After|Tick)\(.*\d+
make\(\w+,\s*\d{2,}
```

#### Hardcoded Strings
```go
// URLs and paths
"https?://[^\s"]+
"/api/[^\s"]+

// Error messages
errors\.New\("[^"]+"\)
fmt\.Errorf\("[^"]+

// HTTP headers and content types
"Content-Type"
"application/json"
"Authorization"

// Environment variable keys
os\.Getenv\("[^"]+"\)
```

#### Duration Values
```go
time\.Duration\(\d+\)
\d+\s*\*\s*time\.(Second|Millisecond|Minute|Hour)
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| URLs/endpoints | `config/config.go` | `const BaseURL = "..."` |
| Timeouts/durations | `constants.go` | `const DefaultTimeout = 30 * time.Second` |
| Error messages | `errors.go` or `constants.go` | `var ErrNotFound = errors.New("not found")` |
| HTTP constants | `constants.go` | `const ContentTypeJSON = "application/json"` |
| Env var keys | `config/config.go` | `const EnvDBHost = "DATABASE_HOST"` |

### Validation
```
go build ./...    -- compiles successfully
go vet ./...      -- no new issues
go test ./...     -- all tests pass
```

---

## Rust

### Step 1: Scan for Hardcoded Values

#### Magic Numbers
```rust
// Numeric literals in logic (exclude 0, 1)
timeout.*\d{2,}
max_retries.*=\s*\d+
capacity.*\d{2,}
Duration::from_secs\(\d+
Duration::from_millis\(\d+
```

#### Hardcoded Strings
```rust
// URLs and paths
"https?://[^\s"]+
"/api/[^\s"]+

// Error messages
.expect\("[^"]+"\)
anyhow!\("[^"]+"\)
format!\("[^"]+

// Environment variable keys
std::env::var\("[^"]+"\)
env::var\("[^"]+"\)

// HTTP constants
"Content-Type"
"application/json"
```

#### Const Values
```rust
// Repeated const patterns
const [A-Z_]+:\s*&str\s*=
const [A-Z_]+:\s*(u\d+|i\d+|usize|f\d+)\s*=
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| URLs/endpoints | `config.rs` | `pub const BASE_URL: &str = "...";` |
| Timeouts/durations | `constants.rs` | `pub const DEFAULT_TIMEOUT: Duration = Duration::from_secs(30);` |
| Error messages | `errors.rs` | Custom error enum or `const` strings |
| Env var keys | `config.rs` | `pub const ENV_DB_HOST: &str = "DATABASE_HOST";` |
| Numeric limits | `constants.rs` | `pub const MAX_PAGE_SIZE: usize = 100;` |

### Validation
```
cargo check                     -- compiles successfully
cargo clippy -- -D warnings     -- no new warnings
cargo test                      -- all tests pass
```

---

## Web Frameworks (React / Vue / Angular)

### Step 1: Scan for Hardcoded Values

#### CSS / Theme Values
```
// Repeated color values in CSS/SCSS/styled-components
color:\s*#[0-9A-Fa-f]{3,8}
background:\s*#[0-9A-Fa-f]{3,8}
border.*#[0-9A-Fa-f]{3,8}

// Repeated spacing values
padding:\s*\d+px
margin:\s*\d+px
gap:\s*\d+px

// Repeated breakpoints
@media.*\d{3,4}px

// Repeated z-index values
z-index:\s*\d+

// Repeated font sizes
font-size:\s*\d+
```

#### Theme Tokens
```typescript
// Inline style objects with repeated values
style={{ color: '#...', padding: ... }}
sx={{ color: '#...', p: ... }}  // MUI

// Tailwind repeated custom values (non-standard)
className=".*\[#[0-9A-Fa-f]+\]"
```

#### Hardcoded Strings
Follow the same TypeScript/JavaScript patterns from the React Native section, plus:
```
// Route paths
path:\s*['"][^'"]+['"]
to:\s*['"][^'"]+['"]
href:\s*['"][^'"]+['"]

// Local storage keys
localStorage\.(getItem|setItem)\(['"][^'"]+['"]\)
sessionStorage\.(getItem|setItem)\(['"][^'"]+['"]\)
```

### Centralization Targets

| Category | Target File | Pattern |
|----------|-------------|---------|
| Colors | `theme/colors.ts` or CSS custom properties | `--color-primary: #1A237E;` or `export const colors = { ... }` |
| Spacing | `theme/spacing.ts` or CSS custom properties | `--spacing-md: 16px;` or `export const spacing = { ... }` |
| Breakpoints | `theme/breakpoints.ts` or CSS custom properties | `--bp-tablet: 768px;` |
| Z-index | `theme/zindex.ts` | `export const zIndex = { modal: 1000, ... }` |
| Route paths | `routes/paths.ts` | `export const ROUTES = { home: '/', ... }` |
| Storage keys | `constants/storage.ts` | `export const STORAGE_KEYS = { ... } as const` |

### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx,.vue  -- no new errors
npx tsc --noEmit                           -- no type errors
npx jest --passWithNoTests                 -- all tests pass
```

---

## Cross-Language Process

### Step 2: Group and Categorize (All Languages)

For each duplicated value found in any language:

1. **Count occurrences** across files within that app
2. **Identify the semantic meaning** (e.g., `#1A237E` -> "primary brand color")
3. **Determine the right home** based on the language-specific targets above
4. **Check for existing constants files** -- update rather than create duplicates

### Step 3: Centralize (All Languages)

For each category:

1. **Create or update** the appropriate constants file for that language
2. **Define named constants** with descriptive names following the language's conventions
3. **Replace all occurrences** with the centralized constant
4. **Verify no occurrence was missed** by searching for the raw value

### Step 4: Handle Duplicate Constant Definitions (All Languages)

If the same constant is defined in multiple files:

1. **Choose the canonical location** (the most central/appropriate constants file)
2. **Update all imports** to point to the canonical location
3. **Remove duplicate definitions**

### Step 5: Validate Per Language

Run the language-appropriate validation commands listed in each section above.

## Output Format

```markdown
## Duplicated Constants Audit

### Summary
- **Apps scanned**: [count]
- **Languages**: [list]
- **Hardcoded values found**: [count per language]
- **Unique values duplicated**: [count per language]
- **Files modified**: [count per language]
- **Constants centralized**: [count per language]

### Dart / Flutter -- [app name]

#### Colors Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| Color(0xFF1A237E) | AppColors.primary | 8 | 5 |

#### Strings Centralized
| Value | Constant Name | Occurrences |
|-------|--------------|-------------|
| support@example.com | AppStrings.supportEmail | 3 |

### TypeScript / React Native -- [app name]

#### Colors Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| '#1A237E' | Colors.primary | 12 | 7 |

#### Storage Keys Centralized
| Raw Value | Constant Name | Occurrences |
|-----------|--------------|-------------|
| 'auth_token' | StorageKeys.authToken | 4 |

### Kotlin / Android -- [app name]

#### Colors Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| Color(0xFF1A237E) | AppColors.Primary | 6 | 4 |

#### Dimensions Centralized
| Raw Value | Constant Name | Occurrences |
|-----------|--------------|-------------|
| 16.dp | Dimens.SpacingMd | 15 |

### Python -- [service name]

#### Constants Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| 30 (timeout) | DEFAULT_TIMEOUT | 5 | 3 |
| "Resource not found" | ERROR_NOT_FOUND | 4 | 3 |

### Go -- [service name]

#### Constants Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| "application/json" | ContentTypeJSON | 8 | 5 |
| 30 * time.Second | DefaultTimeout | 4 | 3 |

### Rust -- [service name]

#### Constants Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| Duration::from_secs(30) | DEFAULT_TIMEOUT | 3 | 2 |
| "Content-Type" | HEADER_CONTENT_TYPE | 6 | 4 |

### Web (React/Vue/Angular) -- [app name]

#### Theme Values Centralized
| Raw Value | Constant Name | Occurrences | Files |
|-----------|--------------|-------------|-------|
| '#1A237E' | --color-primary / colors.primary | 14 | 9 |
| '16px' | --spacing-md / spacing.md | 22 | 12 |
| '768px' | --bp-tablet / breakpoints.tablet | 8 | 6 |

### Duplicate Definitions Consolidated (All Languages)
| Constant | Language | Was In | Moved To |
|----------|----------|--------|----------|
| supportEmail | Dart | settings_viewmodel.dart, constants.dart | constants.dart only |
| BASE_URL | TypeScript | api.ts, config.ts | config/api.ts only |
| AUTH_TOKEN | Kotlin | LoginViewModel.kt, PrefsKeys.kt | PrefsKeys.kt only |
| MAX_RETRIES | Python | auth_service.py, api_client.py | constants.py only |
| DefaultTimeout | Go | handlers/user.go, handlers/auth.go | constants.go only |
| BASE_URL | Rust | handlers/mod.rs, client.rs | config.rs only |
| colors.primary | Web | Header.tsx, Footer.tsx, theme.ts | theme/colors.ts only |
```
