#!/usr/bin/env bash
# ─── Go ─────────────────────────────────────────────────────

FRAMEWORK_NAME="Go"
FRAMEWORK_PREFIXES=("go_")
FRAMEWORK_DETECT_FILE="go.mod"
FRAMEWORK_EXTENSIONS=(".go")

FRAMEWORK_INSTALL_CMD="go mod download"
FRAMEWORK_LINT_CMD="go vet ./..."
FRAMEWORK_TEST_CMD="go test ./..."
FRAMEWORK_FORMAT_CMD="gofmt -w ."
FRAMEWORK_CLEAN_CMD="go clean -cache"

ci_setup() {
  echo "uses: actions/setup-go@v5"
  echo "with:"
  echo "  go-version: '1.22'"
  echo "  cache: true"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  mkdir -p "$target"

  cat > "$target/go.mod" << MOD
module github.com/example/${name}

go 1.22
MOD

  cat > "$target/main.go" << 'GO'
package main

import "fmt"

func main() {
	fmt.Println("Hello from ${name}")
}
GO

  mkdir -p "$target/${name}_test"
}
