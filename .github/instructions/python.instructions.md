---
applyTo: "**/*.py"
---

# Python Code Review Instructions

## Conventions
- Follow PEP 8 and PEP 257 conventions
- Use type hints for all function signatures
- Prefer `pathlib.Path` over `os.path`
- Use f-strings over `.format()` or `%`
- Use `dataclasses` or `pydantic` for data containers

## Architecture
- Separate business logic from I/O (clean architecture)
- Use dependency injection over global state
- Keep modules focused — one responsibility per module
- Use `__all__` to define public API of modules

## Performance
- Use generators for large sequences
- Prefer `collections.defaultdict` over manual dict checks
- Use `functools.lru_cache` for expensive pure functions
- Avoid mutable default arguments (`def f(x=[])` is a bug)

## Error Handling
- Use specific exception types, never bare `except:`
- Use context managers (`with`) for resource management
- Log exceptions with `logger.exception()` to preserve tracebacks

## Testing
- Use `pytest` conventions (functions, not classes)
- Use `pytest.fixture` for shared setup
- Use `pytest.mark.parametrize` for data-driven tests
- Aim for >80% coverage on business logic

## Linting
- Must pass `ruff check .` with zero errors
- Must pass `ruff format --check .`
- No `# type: ignore` without explanation comment
