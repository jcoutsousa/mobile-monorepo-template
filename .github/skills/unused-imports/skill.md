---
name: unused-imports
description: >
  Detects and removes unused imports across multi-language mobile codebases.
  Supports Flutter/Dart (direct, transitive, show/hide, part/part-of),
  React Native/TypeScript (ES modules, named/default, type-only),
  and Kotlin/Android (wildcard, static, aliased imports).
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

### Kept (uncertain)

| File | Language | Import | Reason Kept |
|------|----------|--------|-------------|
| lib/path/file.dart | Dart | package:freezed_annotation | May be needed for code generation |
| src/utils/index.ts | TypeScript | import './polyfill' | Side-effect import |
| ui/Theme.kt | Kotlin | import com.example.ext.* | Wildcard with possible implicit usage |
```
