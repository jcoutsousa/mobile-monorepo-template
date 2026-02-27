---
applyTo: "**/*.kt,**/*.kts,**/kotlin_*/**"
---

# Kotlin / Kotlin Multiplatform Code Review Rules

## Kotlin Conventions
- Follow official Kotlin coding conventions.
- Use `val` over `var` wherever possible.
- Prefer data classes for model/DTO objects.
- Use sealed classes/interfaces for representing restricted hierarchies.
- Avoid nullable types unless the domain requires it.

## Architecture
- Follow Clean Architecture or MVVM pattern as established in the project.
- Separate platform-specific code from shared business logic.
- Use `expect`/`actual` declarations for platform-specific implementations in KMP.
- Keep shared module dependencies minimal — only `kotlinx` libraries and other KMP-compatible dependencies.

## Coroutines
- Use `viewModelScope` or `lifecycleScope` for coroutine launches.
- Handle `CancellationException` properly (do not catch and suppress).
- Use `Flow` for reactive streams, not callbacks.
- Prefer `StateFlow`/`SharedFlow` over `LiveData` for new code.
- Always specify dispatchers explicitly for IO operations.

## Compose (Jetpack/Multiplatform)
- Keep composable functions focused and small.
- Use `remember` and `derivedStateOf` to avoid unnecessary recompositions.
- Follow the state hoisting pattern — composables should receive state, not create it.
- Use `LazyColumn`/`LazyRow` for lists, never `Column` with `forEach`.

## Testing
- Use JUnit 5 for unit tests.
- Use `kotlinx-coroutines-test` for testing coroutines.
- Use MockK or Mockito-Kotlin for mocking.
- Test ViewModels independently from the UI layer.

## Build
- Code must pass `./gradlew detekt` with zero issues.
- Code must compile with zero warnings (`-Werror` where configured).
