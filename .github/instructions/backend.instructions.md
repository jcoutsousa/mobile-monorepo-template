---
applyTo: '**/backends/**/*.{py,go,rs,ts,js}'
---

# Backend Service Code Review Rules

## General Backend Standards
- All endpoints must have input validation
- Use structured logging (JSON format for production)
- Return consistent error response shapes
- Set appropriate HTTP status codes
- Include health check endpoints (`/health`, `/ready`)

## Python (FastAPI / Django)
- Use type hints for all function signatures
- Use Pydantic models for request/response validation
- Use async/await for I/O-bound operations
- Follow PEP 8 style guide (enforced by ruff)
- Use dependency injection for services and database sessions
- Never commit secrets — use environment variables

## Node.js (Express / Fastify)
- Use TypeScript for type safety
- Validate inputs with zod, joi, or similar
- Use async error handling middleware
- Follow ESLint and Prettier configurations
- Structure with routes/controllers/services pattern

## Go
- Follow Effective Go conventions
- Use `context.Context` for cancellation and timeouts
- Return errors, don't panic
- Use interfaces for dependency injection and testing
- Keep packages small and focused

## Rust
- Use `Result<T, E>` for error handling, not `unwrap()`/`expect()` in production
- Use `clippy` with `-D warnings` for lint enforcement
- Prefer owned types in public APIs, references internally
- Use `serde` for serialization/deserialization
- Keep `unsafe` blocks minimal and well-documented

## Docker
- Use multi-stage builds to minimize image size
- Run as non-root user
- Pin base image versions (not `latest`)
- Include `.dockerignore` to exclude unnecessary files
- Expose only the necessary port

## Security
- Validate and sanitize all user inputs
- Use parameterized queries (never string concatenation for SQL)
- Implement rate limiting
- Set CORS policies explicitly
- Use HTTPS in production
- Never log sensitive data (passwords, tokens, PII)
