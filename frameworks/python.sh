#!/usr/bin/env bash
# ─── Python ─────────────────────────────────────────────────

FRAMEWORK_NAME="Python"
FRAMEWORK_PREFIXES=("py_" "python_")
FRAMEWORK_DETECT_FILE="pyproject.toml"
FRAMEWORK_EXTENSIONS=(".py")

FRAMEWORK_INSTALL_CMD="pip install -e '.[dev]'"
FRAMEWORK_LINT_CMD="ruff check ."
FRAMEWORK_TEST_CMD="pytest"
FRAMEWORK_FORMAT_CMD="ruff format ."
FRAMEWORK_CLEAN_CMD="rm -rf __pycache__ .pytest_cache dist *.egg-info"

ci_setup() {
  echo "uses: actions/setup-python@v5"
  echo "with:"
  echo "  python-version: '3.12'"
  echo "  cache: pip"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  mkdir -p "$target/src/${name}" "$target/tests"

  cat > "$target/pyproject.toml" << TOML
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "${name}"
version = "0.1.0"
requires-python = ">=3.11"

[project.optional-dependencies]
dev = ["pytest", "ruff"]

[tool.ruff]
target-version = "py311"
line-length = 120

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

  cat > "$target/src/${name}/__init__.py" << 'PY'
"""${name} package."""
PY

  cat > "$target/tests/__init__.py" << 'PY'
PY
}
