#!/usr/bin/env bash
set -euo pipefail

# ─── Monorepo Bootstrap Script ────────────────────────────────
# Usage:
#   ./scripts/bootstrap.sh <framework> <app-name> [--package]
#
# Mobile / Native  (target: apps/)
#   flutter, rn, kotlin, swift
#
# Web  (target: web/)
#   react, vue, nextjs, angular
#
# Backends  (target: backends/)
#   node, python, go, rust
#
# Examples:
#   ./scripts/bootstrap.sh flutter myapp          # apps/flutter_myapp
#   ./scripts/bootstrap.sh react dashboard         # web/react_dashboard
#   ./scripts/bootstrap.sh python api              # backends/python_api
#   ./scripts/bootstrap.sh flutter utils --package # packages/flutter_utils

FRAMEWORK="${1:-}"
APP_NAME="${2:-}"
IS_PACKAGE="${3:-}"

if [ -z "$FRAMEWORK" ] || [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <framework> <app-name> [--package]"
  echo ""
  echo "Mobile / Native (creates in apps/):"
  echo "  flutter   Flutter app or package"
  echo "  rn        React Native app"
  echo "  kotlin    Kotlin/JVM app"
  echo "  swift     Swift Package Manager project"
  echo ""
  echo "Web (creates in web/):"
  echo "  react     React app (Create React App)"
  echo "  vue       Vue 3 app"
  echo "  nextjs    Next.js app"
  echo "  angular   Angular app"
  echo ""
  echo "Backends (creates in backends/):"
  echo "  node      Node.js + Express"
  echo "  python    Python + FastAPI"
  echo "  go        Go HTTP server"
  echo "  rust      Rust (cargo init)"
  echo ""
  echo "Options:"
  echo "  --package   Create as shared package in packages/ (flutter, node, python, go, rust)"
  echo ""
  echo "Examples:"
  echo "  $0 flutter myapp          # New Flutter app"
  echo "  $0 react dashboard        # New React web app"
  echo "  $0 python api             # New Python backend"
  echo "  $0 flutter utils --package # New shared Flutter package"
  exit 1
fi

# ─── Determine target directory ───────────────────────────────
if [ "$IS_PACKAGE" = "--package" ]; then
  TARGET="packages/${FRAMEWORK}_${APP_NAME}"
else
  case "$FRAMEWORK" in
    flutter|rn|react-native|kotlin|kmp|swift|ios)
      TARGET="apps/${FRAMEWORK}_${APP_NAME}"
      ;;
    react|vue|nextjs|angular)
      TARGET="web/${FRAMEWORK}_${APP_NAME}"
      ;;
    node|python|go|rust)
      TARGET="backends/${FRAMEWORK}_${APP_NAME}"
      ;;
    *)
      TARGET="apps/${FRAMEWORK}_${APP_NAME}"
      ;;
  esac
fi

if [ -d "$TARGET" ]; then
  echo "Error: $TARGET already exists"
  exit 1
fi

echo "Creating $TARGET..."

# Ensure parent directory exists
mkdir -p "$(dirname "$TARGET")"

# ─── Framework scaffolds ──────────────────────────────────────

case "$FRAMEWORK" in

  # ── Mobile / Native ──────────────────────────────────────────

  flutter)
    if [ "$IS_PACKAGE" = "--package" ]; then
      flutter create --template=package "$TARGET"
    else
      flutter create --org com.example "$TARGET"
    fi
    echo "Done: Flutter project created at $TARGET"
    echo "  Run: cd $TARGET && flutter pub get"
    ;;

  rn|react-native)
    if command -v npx &>/dev/null; then
      npx react-native init "${APP_NAME}" --directory "$TARGET"
    else
      echo "Error: npx not found. Install Node.js first."
      exit 1
    fi
    echo "Done: React Native project created at $TARGET"
    echo "  Run: cd $TARGET && npm install"
    ;;

  kotlin|kmp)
    mkdir -p "$TARGET/src/main/kotlin" "$TARGET/src/test/kotlin"
    cat > "$TARGET/build.gradle.kts" << 'GRADLE'
plugins {
    kotlin("jvm") version "1.9.22"
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}
GRADLE
    echo "Done: Kotlin project created at $TARGET"
    echo "  Run: cd $TARGET && ./gradlew build"
    ;;

  swift|ios)
    mkdir -p "$TARGET/Sources" "$TARGET/Tests"
    cat > "$TARGET/Package.swift" << SWIFT
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "${APP_NAME}",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "${APP_NAME}", targets: ["${APP_NAME}"]),
    ],
    targets: [
        .target(name: "${APP_NAME}"),
        .testTarget(name: "${APP_NAME}Tests", dependencies: ["${APP_NAME}"]),
    ]
)
SWIFT
    echo "Done: Swift project created at $TARGET"
    echo "  Run: cd $TARGET && swift build"
    ;;

  # ── Web ──────────────────────────────────────────────────────

  react)
    if command -v npx &>/dev/null; then
      npx create-react-app "$TARGET"
    else
      echo "Error: npx not found. Install Node.js first."
      exit 1
    fi
    echo "Done: React app created at $TARGET"
    echo "  Run: cd $TARGET && npm start"
    ;;

  vue)
    if command -v npm &>/dev/null; then
      npm create vue@latest "$TARGET" -- --default
    else
      echo "Error: npm not found. Install Node.js first."
      exit 1
    fi
    echo "Done: Vue app created at $TARGET"
    echo "  Run: cd $TARGET && npm install && npm run dev"
    ;;

  nextjs)
    if command -v npx &>/dev/null; then
      npx create-next-app@latest "$TARGET" --use-npm
    else
      echo "Error: npx not found. Install Node.js first."
      exit 1
    fi
    echo "Done: Next.js app created at $TARGET"
    echo "  Run: cd $TARGET && npm run dev"
    ;;

  angular)
    if command -v npx &>/dev/null; then
      npx @angular/cli new "${APP_NAME}" --directory "$TARGET" --skip-git
    else
      echo "Error: npx not found. Install Node.js first."
      exit 1
    fi
    echo "Done: Angular app created at $TARGET"
    echo "  Run: cd $TARGET && ng serve"
    ;;

  # ── Backends ─────────────────────────────────────────────────

  node)
    mkdir -p "$TARGET/src"

    cat > "$TARGET/package.json" << JSON
{
  "name": "${APP_NAME}",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start": "node src/index.js",
    "dev": "node --watch src/index.js",
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "eslint ."
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "eslint": "^8.56.0"
  }
}
JSON

    cat > "$TARGET/src/index.js" << 'JS'
const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
JS

    cat > "$TARGET/Dockerfile" << 'DOCKERFILE'
# ── Build stage ───────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ── Runtime stage ─────────────────────────────────────────────
FROM node:20-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER appuser
EXPOSE 3000
CMD ["node", "src/index.js"]
DOCKERFILE

    cat > "$TARGET/.dockerignore" << 'IGNORE'
node_modules
.cache
dist
*.log
IGNORE

    echo "Done: Node.js backend created at $TARGET"
    echo "  Run: cd $TARGET && npm install && npm run dev"
    ;;

  python)
    mkdir -p "$TARGET/src"

    cat > "$TARGET/pyproject.toml" << TOML
[project]
name = "${APP_NAME}"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "ruff>=0.2.0",
]

[tool.ruff]
target-version = "py311"
line-length = 100

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

    cat > "$TARGET/src/main.py" << 'PYTHON'
from fastapi import FastAPI

app = FastAPI()


@app.get("/health")
async def health() -> dict:
    return {"status": "ok"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("src.main:app", host="0.0.0.0", port=8000, reload=True)
PYTHON

    mkdir -p "$TARGET/tests"
    cat > "$TARGET/tests/__init__.py" << 'PYTHON'
PYTHON

    cat > "$TARGET/Dockerfile" << 'DOCKERFILE'
# ── Build stage ───────────────────────────────────────────────
FROM python:3.11-slim AS builder
WORKDIR /app
COPY pyproject.toml ./
RUN pip install --no-cache-dir .

# ── Runtime stage ─────────────────────────────────────────────
FROM python:3.11-slim
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .
USER appuser
EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
DOCKERFILE

    cat > "$TARGET/.dockerignore" << 'IGNORE'
__pycache__
.pytest_cache
.ruff_cache
.venv
dist
*.egg-info
IGNORE

    echo "Done: Python backend created at $TARGET"
    echo "  Run: cd $TARGET && pip install -e '.[dev]' && python src/main.py"
    ;;

  go)
    mkdir -p "$TARGET"

    cat > "$TARGET/go.mod" << GOMOD
module github.com/example/${APP_NAME}

go 1.22
GOMOD

    cat > "$TARGET/main.go" << 'GOLANG'
package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
	})

	log.Printf("Server listening on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
GOLANG

    cat > "$TARGET/main_test.go" << 'GOTEST'
package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealth(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	w := httptest.NewRecorder()

	http.DefaultServeMux = http.NewServeMux()
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(`{"status":"ok"}`))
	})
	http.DefaultServeMux.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("expected 200, got %d", w.Code)
	}
}
GOTEST

    cat > "$TARGET/Dockerfile" << 'DOCKERFILE'
# ── Build stage ───────────────────────────────────────────────
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server .

# ── Runtime stage ─────────────────────────────────────────────
FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /server /server
USER appuser
EXPOSE 8080
CMD ["/server"]
DOCKERFILE

    cat > "$TARGET/.dockerignore" << 'IGNORE'
*.test
*.out
IGNORE

    echo "Done: Go backend created at $TARGET"
    echo "  Run: cd $TARGET && go run ."
    ;;

  rust)
    if command -v cargo &>/dev/null; then
      cargo init "$TARGET"
    else
      echo "Error: cargo not found. Install Rust first."
      exit 1
    fi

    # Add a Dockerfile alongside the cargo scaffold
    # Determine the binary name (cargo init uses the directory basename)
    RUST_BIN_NAME="$(basename "$TARGET")"
    cat > "$TARGET/Dockerfile" << DOCKERFILE
# ── Build stage ───────────────────────────────────────────────
FROM rust:1.76-alpine AS builder
RUN apk add --no-cache musl-dev
WORKDIR /app
COPY Cargo.toml Cargo.lock* ./
# Cache dependency build
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo build --release && rm -rf src
COPY . .
RUN cargo build --release

# ── Runtime stage ─────────────────────────────────────────────
FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/target/release/${RUST_BIN_NAME} /usr/local/bin/server
USER appuser
EXPOSE 8080
CMD ["/usr/local/bin/server"]
DOCKERFILE

    cat > "$TARGET/.dockerignore" << 'IGNORE'
target
*.swp
IGNORE

    echo "Done: Rust project created at $TARGET"
    echo "  Run: cd $TARGET && cargo run"
    ;;

  # ── Unknown ──────────────────────────────────────────────────

  *)
    echo "Error: Unknown framework '$FRAMEWORK'"
    echo ""
    echo "Supported frameworks:"
    echo "  Mobile/Native : flutter, rn, kotlin, swift"
    echo "  Web           : react, vue, nextjs, angular"
    echo "  Backends      : node, python, go, rust"
    exit 1
    ;;
esac

echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Start developing"
echo "  3. CI will auto-detect the new project on your next PR"
