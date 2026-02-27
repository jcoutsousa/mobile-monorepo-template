---
name: duplicated-logic
description: >
  Detects duplicated or near-duplicated functions, methods, code blocks, and
  component/widget patterns across multi-language mobile codebases. Supports
  Flutter/Dart (widgets, mixins, extensions), React Native/TypeScript (components,
  hooks, utility functions), and Kotlin/Android (composables, extension functions,
  utility classes). Extracts shared logic into reusable abstractions per language.
---

# Duplicated Logic Skill

Find duplicated code blocks and extract them into shared utilities or reusable components. This skill is **language-aware** and applies appropriate extraction patterns per language.

## Language Detection

| File Extension | Language | Extraction Patterns |
|---------------|----------|---------------------|
| `.dart` | Dart | Utility functions, widgets, mixins, extensions |
| `.ts`, `.tsx` | TypeScript | Utility functions, components, custom hooks |
| `.js`, `.jsx` | JavaScript | Utility functions, components, custom hooks |
| `.kt` | Kotlin | Extension functions, utility objects, composables |

---

## Step 1: Identify Duplication Patterns (All Languages)

### Exact Duplicates
Search for identical or near-identical code blocks (>5 lines) appearing in multiple files:

1. **Functions with identical bodies** -- same logic, possibly different names
2. **Copy-pasted code blocks** -- same sequence of statements in different methods
3. **Identical UI component subtrees** -- same composition in multiple build/render methods

### Near Duplicates (Structural Clones)
Look for functions/blocks that:
- Have the same structure but different variable names
- Differ only in 1-2 parameters or constants
- Follow the same pattern with minor variations

---

## Dart / Flutter Duplication Patterns

### Common Flutter Duplications

```dart
// 1. Repeated error handling / snackbar logic
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(...), backgroundColor: ...),
);

// 2. Repeated dialog patterns
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(...),
    content: Text(...),
    actions: [...],
  ),
);

// 3. Repeated API call patterns
try {
  final response = await apiClient.someMethod();
  // handle success
} catch (e) {
  // handle error (same pattern)
}

// 4. Repeated navigation patterns
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => SomeScreen()),
);

// 5. Repeated widget decoration
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: someColor,
    boxShadow: [...],
  ),
  child: ...
)

// 6. Repeated list item builders
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) { /* same structure */ },
)
```

### Dart Extraction Patterns

#### Utility Functions
```dart
// Before: same validation in 3 files
if (email == null || !email.contains('@') || email.length < 5) { ... }

// After: lib/utils/validators.dart
bool isValidEmail(String? email) =>
    email != null && email.contains('@') && email.length >= 5;
```

#### Reusable Widgets
```dart
// Before: same card pattern in 4 screens
Container(decoration: BoxDecoration(...), padding: EdgeInsets.all(16), child: ...)

// After: lib/widgets/info_card.dart
class InfoCard extends StatelessWidget {
  final List<Widget> children;
  const InfoCard({required this.children});
}
```

#### Mixins
```dart
// Before: same loading state logic in multiple ViewModels
bool _isLoading = false;
void setLoading(bool value) { ... }

// After: shared mixin
mixin LoadingMixin on ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) { _isLoading = value; notifyListeners(); }
}
```

#### Extension Methods
```dart
// Before: same string formatting in multiple places
text.replaceAll('\n', ' ').trim().toLowerCase()

// After: extension
extension StringFormatting on String {
  String normalizeWhitespace() => replaceAll('\n', ' ').trim();
}
```

### Dart Validation
```
flutter analyze   -- no new errors
flutter test      -- all tests pass
```

---

## TypeScript / JavaScript (React Native) Duplication Patterns

### Common React Native Duplications

```typescript
// 1. Repeated API call patterns with loading/error state
const [loading, setLoading] = useState(false);
const [error, setError] = useState<string | null>(null);
try {
  setLoading(true);
  const response = await api.fetchSomething();
  // handle success
} catch (err) {
  setError(err.message);
} finally {
  setLoading(false);
}

// 2. Repeated alert/dialog patterns
Alert.alert(
  'Title',
  'Message',
  [{ text: 'OK', onPress: () => {} }, { text: 'Cancel', style: 'cancel' }],
);

// 3. Repeated style definitions across components
const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, backgroundColor: '#fff' },
  // identical patterns in multiple files
});

// 4. Repeated navigation patterns
navigation.navigate('ScreenName', { param1: value1 });

// 5. Repeated form validation logic
if (!email || !email.includes('@')) { ... }
if (!password || password.length < 8) { ... }

// 6. Repeated async storage operations
const value = await AsyncStorage.getItem('key');
if (value !== null) { JSON.parse(value); }

// 7. Repeated list rendering patterns
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={({ item }) => /* same structure */}
/>
```

### TypeScript Extraction Patterns

#### Custom Hooks
```typescript
// Before: same loading/error/data pattern in 5 components
const [loading, setLoading] = useState(false);
const [error, setError] = useState<string | null>(null);
const [data, setData] = useState<T | null>(null);

// After: src/hooks/useAsync.ts
export function useAsync<T>(asyncFn: () => Promise<T>) {
  const [state, setState] = useState<AsyncState<T>>({ loading: false, data: null, error: null });
  // ...
  return state;
}
```

#### Shared Components
```typescript
// Before: same card layout in 4 screens
<View style={cardStyles}>
  <Text style={titleStyle}>{title}</Text>
  <Text style={bodyStyle}>{body}</Text>
</View>

// After: src/components/InfoCard.tsx
export const InfoCard: React.FC<InfoCardProps> = ({ title, body }) => (
  <View style={styles.card}>
    <Text style={styles.title}>{title}</Text>
    <Text style={styles.body}>{body}</Text>
  </View>
);
```

#### Utility Functions
```typescript
// Before: same validation in multiple files
if (!email || !email.includes('@') || email.length < 5) { ... }

// After: src/utils/validators.ts
export const isValidEmail = (email: string | null): boolean =>
  email !== null && email.includes('@') && email.length >= 5;
```

#### Higher-Order Components or Wrapper Patterns
```typescript
// Before: same error boundary pattern in multiple screens

// After: src/components/withErrorBoundary.tsx
export function withErrorBoundary<P>(Component: React.ComponentType<P>) {
  return (props: P) => (
    <ErrorBoundary fallback={<ErrorView />}>
      <Component {...props} />
    </ErrorBoundary>
  );
}
```

### TypeScript Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx   -- no new errors
npx tsc --noEmit                       -- no type errors
npx jest --passWithNoTests             -- all tests pass
```

---

## Kotlin / Android Duplication Patterns

### Common Kotlin/Android Duplications

```kotlin
// 1. Repeated coroutine launch patterns
viewModelScope.launch {
    try {
        _loading.value = true
        val result = repository.fetchSomething()
        _data.value = result
    } catch (e: Exception) {
        _error.value = e.message
    } finally {
        _loading.value = false
    }
}

// 2. Repeated Compose UI patterns
Card(
    modifier = Modifier.fillMaxWidth().padding(16.dp),
    elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
) {
    Column(modifier = Modifier.padding(16.dp)) {
        // same structure in multiple composables
    }
}

// 3. Repeated SharedPreferences access
val prefs = context.getSharedPreferences("prefs", Context.MODE_PRIVATE)
val value = prefs.getString("key", "default")

// 4. Repeated intent/navigation patterns
val intent = Intent(context, SomeActivity::class.java).apply {
    putExtra("key", value)
}
startActivity(intent)

// 5. Repeated RecyclerView setup
recyclerView.apply {
    layoutManager = LinearLayoutManager(context)
    adapter = someAdapter
    addItemDecoration(DividerItemDecoration(context, DividerItemDecoration.VERTICAL))
}

// 6. Repeated permission checks
if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
    != PackageManager.PERMISSION_GRANTED) {
    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), REQUEST_CODE)
}

// 7. Repeated toast/snackbar patterns
Snackbar.make(view, message, Snackbar.LENGTH_SHORT).show()
Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
```

### Kotlin Extraction Patterns

#### Extension Functions
```kotlin
// Before: same string formatting in multiple places
text.replace("\n", " ").trim().lowercase()

// After: utils/StringExtensions.kt
fun String.normalizeWhitespace(): String = replace("\n", " ").trim()
```

#### Utility Objects
```kotlin
// Before: same validation in multiple ViewModels
if (email.isNullOrBlank() || !email.contains("@")) { ... }

// After: utils/Validators.kt
object Validators {
    fun isValidEmail(email: String?): Boolean =
        !email.isNullOrBlank() && email.contains("@") && email.length >= 5
}
```

#### Reusable Composables
```kotlin
// Before: same card layout in 4 screens
Card(modifier = Modifier...) { Column { ... } }

// After: ui/components/InfoCard.kt
@Composable
fun InfoCard(title: String, body: String, modifier: Modifier = Modifier) {
    Card(modifier = modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = title, style = MaterialTheme.typography.titleMedium)
            Text(text = body, style = MaterialTheme.typography.bodyMedium)
        }
    }
}
```

#### Base ViewModels / Abstract Classes
```kotlin
// Before: same loading/error state in multiple ViewModels
private val _loading = MutableStateFlow(false)
val loading: StateFlow<Boolean> = _loading

// After: base/BaseViewModel.kt
abstract class BaseViewModel : ViewModel() {
    protected val _loading = MutableStateFlow(false)
    val loading: StateFlow<Boolean> = _loading.asStateFlow()

    protected fun <T> launchWithLoading(block: suspend () -> T): Job {
        return viewModelScope.launch {
            _loading.value = true
            try { block() } finally { _loading.value = false }
        }
    }
}
```

### Kotlin Validation
```
./gradlew lint                   -- no new issues
./gradlew compileDebugKotlin     -- compiles successfully
./gradlew test                   -- all tests pass
```

---

## Cross-Language Analysis Rules

### Step 2: Analyze Duplication (All Languages)

For each duplicate found in any language:

1. **Count occurrences** -- how many times does this pattern appear?
2. **Measure similarity** -- exact duplicate, structural clone, or similar pattern?
3. **Assess extraction difficulty** -- simple extract vs. needs parameterization
4. **Evaluate benefit** -- is extraction worth the abstraction cost?

**Rules of thumb:**
- 3+ exact duplicates -> always extract
- 2 exact duplicates > 10 lines -> extract
- 2 near-duplicates -> extract only if the abstraction is natural and clear
- If extraction would require >3 parameters -> consider whether the abstraction is worth it

### Step 3: Update All Call Sites (All Languages)

After extraction:
1. Replace all duplicate occurrences with calls to the shared utility/component
2. Update imports in all affected files
3. Verify no occurrence was missed with a project-wide search

### Step 4: Validate Per Language

Run the language-appropriate validation commands listed in each section above.
Manual review: does the extraction improve or hurt readability?

## Output Format

```markdown
## Duplicated Logic Audit

### Summary
- **Apps scanned**: [count]
- **Languages**: [list]
- **Duplicate patterns found**: [count per language]
- **Extractions performed**: [count per language]
- **Lines saved**: [count per language]
- **New shared files created**: [count per language]

### Dart / Flutter -- [app name]

#### Extractions Performed
| Pattern | Occurrences | Extracted To | Type |
|---------|-------------|-------------|------|
| Error snackbar display | 4 | lib/utils/ui_helpers.dart | Utility function |
| Card decoration widget | 3 | lib/widgets/info_card.dart | Widget |
| API error handling | 5 | lib/services/base_service.dart | Mixin |

### TypeScript / React Native -- [app name]

#### Extractions Performed
| Pattern | Occurrences | Extracted To | Type |
|---------|-------------|-------------|------|
| Loading/error state | 6 | src/hooks/useAsync.ts | Custom hook |
| Card layout component | 4 | src/components/InfoCard.tsx | Component |
| Form validation | 3 | src/utils/validators.ts | Utility function |

### Kotlin / Android -- [app name]

#### Extractions Performed
| Pattern | Occurrences | Extracted To | Type |
|---------|-------------|-------------|------|
| Coroutine loading pattern | 5 | base/BaseViewModel.kt | Abstract class |
| Card composable | 4 | ui/components/InfoCard.kt | Composable |
| String formatting | 3 | utils/StringExtensions.kt | Extension function |

### Duplicates Kept -- Not Worth Extracting (All Languages)
| Pattern | Language | Occurrences | Reason |
|---------|----------|-------------|--------|
| Simple null check | Dart | 2 | Too simple, extraction adds complexity |
| Basic console.log | TypeScript | 2 | Logging varies by context |
| Toast display | Kotlin | 2 | Context-dependent message |
```
