---
applyTo: "**/*"
---

# Security Review Rules (All Languages)

## Secrets & Credentials
- **BLOCKING**: Flag any hardcoded API keys, tokens, passwords, or secrets.
- **BLOCKING**: Flag any `.env` files, credential files, or key files being committed.
- Ensure secrets are loaded from environment variables or secure storage (Keychain/Keystore).
- Check that `.gitignore` excludes sensitive files.

## Network Security
- All network requests must use HTTPS. Flag any `http://` URLs.
- Verify that SSL/TLS certificate validation is not disabled.
- Check that certificate pinning is configured for sensitive endpoints.
- Ensure API base URLs are configurable per environment, not hardcoded.

## Data Storage
- Sensitive data must use encrypted storage (Keychain, Keystore, EncryptedSharedPreferences).
- Flag any sensitive data stored in plain text (SharedPreferences, AsyncStorage, UserDefaults).
- Ensure PII is not logged or printed to console.
- Verify that cache/temp files containing sensitive data are cleaned up.

## Input Validation
- All user input must be validated and sanitized.
- Check for proper encoding when displaying user-generated content.
- Verify that deep link parameters are validated before use.
- Ensure WebView content is properly sandboxed.

## Authentication & Authorization
- Verify that auth tokens are refreshed before expiry.
- Check that logout properly clears all cached credentials and tokens.
- Ensure biometric authentication fallback is properly configured.
- Flag any direct comparison of sensitive values (use constant-time comparison).

## Dependencies
- Flag dependencies with known vulnerabilities.
- Verify that dependency versions are pinned (no `^` or `~` for critical packages).
- Check that lock files (pubspec.lock, yarn.lock, package-lock.json) are committed.

## GDPR & Privacy
- Verify that user consent is collected before any data collection.
- Check that data deletion endpoints/flows are implemented.
- Ensure analytics/crash reporting respects user consent preferences.
- Verify that privacy policy links are present and accessible.
