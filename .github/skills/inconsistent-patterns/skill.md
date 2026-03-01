---
name: inconsistent-patterns
description: >
  Detects and fixes inconsistent naming conventions, coding patterns, import
  styles, async patterns, and error handling across multi-language codebases.
  Supports Flutter/Dart, React Native/TypeScript, Kotlin/Android, Python, Go,
  Rust, and web frameworks (React/Vue/Angular). Enforces language-specific
  style guide compliance.
---

# Inconsistent Patterns Skill

Standardize naming conventions, coding patterns, and style across the codebase. This skill is **language-aware** and applies language-specific conventions.

## Step 1: Naming Convention Audit

### File Names (lowercase_with_underscores)
```
# Correct: user_profile.dart, api_client.dart
# Wrong: UserProfile.dart, apiClient.dart, user-profile.dart

# Search for violations:
find lib/ -name "*.dart" | grep -E '[A-Z]|[^_a-z0-9.]'
```

### Class Names (UpperCamelCase)
```dart
// Correct: UserProfile, ApiClient, HomeScreen
// Wrong: userProfile, API_Client, home_screen

// Search pattern:
^class [a-z]|^class [A-Z]+[_]
```

### Variable & Function Names (lowerCamelCase)
```dart
// Correct: userName, fetchData(), isLoading
// Wrong: user_name, fetch_data(), is_loading

// Search for snake_case in Dart (excluding constants):
\b[a-z]+_[a-z]+\b  // in function bodies, not in string literals
```

### Constants (lowerCamelCase or SCREAMING_CAPS — be consistent)
```dart
// Dart style guide prefers lowerCamelCase for constants:
const maxRetries = 3;
const defaultTimeout = Duration(seconds: 30);

// But if the project uses SCREAMING_CAPS consistently, maintain that:
const MAX_RETRIES = 3;

// The key is: be consistent throughout the project
```

### Private Members (prefixed with underscore)
```dart
// Correct: _isLoading, _fetchData(), _UserState
// Check for private members that should be public or vice versa
```

## Step 2: Async Pattern Audit

### Mixed async/await and .then()
```dart
// Inconsistent — mixing styles in the same codebase:
// File A:
final data = await fetchData();

// File B:
fetchData().then((data) {
  // ...
}).catchError((e) {
  // ...
});

// Standardize to async/await (preferred in Dart):
try {
  final data = await fetchData();
} catch (e) {
  // ...
}
```

### Search for .then() patterns that should be async/await:
```
\.then\(
\.catchError\(
\.whenComplete\(
```

## Step 3: Error Handling Pattern Audit

### Mixed error handling styles
```dart
// Check for consistency in:

// 1. Try/catch granularity
try { /* too much code */ } catch (e) { /* generic */ }  // Bad
try { /* specific operation */ } on SpecificException { /* specific */ }  // Good

// 2. Error reporting
print(e);           // Some files
debugPrint(e);      // Other files
logger.error(e);    // Yet others

// Standardize to one approach
```

### Search patterns:
```
catch\s*\(e\)\s*\{[\s]*\}     # Empty catch blocks
print\(.*error\|exception      # Print-based error handling
rethrow                         # Rethrow usage consistency
```

## Step 4: Import Style Audit

### Relative vs Package Imports
```dart
// Check for consistency — the project should use one style:

// Package imports (preferred for libraries):
import 'package:myapp/models/user.dart';

// Relative imports (acceptable for app code):
import '../models/user.dart';

// Never mix both styles for the same file
```

### Import Organization
```dart
// Standard order (check all files follow this):
// 1. dart: imports
// 2. package: imports (external packages first, then project package)
// 3. Relative imports
// Alphabetical within each section
```

## Step 5: Widget Pattern Audit

### Const Constructor Usage
```dart
// Missing const where possible:
Container(child: Text('hello'))      // Bad
const SizedBox(height: 16)           // Good — search for missing const
```

### Key Usage in Lists
```dart
// Missing keys in list items:
ListView(children: [
  ListTile(title: Text('item')),     // Missing Key
])

// Search for list builders without keys:
itemBuilder.*=>(?!.*key:)
```

## Python-Specific Patterns

### Mixed async/sync
```python
# Inconsistent: some endpoints async, some sync in the same app
# File A:
async def get_users():
    return await db.fetch_all()

# File B:
def get_products():
    return db.fetch_all()  # sync in an async framework

# Standardize: use async/await consistently in async frameworks (FastAPI)
```

### Search patterns:
```
^async def     # async functions
^def           # sync functions
await          # await usage in non-async context
```

### Naming Convention Issues
```python
# Mixed naming styles:
getUserData()     # camelCase (wrong for Python)
get_user_data()   # snake_case (correct)
GetUserData()     # PascalCase (only for classes)

# Check for:
# - camelCase function/variable names (should be snake_case)
# - SCREAMING_SNAKE for non-constant variables
# - Inconsistent underscore prefix for private members
```

### Type Hint Inconsistency
```python
# Inconsistent: some functions typed, some not
def get_user(user_id: int) -> User:    # typed
def get_product(product_id):            # untyped

# Standardize: type hints on all function signatures
```

### Import Style
```python
# Mixed import styles:
import os
from os import path           # vs import os; os.path
from os.path import join      # vs from os import path; path.join

# Standardize within the project
```

### Validation
```
ruff check .   -- no new errors
pytest         -- all tests pass
```

---

## Go-Specific Patterns

### Error Handling Inconsistency
```go
// Mixed error handling styles:

// File A: wraps errors
if err != nil {
    return fmt.Errorf("failed to get user: %w", err)
}

// File B: returns raw errors
if err != nil {
    return err
}

// File C: logs and returns
if err != nil {
    log.Printf("error: %v", err)
    return err
}

// Standardize: consistent wrapping with %w for context
```

### Search patterns:
```
if err != nil     # error handling blocks
return err        # raw error returns (check for missing context)
fmt\.Errorf       # wrapped errors
log\.(Print|Fatal).*err   # logged errors
```

### Receiver Naming
```go
// Inconsistent receiver names:
func (u *UserService) GetUser()     // 'u'
func (svc *UserService) CreateUser() // 'svc'
func (this *UserService) DeleteUser() // 'this' (Java-style, wrong for Go)

// Standardize: short, consistent receiver names per type
func (s *UserService) GetUser()
func (s *UserService) CreateUser()
```

### Context Usage
```go
// Inconsistent: some functions accept context, some don't
func GetUser(ctx context.Context, id int) (*User, error)  // correct
func GetProduct(id int) (*Product, error)                   // missing context

// Standardize: all I/O functions should accept context.Context as first param
```

### Validation
```
go vet ./...      -- no new issues
go test ./...     -- all tests pass
```

---

## Rust-Specific Patterns

### Result vs panic Inconsistency
```rust
// Mixed error handling:

// File A: proper Result handling
fn get_user(id: i64) -> Result<User, AppError> {
    let user = db.find(id)?;
    Ok(user)
}

// File B: panicking
fn get_product(id: i64) -> Product {
    db.find(id).unwrap()  // panics on error
}

// Standardize: use Result<T, E> consistently, no unwrap() in production code
```

### Search patterns:
```
\.unwrap\(\)       # potential panics
\.expect\(         # potential panics with message
\?                 # proper error propagation
Result<            # proper error handling
```

### Naming Convention Issues
```rust
// Check for:
// - non-snake_case function names
// - non-PascalCase type names
// - non-SCREAMING_SNAKE_CASE constants
// - Inconsistent module naming

// Rust enforces these via lints, but check for #[allow(non_snake_case)] overrides
```

### Clone vs Reference Inconsistency
```rust
// Mixed: some functions clone, some borrow
fn process_user(user: User) { ... }         // takes ownership
fn process_product(product: &Product) { ... } // borrows

// Standardize: borrow by default, own when needed
fn process_user(user: &User) { ... }
fn process_product(product: &Product) { ... }
```

### Validation
```
cargo clippy -- -D warnings   -- no new warnings
cargo test                    -- all tests pass
```

---

## Web-Specific Patterns (React / Vue / Angular)

### Mixed State Management
```tsx
// Inconsistent: different state approaches in the same app

// File A: local useState
const [user, setUser] = useState(null);

// File B: Redux/Zustand store
const user = useUserStore(state => state.user);

// File C: React Context
const { user } = useContext(UserContext);

// Standardize: choose one primary approach for shared state
```

### Component Definition Style
```tsx
// Mixed styles in the same project:

// Arrow function
const UserCard = ({ name }) => { ... };

// Function declaration
function UserCard({ name }) { ... }

// Standardize: pick one and use consistently
```

### CSS/Styling Inconsistency
```
// Mixed styling approaches:
// File A: CSS Modules
import styles from './Component.module.css';

// File B: styled-components
const Wrapper = styled.div`...`;

// File C: Tailwind
className="flex items-center"

// File D: inline styles
style={{ display: 'flex' }}

// Standardize: one primary styling approach per project
```

### Vue-Specific
```vue
// Mixed API styles:
// File A: Composition API
<script setup>
const count = ref(0)
</script>

// File B: Options API
<script>
export default {
  data() { return { count: 0 } }
}
</script>

// Standardize: use Composition API (<script setup>) consistently
```

### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx,.vue  -- no new errors
npx tsc --noEmit                           -- no type errors
npx jest --passWithNoTests                 -- all tests pass
```

---

## Step 6: Apply Fixes

For each inconsistency category:
1. Determine the **dominant pattern** in the codebase (>60% usage)
2. Standardize all files to the dominant pattern
3. If no dominant pattern exists, follow the language's official style guide:
   - Dart: Effective Dart
   - TypeScript/JS: ESLint recommended
   - Kotlin: Kotlin coding conventions
   - Python: PEP 8
   - Go: Effective Go
   - Rust: Rust API Guidelines
   - React/Vue/Angular: Official framework style guides
4. Make a single commit with all pattern standardizations

## Output Format

```markdown
## Inconsistent Patterns Audit

### Summary
- **Pattern categories checked**: [count]
- **Inconsistencies found**: [count]
- **Files modified**: [count]

### Naming Convention Fixes

| File | Before | After | Rule |
|------|--------|-------|------|
| lib/utils/api_helper.dart | fetch_data() | fetchData() | lowerCamelCase |

### Async Pattern Standardization

| File | Before | After |
|------|--------|-------|
| lib/services/auth.dart:45 | .then().catchError() | async/await + try/catch |

### Import Style Fixes

| File | Issue | Fix |
|------|-------|-----|
| lib/views/home.dart | Mixed relative and package imports | Standardized to relative |

### Error Handling Standardization

| File | Before | After |
|------|--------|-------|
| lib/services/api.dart:23 | print(error) | debugPrint(error) |

### Python Pattern Fixes

| File | Before | After | Rule |
|------|--------|-------|------|
| app/services/user.py | getUserData() | get_user_data() | PEP 8 snake_case |
| app/routes/auth.py | sync def login() | async def login() | Consistent async in FastAPI |
| app/models/user.py | no type hints | full type hints | Type hint consistency |

### Go Pattern Fixes

| File | Before | After | Rule |
|------|--------|-------|------|
| internal/handlers/user.go | return err (raw) | return fmt.Errorf("get user: %w", err) | Error wrapping consistency |
| internal/service/order.go | func (this *OrderSvc) | func (s *OrderSvc) | Receiver naming |
| internal/handlers/product.go | GetProduct(id int) | GetProduct(ctx context.Context, id int) | Context-first pattern |

### Rust Pattern Fixes

| File | Before | After | Rule |
|------|--------|-------|------|
| src/services/auth.rs | .unwrap() | ? operator | Result-based error handling |
| src/handlers/user.rs | fn process(user: User) | fn process(user: &User) | Borrow by default |
| src/models/order.rs | #[allow(non_snake_case)] | renamed to snake_case | Naming conventions |

### Web Pattern Fixes

| File | Before | After | Rule |
|------|--------|-------|------|
| src/components/Header.tsx | Options API | Composition API `<script setup>` | Vue API consistency |
| src/pages/Dashboard.tsx | useState + Redux | Redux only (shared state) | State management consistency |
| src/components/Card.tsx | inline styles | CSS Modules | Styling approach consistency |
```
