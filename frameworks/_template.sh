#!/usr/bin/env bash
# ─── Framework Plugin Template ──────────────────────────────
# Copy this file and rename it to <framework>.sh to add support
# for a new framework.
#
# Required: FRAMEWORK_NAME, FRAMEWORK_DETECT_FILE, scaffold()
# ─────────────────────────────────────────────────────────────

# ─── Metadata ───────────────────────────────────────────────
FRAMEWORK_NAME="My Framework"            # Display name
FRAMEWORK_PREFIXES=("myfw_")             # Directory prefixes for CI detection
FRAMEWORK_DETECT_FILE="myfw.config"      # File that identifies this framework
FRAMEWORK_EXTENSIONS=(".myfw")           # Source file extensions

# ─── Commands (leave empty if not applicable) ───────────────
FRAMEWORK_INSTALL_CMD=""                 # Install dependencies
FRAMEWORK_LINT_CMD=""                    # Lint / static analysis
FRAMEWORK_TEST_CMD=""                    # Run tests
FRAMEWORK_FORMAT_CMD=""                  # Format source code
FRAMEWORK_CLEAN_CMD=""                   # Clean build artifacts

# ─── CI Setup (GitHub Actions) ──────────────────────────────
# Shell commands to run in CI before lint/test.
# Use this to install SDKs, set up environment, etc.
ci_setup() {
  echo "No CI setup defined — override this function"
}

# ─── Scaffold ───────────────────────────────────────────────
# Creates a new project in $target_dir with name $app_name.
#   $1 = target directory (e.g. apps/myfw_myapp)
#   $2 = app/package name
#   $3 = "true" if --package flag was passed
scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  mkdir -p "$target"
  echo "Override scaffold() in your framework plugin"
}
