---
applyTo: "**/flutter_*/**,**/lib/**/*.dart,**/test/**/*.dart,**/*.dart"
---

# Flutter Code Review Rules

## Dart/Flutter Conventions
- Use `const` constructors wherever possible.
- Prefer `final` over `var` for variables that are not reassigned.
- Use named parameters for functions with more than 2 parameters.
- Follow effective Dart style: `lowerCamelCase` for variables/functions, `UpperCamelCase` for classes/enums.

## Widget Structure
- Keep `build()` methods under 100 lines. Extract sub-widgets for complex UIs.
- Use `const` widgets to prevent unnecessary rebuilds.
- Avoid logic in `build()` — move to ViewModel/Bloc/Provider.
- Prefer `StatelessWidget` unless local mutable state is required.

## State Management
- Follow the project's state management pattern (Provider, Riverpod, Bloc, etc.).
- Do not mix state management approaches within the same feature.
- Dispose controllers and subscriptions in `dispose()`.
- Use `ValueNotifier`/`ChangeNotifier` for simple state, Bloc/Riverpod for complex state.

## Performance
- Use `ListView.builder` for long lists, never `ListView` with `children` for large datasets.
- Avoid `setState()` in large widget trees — prefer granular rebuilds.
- Use `RepaintBoundary` for expensive painting operations.
- Cache network images with `CachedNetworkImage` or similar.

## Testing
- Widget tests must use `pumpWidget` and `pumpAndSettle`.
- Mock dependencies using `mockito` or `mocktail`.
- Test edge cases: empty states, error states, loading states.
- Integration tests should use `integration_test` package.

## Analysis
- Code must pass `flutter analyze` with zero issues.
- Follow all rules in `analysis_options.yaml`.
