---
applyTo: '**/web/**/*.{ts,tsx,js,jsx,vue,svelte}'
---

# Web Application Code Review Rules

## General Web Standards
- Use semantic HTML elements (`<nav>`, `<main>`, `<article>`, etc.)
- Ensure WCAG 2.1 AA accessibility compliance
- Follow responsive design principles (mobile-first)
- Use CSS modules, CSS-in-JS, or scoped styles — avoid global CSS leaks

## React
- Use functional components with hooks (no class components)
- Memoize expensive computations with `useMemo` and `useCallback`
- Avoid prop drilling — use context or state management
- Lazy-load routes and heavy components with `React.lazy` and `Suspense`

## Vue
- Use Composition API (`<script setup>`) over Options API
- Use `defineProps` and `defineEmits` for component contracts
- Keep components small and single-responsibility
- Use `computed` for derived state, avoid watchers when possible

## TypeScript
- Enable strict mode in `tsconfig.json`
- No `any` types — use proper typing or `unknown`
- Define interfaces for all props, API responses, and state shapes
- Use discriminated unions for complex state

## Performance
- Minimize bundle size — check for tree-shaking issues
- Use dynamic imports for code splitting
- Optimize images (WebP, lazy loading, responsive srcset)
- Avoid layout thrashing — batch DOM reads/writes

## Testing
- Write unit tests for utility functions and hooks
- Write component tests with Testing Library
- Test accessibility with `axe-core` or similar
- Test error states and loading states
