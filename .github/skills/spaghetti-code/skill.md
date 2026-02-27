---
name: spaghetti-code
description: >
  Detects and refactors spaghetti code across multi-language mobile codebases.
  Supports Flutter/Dart (long build methods, widget nesting, mixed concerns),
  React Native/TypeScript (oversized components, prop drilling, mixed logic),
  and Kotlin/Android (god activities, deep callback nesting, mixed concerns).
  Improves code structure and maintainability per language's idiomatic patterns.
---

# Spaghetti Code Skill

Detect and refactor structural code issues that harm maintainability and readability. This skill is **language-aware** and applies appropriate thresholds and refactoring strategies per language.

## Language Detection

| File Extension | Language | UI Framework |
|---------------|----------|-------------|
| `.dart` | Dart | Flutter widgets |
| `.ts`, `.tsx` | TypeScript | React Native components |
| `.js`, `.jsx` | JavaScript | React Native components |
| `.kt` | Kotlin | Jetpack Compose / Android Views |

---

## Step 1: Function Length Analysis (All Languages)

### Thresholds

| Length | Severity | Action |
|--------|----------|--------|
| >100 lines | Critical | Must refactor |
| 50-100 lines | Warning | Should refactor |
| 30-50 lines | Info | Review for clarity |

---

## Dart / Flutter

### Long Functions

Scan all `.dart` files for functions and methods exceeding 50 lines (excluding comments and blank lines).

#### Refactoring Strategy
```dart
// Before: 120-line _handleSubmit method
void _handleSubmit() {
  // validation (20 lines) ...
  // API call (30 lines) ...
  // state update (25 lines) ...
  // navigation (15 lines) ...
}

// After: orchestrator + focused methods
void _handleSubmit() {
  if (!_validateForm()) return;
  final result = await _submitToApi();
  _updateState(result);
  _navigateToConfirmation();
}
```

### Long Build Methods (>100 lines)

Search pattern: `Widget build\(BuildContext context\)`

#### Refactoring Strategy
```dart
// Before: 150-line build method

// After:
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),           // or const HeaderSection()
      _buildContentList(),      // or const ContentList()
      _buildActionButtons(),    // or const ActionButtons()
    ],
  );
}
```

Prefer separate widget classes over private methods (better performance with const).

### Deep Widget Nesting (>5 levels)

```dart
// Bad: >5 levels without extraction
Scaffold(body: SafeArea(child: Padding(child: Column(children: [Container(child: Row(...))]))))

// Fix: extract subtrees into named widgets
```

### Deep Logic Nesting (>3 levels of if/for/while)

```dart
// Bad:
if (condition1) {
  if (condition2) {
    for (var item in items) {
      if (condition3) { /* 4 levels */ }
    }
  }
}

// Fix: early returns and extraction
if (!condition1) return;
if (!condition2) return;
for (var item in items) {
  _processItem(item);
}
```

### Mixed Concerns

#### Business Logic in UI Code
Search for in widget files:
```
http.get(
await apiClient.
await repository.
items.where(
items.map(
items.sort(
```

**Fix:** Move to ViewModel, Controller, or Service classes.

#### UI Logic in Business Classes
Search for in service/viewmodel/repository files:
```
import 'package:flutter/material.dart';   // in a service file
Navigator.of(context)
ScaffoldMessenger
BuildContext                              // in service method signatures
```

**Fix:** Return data/state, let the UI layer handle presentation.

### God Class Detection

Indicators:
- Class >500 lines
- Class >15 public methods
- Class imports from >10 different files
- Vague name: `Manager`, `Helper`, `Utils`, `Handler`

**Fix:** Split into focused classes following Single Responsibility Principle.

### Excessive Coupling

```dart
// Direct instantiation instead of injection
final service = ApiService();  // in a widget

// Long method chains
widget.parent.context.service.repository.method()

// Circular dependencies
// file_a.dart imports file_b.dart AND file_b.dart imports file_a.dart
```

### Dart Validation
```
flutter analyze   -- no new errors
flutter test      -- all tests pass
```

---

## TypeScript / JavaScript (React Native)

### Long Components (>100 lines of JSX/TSX)

Scan all `.tsx` and `.jsx` files for component functions exceeding 100 lines.

#### Refactoring Strategy
```typescript
// Before: 200-line HomeScreen component

// After: orchestrator + sub-components
const HomeScreen: React.FC = () => {
  const { data, loading } = useHomeData();

  return (
    <View style={styles.container}>
      <HeaderSection title={data.title} />
      <ContentList items={data.items} />
      <ActionBar onSubmit={handleSubmit} />
    </View>
  );
};
```

### Long Hook Bodies (>50 lines)

Custom hooks that contain too much logic.

```typescript
// Before: 80-line useAuth hook with mixed concerns

// After: composed hooks
function useAuth() {
  const tokenManager = useTokenManager();
  const sessionTracker = useSessionTracker();
  const loginFlow = useLoginFlow(tokenManager);
  return { ...loginFlow, session: sessionTracker.session };
}
```

### Deep JSX Nesting (>5 levels)

```typescript
// Bad: deeply nested JSX
<View>
  <ScrollView>
    <View>
      <View>
        <View>
          <Text>Too deep</Text>
        </View>
      </View>
    </View>
  </ScrollView>
</View>

// Fix: extract into named components
<View>
  <ScrollView>
    <ContentSection>
      <DetailCard />
    </ContentSection>
  </ScrollView>
</View>
```

### Deep Callback/Promise Nesting (>3 levels)

```typescript
// Bad: callback hell
fetchUser().then(user => {
  fetchPosts(user.id).then(posts => {
    fetchComments(posts[0].id).then(comments => {
      // 3+ levels deep
    });
  });
});

// Fix: async/await
const user = await fetchUser();
const posts = await fetchPosts(user.id);
const comments = await fetchComments(posts[0].id);
```

### Mixed Concerns

#### Business Logic in Components
Search for in `.tsx`/`.jsx` files:
```typescript
// API calls directly in components (outside hooks)
fetch(
axios.
api.

// Data transformation in render
items.filter(
items.map(          // complex mapping, not JSX rendering
items.sort(
items.reduce(

// Complex calculations in render
if (price * quantity * tax > threshold) {
```

**Fix:** Move to custom hooks, services, or utility functions.

#### UI Logic in Services/Utils
Search for in non-component files:
```typescript
import.*from ['"]react-native['"]   // in a service file
Alert.alert                          // in a utility file
navigation.navigate                  // in a data layer file
StyleSheet                          // in a business logic file
```

**Fix:** Return data, let components handle presentation.

### Prop Drilling Detection

Search for props passed through 3+ component levels without being used:

```typescript
// Bad: prop drilling through intermediary components
<Parent user={user}>        // passes to Child
  <Child user={user}>       // passes to GrandChild
    <GrandChild user={user} /> // actually uses it
  </Child>
</Parent>

// Fix: Context, state management, or composition
```

### God Component Detection

Indicators:
- Component file >300 lines
- Component manages >5 pieces of state (`useState` calls)
- Component has >10 event handler functions
- Component renders >3 distinct UI sections

**Fix:** Split into container/presentation pattern or compose from smaller components.

### TypeScript Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx   -- no new errors
npx tsc --noEmit                       -- no type errors
npx jest --passWithNoTests             -- all tests pass
```

---

## Kotlin / Android

### Long Functions

Scan all `.kt` files for functions exceeding 50 lines (excluding comments and blank lines).

#### Refactoring Strategy
```kotlin
// Before: 100-line handleLogin function
fun handleLogin(email: String, password: String) {
    // validation (15 lines) ...
    // API call (25 lines) ...
    // token storage (15 lines) ...
    // navigation (10 lines) ...
}

// After: orchestrator + focused functions
fun handleLogin(email: String, password: String) {
    validateCredentials(email, password)
    val token = authenticateUser(email, password)
    storeToken(token)
    navigateToHome()
}
```

### Long Composable Functions (>80 lines)

Search pattern: `@Composable\s+fun\s+`

#### Refactoring Strategy
```kotlin
// Before: 150-line HomeScreen composable

// After:
@Composable
fun HomeScreen(viewModel: HomeViewModel = hiltViewModel()) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    Column {
        HeaderSection(title = uiState.title)
        ContentList(items = uiState.items)
        ActionBar(onSubmit = viewModel::handleSubmit)
    }
}
```

### Deep Nesting (>3 levels of logic, >5 levels of Compose)

#### Logic Nesting
```kotlin
// Bad:
if (condition1) {
    when (state) {
        is State.Loading -> {
            if (retryCount < maxRetries) {
                // 4 levels deep
            }
        }
    }
}

// Fix: early returns and when expressions
if (!condition1) return
when (state) {
    is State.Loading -> handleLoading(retryCount)
    is State.Error -> handleError(state.error)
    is State.Success -> handleSuccess(state.data)
}
```

#### Compose Nesting
```kotlin
// Bad: deeply nested composables
Scaffold {
    Column {
        Card {
            Row {
                Column {
                    Box {
                        Text("Too deep")  // 6+ levels
                    }
                }
            }
        }
    }
}

// Fix: extract into named composables
Scaffold {
    Column {
        UserInfoCard(user = user)
    }
}
```

### Mixed Concerns

#### Business Logic in UI Layer
Search for in Activity/Fragment/Composable files:
```kotlin
// API calls in UI
repository.
apiService.
retrofit.
Room

// Data processing in composables
items.filter {
items.sortedBy {
items.groupBy {

// SharedPreferences in UI
getSharedPreferences
```

**Fix:** Move to ViewModel or UseCase classes.

#### UI Logic in Data Layer
Search for in repository/service files:
```kotlin
import android.widget.            // in data layer
import androidx.compose.           // in data layer
import android.app.Activity        // in data layer
Toast.makeText                     // in repository
context.startActivity              // in data layer
```

**Fix:** Return data/state, let the UI layer handle presentation.

### God Activity/Fragment/ViewModel Detection

Indicators:
- Class >500 lines
- ViewModel with >10 public methods or >8 StateFlow/LiveData fields
- Activity/Fragment handling >5 distinct features
- Class name is generic: `MainViewModel`, `BaseManager`, `AppHelper`

**Fix:** Split into feature-specific ViewModels, use composition over inheritance.

### Callback Hell in Coroutines

```kotlin
// Bad: nested callbacks even with coroutines
viewModelScope.launch {
    val user = withContext(Dispatchers.IO) {
        val response = api.getUser()
        if (response.isSuccessful) {
            val profile = withContext(Dispatchers.Default) {
                processProfile(response.body()!!)
            }
            profile
        } else { null }
    }
}

// Fix: flatten with sequential suspend calls
viewModelScope.launch {
    val response = userRepository.getUser()
    val profile = profileProcessor.process(response)
    _uiState.value = UiState.Success(profile)
}
```

### Kotlin Validation
```
./gradlew lint                   -- no new issues
./gradlew compileDebugKotlin     -- compiles successfully
./gradlew test                   -- all tests pass
```

---

## Cross-Language Rules

### Priority Order (All Languages)

1. **Critical**: Functions >100 lines, UI build/render methods >150 lines
2. **High**: Mixed concerns (business logic in UI layer)
3. **Medium**: Deep nesting, god classes/components
4. **Low**: Minor coupling issues, prop drilling

### Refactoring Principles (All Languages)

- **Extract, do not rewrite** -- preserve behavior while improving structure
- **Name by purpose** -- method/component names should explain WHAT, not HOW
- **Preserve the orchestrator** -- the original function becomes a high-level coordinator
- **One responsibility per extraction** -- each extracted unit does one thing
- **Test before and after** -- verify behavior is preserved

## Output Format

```markdown
## Spaghetti Code Audit

### Summary
- **Apps scanned**: [count]
- **Languages**: [list]
- **Long functions found**: [count per language]
- **Long UI methods found**: [count per language]
- **Deep nesting found**: [count per language]
- **Mixed concerns found**: [count per language]
- **God classes/components found**: [count per language]

### Dart / Flutter -- [app name]

#### Refactored Functions
| File | Method | Before | After | Extraction |
|------|--------|--------|-------|------------|
| lib/views/settings.dart | build() | 180 lines | 45 lines | 4 sub-widgets |
| lib/services/auth.dart | login() | 85 lines | 30 lines | 3 helper methods |

#### Mixed Concerns Fixed
| File | Issue | Fix |
|------|-------|-----|
| lib/views/home.dart:45 | API call in build() | Moved to ViewModel |

### TypeScript / React Native -- [app name]

#### Refactored Components
| File | Component | Before | After | Extraction |
|------|-----------|--------|-------|------------|
| src/screens/Home.tsx | HomeScreen | 250 lines | 60 lines | 4 sub-components |
| src/hooks/useAuth.ts | useAuth | 80 lines | 25 lines | 3 composed hooks |

#### Mixed Concerns Fixed
| File | Issue | Fix |
|------|-------|-----|
| src/screens/Profile.tsx:30 | fetch() in render | Moved to useProfileData hook |

#### Prop Drilling Fixed
| Prop | Levels Deep | Fix |
|------|-------------|-----|
| user | 4 | Created UserContext |

### Kotlin / Android -- [app name]

#### Refactored Functions
| File | Method | Before | After | Extraction |
|------|--------|--------|-------|------------|
| ui/HomeScreen.kt | HomeScreen() | 160 lines | 40 lines | 4 composables |
| data/AuthRepository.kt | login() | 90 lines | 30 lines | 3 private functions |

#### Mixed Concerns Fixed
| File | Issue | Fix |
|------|-------|-----|
| ui/SettingsActivity.kt:45 | SharedPrefs in Activity | Moved to SettingsRepository |

### Nesting Reduced (All Languages)
| File | Language | Method | Before | After | Technique |
|------|----------|--------|--------|-------|-----------|
| lib/utils/parser.dart | Dart | parse() | 5 levels | 2 levels | Early returns |
| src/utils/transform.ts | TypeScript | transform() | 4 levels | 2 levels | Async/await |
| data/Mapper.kt | Kotlin | map() | 4 levels | 2 levels | When expression |
```
