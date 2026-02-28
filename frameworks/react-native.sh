#!/usr/bin/env bash
# ─── React Native / TypeScript ──────────────────────────────

FRAMEWORK_NAME="React Native"
FRAMEWORK_PREFIXES=("rn_" "react_native_")
FRAMEWORK_DETECT_FILE="package.json"
FRAMEWORK_EXTENSIONS=(".ts" ".tsx" ".js" ".jsx")

FRAMEWORK_INSTALL_CMD="npm ci"
FRAMEWORK_LINT_CMD="npx eslint . --max-warnings 0"
FRAMEWORK_TEST_CMD="npm test -- --coverage --watchAll=false"
FRAMEWORK_FORMAT_CMD="npx prettier --write 'src/**/*.{ts,tsx,js,jsx}'"
FRAMEWORK_CLEAN_CMD="rm -rf node_modules .cache"

ci_setup() {
  echo "uses: actions/setup-node@v4"
  echo "with:"
  echo "  node-version: 20"
  echo "  cache: npm"
}

scaffold() {
  local target="$1" name="$2" is_package="${3:-false}"
  if ! command -v npx &>/dev/null; then
    echo "Error: npx not found. Install Node.js first."
    exit 1
  fi
  if [ "$is_package" = "true" ]; then
    mkdir -p "$target/src"
    cat > "$target/package.json" << JSON
{
  "name": "@monorepo/${name}",
  "version": "0.0.1",
  "main": "src/index.ts",
  "scripts": {
    "test": "jest",
    "lint": "eslint . --max-warnings 0"
  }
}
JSON
    cat > "$target/tsconfig.json" << JSON
{
  "compilerOptions": {
    "strict": true,
    "target": "es2020",
    "module": "commonjs",
    "outDir": "dist",
    "declaration": true
  },
  "include": ["src"]
}
JSON
    cat > "$target/src/index.ts" << 'TS'
export {};
TS
  else
    npx react-native init "${name}" --directory "$target"
  fi
}
