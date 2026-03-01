---
name: unused-imports
description: >
  Detects and removes unused imports across multi-language codebases (mobile, web, backend).
  Supports Flutter/Dart (direct, transitive, show/hide, part/part-of),
  React Native/TypeScript (ES modules, named/default, type-only),
  Kotlin/Android (wildcard, static, aliased imports),
  Python (import, from...import), Go (import), Rust (use),
  and web frameworks (React/Vue/Angular imports).
---

# Unused Imports Skill

Remove all unused imports while preserving necessary dependencies. This skill is **language-aware** and applies the correct detection and organization rules per language.

## Language Detection

Before scanning, determine the language of each file:

| File Extension | Language | Import Pattern |
|---------------|----------|----------------|
| `.dart` | Dart | `import '...'`, `export '...'`, `part '...'` |
| `.ts`, `.tsx` | TypeScript | `import ... from '...'`, `import '...'`, `import type ...` |
| `.js`, `.jsx` | JavaScript | `import ... from '...'`, `require('...')` |
| `.kt` | Kotlin | `import ...` |
| `.java` | Java | `import ...` |
| `.py` | Python | `import ...`, `from ... import ...` |
| `.go` | Go | `import "..."`, `import (...)` |
| `.rs` | Rust | `use ...;` |
| `.vue` | Vue | `import ... from '...'` (inside `<script>`) |
| `.svelte` | Svelte | `import ... from '...'` (inside `<script>`) |

---

## Dart / Flutter

### Step 1: Identify All Import Statements

Search for import patterns in all `.dart` files:

```
^import\s+'
^import\s+"
^export\s+'
```

Categorize each import by type:
- `dart:` -- Dart SDK imports
- `package:` -- Package imports (pub dependencies + project package)
- Relative imports (`../`, `./`)
- `part` / `part of` directives

### Step 2: Analyze Usage

For each import in a file:

1. **Extract imported symbols** -- check for `show` / `hide` directives
2. **Search file body** -- verify at least one symbol from the import is used
3. **Check transitive usage** -- an import may be unused directly but re-exported

**Common false positives to avoid:**
- Imports used only in annotations (`@override`, `@JsonSerializable`)
- Imports used in type parameters (`List<SomeType>`)
- Imports used in `as` prefixes that appear in the file body
- Imports of files containing `extension` methods (may be used implicitly)
- `part` files that rely on the parent's imports
- Imports needed for code generation (build_runner, freezed, json_serializable)

### Step 3: Fix Import Organization

After removing unused imports, organize remaining imports per Dart style guide:

```dart
// 1. dart: imports (alphabetical)
import 'dart:async';
import 'dart:io';

// 2. package: imports (alphabetical)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 3. Relative imports (alphabetical)
import '../models/user.dart';
import '../services/api_client.dart';
```

### Step 4: Validate

Run `dart analyze` or `flutter analyze` and confirm:
- No new "unused import" warnings were introduced
- No new "undefined" errors (import was actually needed)

---

## TypeScript / JavaScript (React Native)

### Step 1: Identify All Import Statements

Search for import patterns in all `.ts`, `.tsx`, `.js`, `.jsx` files:

```
^import\s+.*\s+from\s+['"]
^import\s+['"]
^import\s+type\s+
^const\s+.*=\s*require\(['"]
```

Categorize each import by type:
- **Named imports**: `import { useState, useEffect } from 'react'`
- **Default imports**: `import React from 'react'`
- **Namespace imports**: `import * as utils from './utils'`
- **Side-effect imports**: `import './styles.css'` (always keep these)
- **Type-only imports**: `import type { User } from './types'`
- **Re-exports**: `export { something } from './module'`

### Step 2: Analyze Usage

For each import in a file:

1. **Extract imported symbols** -- named imports, default import name, namespace alias
2. **Search file body** -- verify at least one imported symbol is referenced
3. **Check JSX usage** -- components may be used as `<Component />` not as function calls
4. **Check type usage** -- TypeScript types may only appear in type annotations

**Common false positives to avoid:**
- Side-effect imports (`import './polyfill'`, `import './styles.css'`) -- always keep
- React import in files using JSX (needed for older React versions, check if using automatic JSX transform)
- Imports used only in type positions (`type Props = { user: User }`)
- Imports used in decorators or metadata
- Dynamic imports (`const module = await import('./module')`)
- Imports re-exported from barrel files (`index.ts`)

### Step 3: Fix Import Organization

After removing unused imports, organize remaining imports:

```typescript
// 1. Node/built-in modules
import path from 'path';

// 2. External packages (alphabetical)
import React from 'react';
import { View, Text } from 'react-native';

// 3. Internal aliases (alphabetical)
import { UserService } from '@/services/UserService';

// 4. Relative imports (alphabetical)
import { Header } from '../components/Header';
import { formatDate } from './utils';

// 5. Side-effect imports
import './styles.css';
```

### Step 4: Validate

Run `npx eslint . --ext .ts,.tsx,.js,.jsx` and confirm:
- No new `no-unused-vars` or `@typescript-eslint/no-unused-vars` errors
- No new import resolution errors
- If using `tsc`: `npx tsc --noEmit` passes

---

## Kotlin / Android

### Step 1: Identify All Import Statements

Search for import patterns in all `.kt` files:

```
^import\s+[a-zA-Z]
```

Categorize each import by type:
- **Standard library**: `import kotlin.`, `import java.`
- **Android framework**: `import android.`, `import androidx.`
- **Third-party**: Other package imports
- **Project imports**: Imports matching the project's package name
- **Wildcard imports**: `import com.example.utils.*`
- **Aliased imports**: `import com.example.OldName as NewName`

### Step 2: Analyze Usage

For each import in a file:

1. **Extract imported symbol** -- the class/function/property name (last segment)
2. **Search file body** -- verify the symbol is referenced
3. **Check wildcard imports** -- determine if ANY symbol from the package is used
4. **Check aliased imports** -- search for the alias name, not the original

**Common false positives to avoid:**
- Imports used in annotations (`@Composable`, `@Inject`, `@Module`)
- Imports used in type parameters (`List<SomeType>`)
- Extension function imports (may be used implicitly on receiver types)
- Imports needed for operator overloading
- Imports used in KDoc references (`@see`, `@link`)
- Wildcard imports that provide multiple used symbols

### Step 3: Fix Import Organization

After removing unused imports, organize remaining imports per Kotlin conventions:

```kotlin
// 1. All non-aliased imports (alphabetical)
import android.os.Bundle
import androidx.activity.ComponentActivity
import com.example.myapp.data.UserRepository
import com.example.myapp.ui.theme.AppTheme
import kotlinx.coroutines.launch

// 2. Aliased imports at the end (alphabetical)
import com.example.legacy.User as LegacyUser
```

### Step 4: Validate

Run `./gradlew lint` or `./gradlew ktlintCheck` and confirm:
- No new "unused import" warnings
- No new unresolved reference errors
- `./gradlew compileDebugKotlin` still succeeds

---

## Python

### Step 1: Identify All Import Statements

Search for import patterns in all `.py` files:

```
^import\s+[a-zA-Z]
^from\s+[a-zA-Z._]+\s+import\s+
```

Categorize each import by type:
- **Standard library**: `import os`, `from typing import ...`
- **Third-party**: `import fastapi`, `from pydantic import ...`
- **Local/project**: `from .models import ...`, `from app.services import ...`
- **Conditional imports**: `try: import ... except: ...`
- **Type-checking imports**: `if TYPE_CHECKING: import ...`

### Step 2: Analyze Usage

For each import in a file:

1. **Extract imported symbols** -- check for `from X import Y, Z` or `import X`
2. **Search file body** -- verify at least one imported symbol is used
3. **Check aliased usage** -- `import numpy as np` means search for `np.`

**Common false positives to avoid:**
- Imports inside `if TYPE_CHECKING:` blocks (used only for type annotations)
- `__init__.py` re-exports for public API
- Imports used in decorators (`@app.route`, `@pytest.fixture`)
- Imports used in type hints that are string-quoted (`"SomeType"`)
- Wildcard imports (`from module import *`) -- flag but do not auto-remove
- Imports needed by frameworks (e.g., `alembic` migrations, `celery` tasks)

### Step 3: Fix Import Organization

After removing unused imports, organize per PEP 8 / isort:

```python
# 1. Standard library imports (alphabetical)
import os
import sys
from typing import Optional

# 2. Third-party imports (alphabetical)
from fastapi import FastAPI
from pydantic import BaseModel

# 3. Local/project imports (alphabetical)
from app.models import User
from app.services import AuthService
```

### Step 4: Validate

Run `ruff check .` and confirm:
- No new `F401` (unused import) warnings
- No new `F811` (redefinition) errors
- `pytest` still passes

---

## Go

### Step 1: Identify All Import Statements

Search for import patterns in all `.go` files:

```
^import\s+"
^import\s+\(
```

Categorize each import by type:
- **Standard library**: `"fmt"`, `"net/http"`, `"context"`
- **Third-party**: `"github.com/..."`, `"golang.org/x/..."`
- **Local/project**: Imports matching the module path in `go.mod`
- **Blank identifier imports**: `_ "github.com/lib/pq"` (side-effect imports)
- **Aliased imports**: `mux "github.com/gorilla/mux"`

### Step 2: Analyze Usage

For each import in a file:

1. **Extract package name** -- last segment of the import path (or alias)
2. **Search file body** -- verify `packagename.` appears in the code
3. **Check blank imports** -- `_` imports are side-effect only, always keep

**Common false positives to avoid:**
- Blank identifier imports (`_ "..."`) -- always keep (driver registration, init functions)
- Dot imports (`. "..."`) -- symbols are used without qualification
- Imports used in `//go:generate` directives
- Imports in test files that use testify or other test frameworks

### Step 3: Fix Import Organization

After removing unused imports, organize per `goimports` convention:

```go
import (
    // 1. Standard library (alphabetical)
    "context"
    "fmt"
    "net/http"

    // 2. Third-party (alphabetical)
    "github.com/gorilla/mux"
    "go.uber.org/zap"

    // 3. Local/project (alphabetical)
    "myproject/internal/handlers"
    "myproject/internal/models"
)
```

### Step 4: Validate

Run `go build ./...` and confirm:
- No new "imported and not used" errors (Go compiler enforces this)
- `go vet ./...` passes
- `go test ./...` still passes

---

## Rust

### Step 1: Identify All Import Statements

Search for `use` statements in all `.rs` files:

```
^use\s+[a-zA-Z_]
^pub\s+use\s+
```

Categorize each import by type:
- **Standard library**: `use std::...`
- **External crates**: `use serde::...`, `use tokio::...`
- **Crate-internal**: `use crate::...`
- **Super/self**: `use super::...`, `use self::...`
- **Re-exports**: `pub use ...`

### Step 2: Analyze Usage

For each `use` statement in a file:

1. **Extract imported symbols** -- check for `use X::{Y, Z}` or `use X::Y`
2. **Search file body** -- verify imported symbols are referenced
3. **Check glob imports** -- `use module::*` may import symbols used implicitly

**Common false positives to avoid:**
- `pub use` re-exports for public API
- Trait imports required for method resolution (`use std::io::Read`)
- Derive macro imports (`use serde::{Serialize, Deserialize}`)
- Prelude-style glob imports (`use std::prelude::*`)
- Imports used in macros (`use log::{info, warn, error}`)
- `#[cfg(test)]` imports used only in test modules

### Step 3: Fix Import Organization

After removing unused imports, organize per Rust conventions:

```rust
// 1. Standard library
use std::collections::HashMap;
use std::io::Read;

// 2. External crates (alphabetical)
use serde::{Deserialize, Serialize};
use tokio::sync::Mutex;

// 3. Crate-internal (alphabetical)
use crate::models::User;
use crate::services::auth;
```

### Step 4: Validate

Run `cargo check` and confirm:
- No new `unused_imports` warnings
- `cargo clippy` passes
- `cargo test` still passes

---

## Web Frameworks (React / Vue / Angular)

### Step 1: Identify All Import Statements

For React/Angular `.ts`/`.tsx` files, follow the TypeScript/JavaScript rules above.

For Vue `.vue` files, search within `<script>` or `<script setup>` blocks:

```
import\s+.*\s+from\s+['"]
import\s+['"]
```

For Svelte `.svelte` files, search within `<script>` blocks:

```
import\s+.*\s+from\s+['"]
```

### Step 2: Analyze Usage

Apply the same TypeScript/JavaScript analysis rules, plus:

**Additional false positives to avoid for web:**
- Vue `<script setup>` imports used directly in template (not in `<script>`)
- Svelte component imports used in markup (`<Component />`)
- CSS/SCSS module imports (`import styles from './Component.module.css'`)
- Image/asset imports (`import logo from './logo.svg'`)
- Vue composables imported and used via `v-model` or template refs
- Angular decorator metadata imports (`@Component`, `@Injectable`)

### Step 3: Validate

- **React**: `npx eslint . && npx tsc --noEmit`
- **Vue**: `npx vue-tsc --noEmit` or `npx eslint .`
- **Angular**: `npx ng lint` or `npx eslint .`

---

## Verification Before Removing (All Languages)

For each candidate unused import across ANY language:

1. Search the **entire file** (not just the import section) for any reference to the imported symbol
2. Check if the import provides extension methods/functions used implicitly
3. Check if the import is needed for code generation or annotation processing
4. If uncertain, **keep the import** -- false negatives are safer than false positives

## Output Format

```markdown
## Unused Imports Audit

### Summary
- **Apps scanned**: [count]
- **Languages detected**: [list]
- **Files scanned**: [count per language]
- **Unused imports found**: [count per language]
- **Files modified**: [count per language]

### Dart / Flutter -- [app name]

| File | Removed Import | Reason |
|------|---------------|--------|
| lib/path/file.dart | package:http/http.dart | No symbols referenced |

### TypeScript / React Native -- [app name]

| File | Removed Import | Reason |
|------|---------------|--------|
| src/screens/Home.tsx | import { unused } from './utils' | Symbol never referenced |

### Kotlin / Android -- [app name]

| File | Removed Import | Reason |
|------|---------------|--------|
| src/main/kotlin/ui/MainActivity.kt | import android.util.Log | No Log calls in file |

### Python -- [service name]

| File | Removed Import | Reason |
|------|---------------|--------|
| app/services/cache.py | from typing import Set | Type never used |

### Go -- [service name]

| File | Removed Import | Reason |
|------|---------------|--------|
| internal/handlers/user.go | "encoding/xml" | No XML operations in file |

### Rust -- [service name]

| File | Removed Import | Reason |
|------|---------------|--------|
| src/handlers/auth.rs | use std::collections::BTreeMap | BTreeMap never referenced |

### Web (React/Vue/Angular) -- [app name]

| File | Removed Import | Reason |
|------|---------------|--------|
| src/components/Dashboard.tsx | import { useOldHook } from '../hooks' | Hook never called |

### Kept (uncertain)

| File | Language | Import | Reason Kept |
|------|----------|--------|-------------|
| lib/path/file.dart | Dart | package:freezed_annotation | May be needed for code generation |
| src/utils/index.ts | TypeScript | import './polyfill' | Side-effect import |
| ui/Theme.kt | Kotlin | import com.example.ext.* | Wildcard with possible implicit usage |
| app/db/session.py | Python | from sqlalchemy import event | May be needed for event registration |
| internal/db/driver.go | Go | _ "github.com/lib/pq" | Blank identifier side-effect import |
| src/lib.rs | Rust | pub use crate::models | Public re-export for API |
```
