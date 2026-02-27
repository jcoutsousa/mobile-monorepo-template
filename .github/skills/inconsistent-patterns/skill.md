---
name: inconsistent-patterns
description: >
  Detects and fixes inconsistent naming conventions, coding patterns, import
  styles, async patterns, and error handling across multi-language mobile codebases.
  Enforces Dart/Flutter (Effective Dart), TypeScript/JavaScript (ESLint/Prettier
  conventions), and Kotlin/Android (Kotlin coding conventions) style compliance.
---

# Inconsistent Patterns Skill

Standardize naming conventions, coding patterns, and style across the codebase. This skill is **language-aware** and enforces the correct conventions per language.

## Language Detection

| File Extension | Language | Style Guide Reference |
|---------------|----------|----------------------|
| `.dart` | Dart | [Effective Dart](https://dart.dev/effective-dart/style) |
| `.ts`, `.tsx` | TypeScript | ESLint recommended + Prettier |
| `.js`, `.jsx` | JavaScript | ESLint recommended + Prettier |
| `.kt` | Kotlin | [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html) |

---

## Dart / Flutter

### Naming Convention Audit

#### File Names (lowercase_with_underscores)
```
# Correct: user_profile.dart, api_client.dart
# Wrong: UserProfile.dart, apiClient.dart, user-profile.dart

# Search for violations:
find lib/ -name "*.dart" | grep -E '[A-Z]|[^_a-z0-9.]'
```

#### Class Names (UpperCamelCase)
```dart
// Correct: UserProfile, ApiClient, HomeScreen
// Wrong: userProfile, API_Client, home_screen

// Search: ^class [a-z]|^class [A-Z]+[_]
```

#### Variable & Function Names (lowerCamelCase)
```dart
// Correct: userName, fetchData(), isLoading
// Wrong: user_name, fetch_data(), is_loading

// Search for snake_case: \b[a-z]+_[a-z]+\b  (in function bodies, not string literals)
```

#### Constants (lowerCamelCase preferred in Dart)
```dart
// Dart style guide prefers lowerCamelCase for constants:
const maxRetries = 3;
const defaultTimeout = Duration(seconds: 30);

// If project uses SCREAMING_CAPS consistently, maintain that.
// Key: be consistent throughout the project
```

#### Private Members (_underscore prefix)
```dart
// Correct: _isLoading, _fetchData(), _UserState
```

### Async Pattern Audit

#### Mixed async/await and .then()
```dart
// Inconsistent:
final data = await fetchData();          // File A
fetchData().then((data) { ... });        // File B

// Standardize to async/await (Dart preference)
```

Search patterns:
```
\.then\(
\.catchError\(
\.whenComplete\(
```

### Error Handling Pattern Audit

```dart
// Check consistency in:
// 1. Try/catch granularity
// 2. Error reporting: print(e) vs debugPrint(e) vs logger.error(e)
// 3. Empty catch blocks: catch\s*\(e\)\s*\{[\s]*\}
```

### Import Style Audit

```dart
// Check: relative vs package imports (project should use one style)
// Check: import ordering (dart: -> package: -> relative, alphabetical)
// Never mix both styles for the same file
```

### Widget Pattern Audit

```dart
// Missing const where possible:
Container(child: Text('hello'))      // Bad
const SizedBox(height: 16)          // Good

// Missing keys in list items:
itemBuilder.*=>(?!.*key:)
```

### Dart Validation
```
flutter analyze   -- no new errors
dart format .     -- formatting applied
flutter test      -- all tests pass
```

---

## TypeScript / JavaScript (React Native)

### Naming Convention Audit

#### File Names
```
# Components: PascalCase.tsx (e.g., UserProfile.tsx, HomeScreen.tsx)
# Hooks: camelCase starting with 'use' (e.g., useAuth.ts, useAsync.ts)
# Utilities: camelCase.ts (e.g., validators.ts, formatDate.ts)
# Constants: camelCase.ts or SCREAMING_SNAKE.ts
# Types: PascalCase.ts (e.g., UserTypes.ts)
# Tests: same name + .test.ts or .spec.ts

# Search for violations:
# Component files not PascalCase: find src/components -name "*.tsx" | grep -E '^[a-z]'
# Hook files not starting with use: find src/hooks -name "*.ts" | grep -v '^use'
```

#### Component Names (PascalCase)
```typescript
// Correct: UserProfile, HomeScreen, AuthProvider
// Wrong: userProfile, home_screen, authprovider

// Search: export (const|function) [a-z].*React  (in .tsx files)
```

#### Function & Variable Names (camelCase)
```typescript
// Correct: userName, fetchData, isLoading
// Wrong: user_name, fetch_data, is_loading

// Search for snake_case in code: \b[a-z]+_[a-z]+\b (exclude string literals and imported names)
```

#### Constants
```typescript
// Top-level constants: SCREAMING_SNAKE_CASE or camelCase (be consistent)
// Enum values: PascalCase
// Object keys: camelCase

const MAX_RETRIES = 3;       // or maxRetries -- pick one style
const API_BASE_URL = '...';  // or apiBaseUrl
```

#### Type/Interface Names (PascalCase)
```typescript
// Correct: UserProfile, ApiResponse, NavigationParams
// Wrong: userProfile, apiResponse, navigation_params

// Search: (type|interface) [a-z]
```

### Async Pattern Audit

#### Mixed async/await and .then()
```typescript
// Inconsistent:
const data = await fetchData();                    // File A
fetchData().then((data) => { ... }).catch(...);    // File B

// Standardize to async/await
```

Search patterns:
```
\.then\(
\.catch\((?!Error)
```

#### Mixed Promise Handling
```typescript
// Inconsistent:
new Promise((resolve, reject) => { ... });  // Manual promise creation
// vs
async function fetchData() { ... }          // Async function

// Prefer async/await over manual Promise construction where possible
```

### Error Handling Pattern Audit

```typescript
// Check consistency in:
// 1. console.log vs console.error vs custom logger
// 2. Error boundaries vs try/catch in components
// 3. Error response handling patterns across API calls

// Search patterns:
console\.log\(.*error\|err\|exception
console\.warn\(
console\.error\(
```

### Import Style Audit

```typescript
// Check: import order consistency
// Standard order:
// 1. Node/built-in modules
// 2. External packages
// 3. Internal aliases (@/)
// 4. Relative imports
// 5. Side-effect imports

// Check: named vs default import consistency for same modules
// Check: barrel file (index.ts) import patterns
// Check: type-only imports using 'import type' where appropriate
```

### Component Pattern Audit

```typescript
// 1. Functional vs class components (should all be functional in modern RN)
// Search: class.*extends.*Component

// 2. Inline styles vs StyleSheet
// Inconsistent:
<View style={{ padding: 16 }}>       // inline
<View style={styles.container}>       // StyleSheet
// Standardize to StyleSheet.create

// 3. Props destructuring consistency
// Inconsistent:
function Comp(props) { props.name }    // access via props
function Comp({ name }) { name }       // destructured
// Standardize to destructuring

// 4. Export style consistency
// Inconsistent:
export default function Home() {}      // default
export const Home = () => {}           // named
// Choose one pattern per file type
```

### TypeScript Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx   -- no new errors
npx prettier --check .                 -- formatting consistent
npx tsc --noEmit                       -- no type errors
npx jest --passWithNoTests             -- all tests pass
```

---

## Kotlin / Android

### Naming Convention Audit

#### File Names (PascalCase.kt)
```
# Correct: UserProfile.kt, ApiClient.kt, HomeActivity.kt
# Wrong: user_profile.kt, apiClient.kt, home-activity.kt

# Exception: Files containing only top-level extension functions may use lowercase
# e.g., stringExtensions.kt
```

#### Class Names (PascalCase)
```kotlin
// Correct: UserProfile, ApiClient, HomeActivity
// Wrong: userProfile, API_Client, home_activity

// Search: ^class [a-z]|^class [A-Z]+[_]
```

#### Function Names (camelCase)
```kotlin
// Correct: fetchData, getUserName, isLoading
// Wrong: fetch_data, GetUserName, is_loading

// Exception: @Composable functions use PascalCase:
@Composable
fun UserProfile() { ... }  // Correct for composables

// Search for violations: ^fun [A-Z][a-z]  (non-composable functions starting uppercase)
// Search for snake_case: ^fun [a-z]+_[a-z]
```

#### Property Names (camelCase)
```kotlin
// Correct: userName, isLoading, itemCount
// Wrong: user_name, is_loading, item_count

// Constants in companion objects: SCREAMING_SNAKE_CASE
companion object {
    const val MAX_RETRIES = 3
    const val API_BASE_URL = "..."
}

// Top-level constants: SCREAMING_SNAKE_CASE
const val DEFAULT_TIMEOUT = 30_000L
```

#### Package Names (lowercase, no underscores)
```kotlin
// Correct: com.example.myapp.data.repository
// Wrong: com.example.myApp.Data.Repository
```

### Async Pattern Audit

#### Mixed Coroutine Patterns
```kotlin
// Inconsistent:
viewModelScope.launch { ... }                    // Some files
CoroutineScope(Dispatchers.IO).launch { ... }    // Other files

// Standardize: use structured concurrency with viewModelScope or lifecycleScope

// Search patterns:
GlobalScope\.launch           // Should be avoided
CoroutineScope\(.*\)\.launch  // Should use structured scope
```

#### Callback vs Coroutine
```kotlin
// Inconsistent:
fun fetchData(callback: (Result) -> Unit) { ... }  // Callback style
suspend fun fetchData(): Result { ... }              // Coroutine style

// Standardize to coroutines (Kotlin preference)
```

### Error Handling Pattern Audit

```kotlin
// Check consistency in:
// 1. try/catch granularity
// 2. Log.d vs Log.e vs Timber.d vs custom logger
// 3. Result type usage vs exceptions
// 4. Error propagation patterns

// Search patterns:
Log\.[dewiv]\(
println\(
System\.out\.print
catch\s*\(\s*e\s*:\s*Exception\s*\)\s*\{\s*\}  // empty catch
```

### Import Style Audit

```kotlin
// Check: wildcard vs explicit imports
import com.example.utils.*     // wildcard (discouraged)
import com.example.utils.formatDate  // explicit (preferred)

// Check: import ordering (alphabetical)
// Check: unused wildcard imports that should be explicit
```

### Android Pattern Audit

```kotlin
// 1. View binding vs findViewById vs synthetic
// Standardize to view binding or Compose

// 2. Fragment argument patterns
// Standardize: companion object newInstance or Safe Args

// 3. Lifecycle observation patterns
// Standardize: lifecycle-aware components, collectAsStateWithLifecycle

// 4. Nullable handling
// Inconsistent:
if (value != null) { value.method() }  // manual null check
value?.method()                         // safe call
value!!.method()                        // force unwrap (avoid)
// Standardize to safe calls, minimize !! usage
```

### Kotlin Validation
```
./gradlew lint                   -- no new issues
./gradlew ktlintCheck            -- formatting consistent
./gradlew compileDebugKotlin     -- compiles successfully
./gradlew test                   -- all tests pass
```

---

## Cross-Language Rules

### Step: Apply Fixes (All Languages)

For each inconsistency category in any language:
1. Determine the **dominant pattern** in the codebase (>60% usage)
2. Standardize all files to the dominant pattern
3. If no dominant pattern exists, follow the language's official style guide
4. Make a single commit with all pattern standardizations

### Important: Respect Language Boundaries

- **Never** apply Dart conventions to TypeScript files or vice versa
- **Never** apply JavaScript conventions to Kotlin files
- Each language has its own style guide; respect them independently
- Cross-language consistency is NOT a goal (each language has its own idioms)

## Output Format

```markdown
## Inconsistent Patterns Audit

### Summary
- **Apps scanned**: [count]
- **Languages**: [list]
- **Pattern categories checked**: [count per language]
- **Inconsistencies found**: [count per language]
- **Files modified**: [count per language]

### Dart / Flutter -- [app name]

#### Naming Convention Fixes
| File | Before | After | Rule |
|------|--------|-------|------|
| lib/utils/api_helper.dart | fetch_data() | fetchData() | lowerCamelCase |

#### Async Pattern Standardization
| File | Before | After |
|------|--------|-------|
| lib/services/auth.dart:45 | .then().catchError() | async/await + try/catch |

#### Import Style Fixes
| File | Issue | Fix |
|------|-------|-----|
| lib/views/home.dart | Mixed relative and package | Standardized to relative |

### TypeScript / React Native -- [app name]

#### Naming Convention Fixes
| File | Before | After | Rule |
|------|--------|-------|------|
| src/utils/api_helper.ts | fetch_data() | fetchData() | camelCase |
| src/components/userCard.tsx | userCard | UserCard | PascalCase component |

#### Component Pattern Standardization
| File | Before | After |
|------|--------|-------|
| src/screens/Home.tsx | class component | functional component |
| src/components/Card.tsx | inline styles | StyleSheet.create |

#### Import Style Fixes
| File | Issue | Fix |
|------|-------|-----|
| src/screens/Profile.tsx | Unordered imports | Sorted by category |

### Kotlin / Android -- [app name]

#### Naming Convention Fixes
| File | Before | After | Rule |
|------|--------|-------|------|
| data/UserRepo.kt | fetch_data() | fetchData() | camelCase |
| utils/helpers.kt | helpers.kt | Helpers.kt | PascalCase file |

#### Coroutine Pattern Standardization
| File | Before | After |
|------|--------|-------|
| ui/HomeViewModel.kt | GlobalScope.launch | viewModelScope.launch |
| data/Repository.kt | callback pattern | suspend function |

#### Error Handling Standardization
| File | Before | After |
|------|--------|-------|
| data/ApiService.kt:23 | println(error) | Timber.e(error) |
| ui/LoginViewModel.kt:45 | empty catch block | Log + error state |
```
