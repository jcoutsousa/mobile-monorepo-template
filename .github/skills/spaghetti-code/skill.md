---
name: spaghetti-code
description: >
  Detects and refactors spaghetti code including overly long functions, deeply
  nested widget trees / component trees, mixed business/UI logic, excessive coupling,
  and god classes/modules. Supports Flutter/Dart, React Native/TypeScript,
  Kotlin/Android, Python, Go, Rust, and web frameworks (React/Vue/Angular).
  Improves code structure and maintainability.
---

# Spaghetti Code Skill

Detect and refactor structural code issues that harm maintainability and readability. This skill is **language-aware** and applies appropriate detection strategies per language.

## Step 1: Function Length Analysis

### Find Long Functions (>50 lines)

Scan all source files for functions and methods exceeding 50 lines of code (excluding comments and blank lines).

**Thresholds:**
| Length | Severity | Action |
|--------|----------|--------|
| >100 lines | Critical | Must refactor |
| 50-100 lines | Warning | Should refactor |
| 30-50 lines | Info | Review for clarity |

### Refactoring Strategy for Long Functions

1. **Identify logical sections** — look for comment blocks or blank lines that separate concerns
2. **Extract methods** — each logical section becomes a named method
3. **Name methods descriptively** — the name should explain WHAT, not HOW
4. **Preserve the original method** as a high-level orchestrator

```dart
// Before: 120-line _handleSubmit method
void _handleSubmit() {
  // validation (20 lines)
  // ...
  // API call (30 lines)
  // ...
  // state update (25 lines)
  // ...
  // navigation (15 lines)
  // ...
}

// After: orchestrator + focused methods
void _handleSubmit() {
  if (!_validateForm()) return;
  final result = await _submitToApi();
  _updateState(result);
  _navigateToConfirmation();
}
```

## Step 2: Widget Build Method Analysis

### Find Long Build Methods (>100 lines)

Widget `build()` methods over 100 lines should be broken into smaller widgets.

**Search pattern:**
```
Widget build\(BuildContext context\)
```

### Refactoring Strategy for Long Build Methods

1. **Extract widget subtrees** into private widget methods or separate widget classes
2. **Prefer separate widget classes** over private methods (better performance with const)
3. **Name extracted widgets** by their purpose, not their structure

```dart
// Before: 150-line build method with nested Column > ListView > Cards

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

## Step 3: Nesting Depth Analysis

### Find Deep Nesting (>3 levels of indentation in logic, >5 in widgets)

**Logic nesting (if/for/while):**
```dart
// Bad: >3 levels
if (condition1) {
  if (condition2) {
    for (var item in items) {
      if (condition3) {
        // 4 levels deep — too much
      }
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

**Widget nesting:**
```dart
// Bad: >5 levels of widget nesting without extraction
Scaffold(
  body: SafeArea(
    child: Padding(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: // 7 levels deep
                )
              ]
            )
          )
        ]
      )
    )
  )
)
```

## Step 4: Mixed Concerns Analysis

### Business Logic in UI Code

Search for these anti-patterns in widget files:

```dart
// API calls directly in widgets
http.get(
await apiClient.
await repository.

// Data transformation in build methods
items.where(
items.map(
items.sort(

// Complex calculations in widgets
if (price * quantity * tax > threshold) {

// State mutations in build methods (outside of callbacks)
setState(() {
  // complex logic here
});
```

**Fix:** Move business logic to ViewModel, Controller, or Service classes.

### UI Logic in Business Classes

Search for these in service/viewmodel/repository files:

```dart
// UI framework imports in non-UI files
import 'package:flutter/material.dart';  // in a service file
import 'package:flutter/widgets.dart';   // in a repository file

// Navigation in business logic
Navigator.of(context)

// Scaffold/SnackBar in business logic
ScaffoldMessenger

// BuildContext in service methods
void doSomething(BuildContext context)
```

**Fix:** Return data/state, let the UI layer handle presentation.

## Step 5: God Class Detection

### Find Classes with Too Many Responsibilities

**Indicators:**
- Class has >500 lines
- Class has >15 public methods
- Class imports from >10 different files
- Class name is vague (`Manager`, `Helper`, `Utils`, `Handler`)

**Fix:** Split into focused classes following Single Responsibility Principle.

## Step 6: Excessive Coupling Detection

### Find Tight Coupling

```dart
// Direct instantiation of dependencies (instead of injection)
final service = ApiService();  // in a widget

// Long method chains
widget.parent.context.service.repository.method()

// Circular dependencies
// file_a.dart imports file_b.dart AND file_b.dart imports file_a.dart
```

## Python-Specific Patterns

### God Functions
```python
# Functions doing too much -- multiple responsibilities
def process_request(request):
    # validation (20 lines)
    # database query (15 lines)
    # business logic (30 lines)
    # response formatting (20 lines)
    # logging (10 lines)
```

**Fix:** Split into focused functions. Use service classes or utility modules.

### Deep Nesting
```python
# Bad: >3 levels of nesting
if condition1:
    for item in items:
        if condition2:
            for sub in item.children:
                if condition3:  # 4+ levels

# Fix: early returns, guard clauses, extract functions
if not condition1:
    return
for item in items:
    _process_item(item)
```

### Mixed Concerns in FastAPI/Django
```python
# Bad: database queries directly in route handlers
@app.get("/users/{user_id}")
async def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    # ... 50 lines of business logic ...
    return user

# Fix: Use service layer
@app.get("/users/{user_id}")
async def get_user(user_id: int, service: UserService = Depends()):
    return await service.get_user(user_id)
```

### Validation
```
ruff check .   -- no new errors
pytest         -- all tests pass
```

---

## Go-Specific Patterns

### Massive Functions
```go
// Functions exceeding 50 lines -- often handler functions
func handleCreateUser(w http.ResponseWriter, r *http.Request) {
    // request parsing (15 lines)
    // validation (20 lines)
    // database operations (25 lines)
    // response writing (10 lines)
}
```

**Fix:** Extract into handler + service + repository pattern.

### Deep Nesting
```go
// Bad: >3 levels
if err == nil {
    for _, item := range items {
        if item.Valid {
            for _, sub := range item.Children {
                // 4+ levels
            }
        }
    }
}

// Fix: early returns, extract functions
if err != nil {
    return err
}
for _, item := range items {
    if !item.Valid {
        continue
    }
    processChildren(item.Children)
}
```

### God Packages
A Go package is a "god package" if:
- It has >20 files
- It imports >15 other packages
- It has a vague name (`utils`, `helpers`, `common`)

**Fix:** Split into focused packages by domain.

### Validation
```
go build ./...    -- compiles
go vet ./...      -- no new issues
go test ./...     -- all tests pass
```

---

## Rust-Specific Patterns

### Complex Match Chains
```rust
// Bad: deeply nested match/if-let chains
match result {
    Ok(value) => match value.kind {
        Kind::A => match value.subkind {
            SubKind::X => {
                // deeply nested logic
            }
            _ => { ... }
        }
        _ => { ... }
    }
    Err(e) => { ... }
}

// Fix: extract into functions, use early returns with ?
fn process(result: Result<Value, Error>) -> Result<Output, Error> {
    let value = result?;
    match value.kind {
        Kind::A => process_kind_a(value),
        _ => process_default(value),
    }
}
```

### Large impl Blocks
An `impl` block is too large if:
- It has >500 lines
- It has >15 methods
- Methods have mixed concerns (IO + business logic + formatting)

**Fix:** Split into trait implementations, use composition, extract modules.

### Excessive Unsafe Blocks
```rust
// Flag files with >3 unsafe blocks or unsafe blocks >10 lines
unsafe { ... }
```

**Fix:** Encapsulate unsafe code in safe abstractions.

### Validation
```
cargo check                     -- compiles
cargo clippy -- -D warnings     -- no new warnings
cargo test                      -- all tests pass
```

---

## Web-Specific Patterns (React / Vue / Angular)

### Prop Drilling
```tsx
// Bad: passing props through 3+ levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserMenu user={user} />
    </Sidebar>
  </Layout>
</App>

// Fix: Use context (React), provide/inject (Vue), or services (Angular)
```

### Deeply Nested Components
```tsx
// Bad: >5 levels of component nesting in a single file
<PageLayout>
  <ContentArea>
    <Section>
      <Card>
        <CardBody>
          <List>
            <ListItem>  // 7 levels deep

// Fix: Extract intermediate components
<PageLayout>
  <ContentArea>
    <UserSection />  // Encapsulates Card > CardBody > List > ListItem
  </ContentArea>
</PageLayout>
```

### Mixed Data Fetching and Rendering
```tsx
// Bad: fetch + transform + render in one component
function UserDashboard() {
  const [data, setData] = useState(null);
  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(data => {
        // 20 lines of data transformation
        setData(transformedData);
      });
  }, []);
  // 100 lines of JSX
}

// Fix: Custom hook for data, separate presentation component
function UserDashboard() {
  const { data, isLoading } = useUserDashboard();
  return <DashboardView data={data} isLoading={isLoading} />;
}
```

### Massive Component Files
A component file is too large if:
- It exceeds 300 lines
- It has >5 hooks/composables
- It renders >100 lines of JSX/template

**Fix:** Split into container/presentational components, extract hooks.

### Validation
```
npx eslint . --ext .ts,.tsx,.js,.jsx,.vue  -- no new errors
npx tsc --noEmit                           -- no type errors
npx jest --passWithNoTests                 -- all tests pass
```

---

## Step 7: Apply Fixes

Priority order:
1. **Critical**: Functions >100 lines, build methods >150 lines, massive components >300 lines
2. **High**: Mixed concerns (business logic in UI, prop drilling)
3. **Medium**: Deep nesting, god classes/packages, complex match chains
4. **Low**: Minor coupling issues

## Output Format

```markdown
## Spaghetti Code Audit

### Summary
- **Long functions found**: [count] (>[50 lines])
- **Long build methods found**: [count] (>[100 lines])
- **Deep nesting found**: [count] (>[3 levels])
- **Mixed concerns found**: [count]
- **God classes found**: [count]

### Refactored Functions

| File | Method | Before | After | Extraction |
|------|--------|--------|-------|------------|
| lib/views/settings.dart | build() | 180 lines | 45 lines | 4 sub-widgets |
| lib/services/auth.dart | login() | 85 lines | 30 lines | 3 helper methods |

### Mixed Concerns Fixed

| File | Issue | Fix |
|------|-------|-----|
| lib/views/home.dart:45 | API call in build() | Moved to ViewModel |
| lib/services/api.dart:23 | Navigator in service | Returns result, UI navigates |

### Nesting Reduced

| File | Method | Before | After | Technique |
|------|--------|--------|-------|-----------|
| lib/utils/parser.dart:67 | parse() | 5 levels | 2 levels | Early returns |

### Python Refactoring

| File | Function | Before | After | Technique |
|------|----------|--------|-------|-----------|
| app/services/order.py | process_order() | 95 lines | 25 lines | Extract service methods |
| app/routes/users.py | get_users() | 60 lines | 15 lines | Move logic to service layer |

### Go Refactoring

| File | Function | Before | After | Technique |
|------|----------|--------|-------|-----------|
| internal/handlers/user.go | HandleCreate() | 80 lines | 20 lines | Extract to service |
| internal/utils/parser.go | Parse() | 4 levels nesting | 2 levels | Guard clauses |

### Rust Refactoring

| File | Function | Before | After | Technique |
|------|----------|--------|-------|-----------|
| src/handlers/auth.rs | authenticate() | 70 lines | 25 lines | Extract + ? operator |
| src/services/order.rs | process() | 5-deep match | 2-deep match | Extract match arms |

### Web Refactoring

| File | Component | Before | After | Technique |
|------|-----------|--------|-------|-----------|
| src/pages/Dashboard.tsx | Dashboard | 280 lines | 60 lines | Extract sub-components + hook |
| src/components/UserList.vue | UserList | 6 levels prop drilling | 2 levels | provide/inject |
```
