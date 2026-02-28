---
applyTo: "**/*.go"
---

# Go Code Review Instructions

## Conventions
- Follow `gofmt` and `go vet` standards
- Use short variable names in small scopes, descriptive in large scopes
- Exported names must have doc comments
- Use `errors.New()` or `fmt.Errorf()` for errors, not string returns

## Architecture
- Accept interfaces, return structs
- Use the standard library when possible
- Keep packages small and focused
- Use dependency injection via constructor functions

## Error Handling
- Always check returned errors — never use `_` for error returns
- Wrap errors with context: `fmt.Errorf("doing X: %w", err)`
- Use sentinel errors (`var ErrNotFound = errors.New(...)`) for expected cases
- Use `errors.Is()` and `errors.As()` for error checking

## Concurrency
- Prefer channels over mutexes for communication
- Use `context.Context` for cancellation and timeouts
- Never start goroutines without a way to stop them
- Use `sync.WaitGroup` or `errgroup` for goroutine lifecycle

## Performance
- Use `strings.Builder` for string concatenation
- Pre-allocate slices with known capacity: `make([]T, 0, n)`
- Use `sync.Pool` for frequently allocated objects
- Profile before optimising (`pprof`)

## Testing
- Use table-driven tests
- Use `testify` or standard library assertions
- Use `t.Parallel()` for independent tests
- Mock external dependencies with interfaces

## Linting
- Must pass `go vet ./...` with zero findings
- Must pass `golangci-lint run` if configured
