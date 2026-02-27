---
applyTo: "**/*.tsx,**/*.ts,**/*.jsx,**/*.js,**/react_native_*/**"
excludeAgent: "coding-agent"
---

# React Native Code Review Rules

## TypeScript/React Conventions
- All new files must use TypeScript (`.tsx`/`.ts`), not JavaScript.
- Define explicit types for props, state, and function parameters.
- Avoid `any` type — use `unknown` or proper type definitions.
- Use functional components with hooks, not class components.

## Component Structure
- Keep components under 200 lines. Extract sub-components for complex UIs.
- Use `React.memo` for expensive pure components.
- Separate presentational and container components.
- Use custom hooks to extract reusable logic from components.

## State Management
- Follow the project's state management pattern (Redux, Zustand, Context, etc.).
- Do not mix state management approaches within the same feature.
- Clean up subscriptions and event listeners in `useEffect` cleanup functions.
- Avoid prop drilling — use context or state management for deeply nested data.

## Performance
- Use `FlatList` or `FlashList` for long lists, never `ScrollView` with `.map()`.
- Memoize expensive computations with `useMemo`.
- Memoize callback functions with `useCallback` when passed as props.
- Avoid inline styles — use `StyleSheet.create` for static styles.
- Use `React.lazy` and `Suspense` for code splitting.

## Navigation
- Follow the project's navigation pattern (React Navigation, Expo Router, etc.).
- Type all navigation params using TypeScript.
- Handle deep linking configuration properly.

## Testing
- Use React Native Testing Library for component tests.
- Test user interactions, not implementation details.
- Mock native modules properly.
- Ensure tests run on CI without native dependencies.

## Linting
- Code must pass ESLint with zero errors.
- Code must pass TypeScript compiler with `strict: true`.
