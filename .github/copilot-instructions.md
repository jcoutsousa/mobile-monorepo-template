# Copilot Review Instructions — Mobile Monorepo

You are reviewing code in a mobile monorepo that may contain Flutter, React Native, Kotlin Multiplatform, or Swift projects.

## General Rules

- All PRs must pass CI before merge. Do NOT approve PRs with failing checks.
- Flag any hardcoded secrets, API keys, tokens, or credentials. This is a **blocking** finding.
- Flag any `// TODO`, `// FIXME`, or `// HACK` comments that should be resolved before merge.
- Ensure new code follows the existing patterns and conventions in the project.
- Check that imports are organized and unused imports are removed.

## Code Quality

- Flag duplicated logic across files. Suggest extracting shared utilities.
- Flag functions longer than 50 lines. Suggest decomposition.
- Flag deeply nested code (>3 levels). Suggest early returns or extraction.
- Flag hardcoded values (colors, URLs, strings) that should be constants.
- Ensure error handling is present for all async operations.
- Check that state management follows the project's established pattern.

## Architecture

- Verify separation of concerns: UI, business logic, and data layers must be separate.
- Flag direct API calls from UI components. Business logic belongs in services/repositories.
- Ensure new files are placed in the correct directory following the monorepo structure.
- Check that shared code goes in `packages/`, not duplicated across `apps/`.

## Security

- Flag any use of `http://` URLs (must use `https://`).
- Check that user input is validated and sanitized.
- Ensure sensitive data is not logged or printed to console in production code.
- Verify that authentication tokens are stored securely (Keychain/Keystore, not SharedPreferences/AsyncStorage).
- Flag any disabled SSL certificate validation.

## Testing

- New features must include tests. Flag PRs that add functionality without test coverage.
- Flag test files that contain `skip`, `xdescribe`, `xit`, or `@Skip` annotations.
- Ensure mocks are properly typed and not using `any` or dynamic types.

## Performance

- Flag unnecessary widget rebuilds (Flutter) or re-renders (React Native).
- Check for proper use of `const` constructors (Flutter) or `React.memo` (React Native).
- Flag large images or assets committed without optimization.
- Ensure lists use lazy loading / virtualization for large datasets.

## Accessibility

- Verify that interactive elements have semantic labels.
- Check color contrast ratios for text elements.
- Ensure touch targets meet minimum size requirements (48x48 dp/pt).
