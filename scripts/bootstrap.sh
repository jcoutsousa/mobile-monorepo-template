#!/usr/bin/env bash
set -euo pipefail

# ─── Monorepo Bootstrap Script ─────────────────────────────
# Plugin-based — auto-discovers available frameworks from
# the frameworks/ directory. Add a new .sh file there to
# support a new language/framework.
#
# Usage:
#   ./scripts/bootstrap.sh <framework> <name> [--package]
#   ./scripts/bootstrap.sh --list
#
# Examples:
#   ./scripts/bootstrap.sh flutter myapp
#   ./scripts/bootstrap.sh python ml-service
#   ./scripts/bootstrap.sh go api-gateway
#   ./scripts/bootstrap.sh react-native utils --package
#   ./scripts/bootstrap.sh --list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FRAMEWORKS_DIR="$REPO_ROOT/frameworks"

# ─── Helpers ────────────────────────────────────────────────

list_frameworks() {
  local found=0
  for f in "$FRAMEWORKS_DIR"/*.sh; do
    [ ! -f "$f" ] && continue
    local base
    base="$(basename "$f" .sh)"
    [ "$base" = "_template" ] && continue

    # Source to get FRAMEWORK_NAME
    local FRAMEWORK_NAME=""
    # shellcheck disable=SC1090
    source "$f"
    printf "  %-20s %s\n" "$base" "$FRAMEWORK_NAME"
    found=1
  done
  if [ "$found" -eq 0 ]; then
    echo "  (none — add .sh files to frameworks/)"
  fi
}

resolve_framework() {
  local input="$1"

  # Direct match
  if [ -f "$FRAMEWORKS_DIR/${input}.sh" ]; then
    echo "${input}.sh"
    return
  fi

  # Alias match (e.g. "rn" → "react-native", "kmp" → "kotlin")
  for f in "$FRAMEWORKS_DIR"/*.sh; do
    [ ! -f "$f" ] && continue
    local base
    base="$(basename "$f" .sh)"
    [ "$base" = "_template" ] && continue

    local FRAMEWORK_PREFIXES=()
    # shellcheck disable=SC1090
    source "$f"
    for prefix in "${FRAMEWORK_PREFIXES[@]}"; do
      # Strip trailing underscore to get alias
      local alias="${prefix%_}"
      if [ "$input" = "$alias" ]; then
        echo "$base.sh"
        return
      fi
    done
  done

  return 1
}

usage() {
  echo "Usage: $0 <framework> <name> [--package]"
  echo "       $0 --list"
  echo ""
  echo "Available frameworks:"
  list_frameworks
  echo ""
  echo "Options:"
  echo "  --package    Create a shared package in packages/ instead of apps/"
  echo "  --list       List all available frameworks"
  echo ""
  echo "To add a new framework, copy frameworks/_template.sh"
}

# ─── Parse arguments ────────────────────────────────────────

if [ "${1:-}" = "--list" ]; then
  echo "Available frameworks:"
  list_frameworks
  exit 0
fi

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

FRAMEWORK_INPUT="${1:-}"
APP_NAME="${2:-}"
IS_PACKAGE="${3:-}"

if [ -z "$FRAMEWORK_INPUT" ] || [ -z "$APP_NAME" ]; then
  usage
  exit 1
fi

# ─── Resolve framework plugin ──────────────────────────────

FRAMEWORK_FILE=$(resolve_framework "$FRAMEWORK_INPUT") || {
  echo "Error: Unknown framework '$FRAMEWORK_INPUT'"
  echo ""
  echo "Available frameworks:"
  list_frameworks
  echo ""
  echo "To add a new framework, copy frameworks/_template.sh"
  exit 1
}

# Reset variables before sourcing
FRAMEWORK_NAME=""
FRAMEWORK_PREFIXES=()
FRAMEWORK_DETECT_FILE=""
FRAMEWORK_EXTENSIONS=()
FRAMEWORK_INSTALL_CMD=""
FRAMEWORK_LINT_CMD=""
FRAMEWORK_TEST_CMD=""
FRAMEWORK_FORMAT_CMD=""
FRAMEWORK_CLEAN_CMD=""

# shellcheck disable=SC1090
source "$FRAMEWORKS_DIR/$FRAMEWORK_FILE"

# ─── Determine target directory ─────────────────────────────

PREFIX="${FRAMEWORK_PREFIXES[0]}"

if [ "$IS_PACKAGE" = "--package" ]; then
  TARGET="packages/${PREFIX}${APP_NAME}"
else
  TARGET="apps/${PREFIX}${APP_NAME}"
fi

if [ -d "$REPO_ROOT/$TARGET" ]; then
  echo "Error: $TARGET already exists"
  exit 1
fi

# ─── Create project ─────────────────────────────────────────

echo "Creating $TARGET ($FRAMEWORK_NAME)..."
echo ""

cd "$REPO_ROOT"

IS_PKG="false"
[ "$IS_PACKAGE" = "--package" ] && IS_PKG="true"

scaffold "$TARGET" "$APP_NAME" "$IS_PKG"

echo ""
echo "Created $TARGET ($FRAMEWORK_NAME)"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
if [ -n "$FRAMEWORK_INSTALL_CMD" ]; then
  echo "  2. $FRAMEWORK_INSTALL_CMD"
  echo "  3. Start developing"
else
  echo "  2. Start developing"
fi
echo ""
echo "CI will auto-detect the new project on your next PR."
