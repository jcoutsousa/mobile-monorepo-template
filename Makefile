# ─── Monorepo Makefile ────────────────────────────────────────
# Auto-detects projects across apps/, packages/, web/, backends/ and runs
# the appropriate tools per framework.

.PHONY: help \
	bootstrap-flutter bootstrap-rn bootstrap-kotlin bootstrap-swift \
	bootstrap-react bootstrap-vue bootstrap-nextjs bootstrap-angular \
	bootstrap-node bootstrap-python bootstrap-go bootstrap-rust \
	bootstrap-package \
	setup-protection lint test format clean

# ─── Helpers ─────────────────────────────────────────────────
# Run a command, optionally allowing failures when ALLOW_FAILURES is set.
# Usage: $(call run_cmd,cd some/dir && some_command)
define run_cmd
if [ -n "$$ALLOW_FAILURES" ]; then $(1) || true; else $(1); fi
endef

# Iterate over apps/, web/, backends/ and dispatch per framework.
# $(1) = action name (lint|test|format|clean)
# The body of each action is defined in the per-target recipes below
# via the _dispatch_* functions.

SCAN_DIRS := apps packages web backends

# ─── Default ─────────────────────────────────────────────────
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# ─── Bootstrap: Mobile / Native ─────────────────────────────
bootstrap-flutter: ## Create a Flutter app (APP=name)
	@./scripts/bootstrap.sh flutter $(APP)

bootstrap-rn: ## Create a React Native app (APP=name)
	@./scripts/bootstrap.sh rn $(APP)

bootstrap-kotlin: ## Create a Kotlin app (APP=name)
	@./scripts/bootstrap.sh kotlin $(APP)

bootstrap-swift: ## Create a Swift app (APP=name)
	@./scripts/bootstrap.sh swift $(APP)

# ─── Bootstrap: Web ──────────────────────────────────────────
bootstrap-react: ## Create a React app (APP=name)
	@./scripts/bootstrap.sh react $(APP)

bootstrap-vue: ## Create a Vue app (APP=name)
	@./scripts/bootstrap.sh vue $(APP)

bootstrap-nextjs: ## Create a Next.js app (APP=name)
	@./scripts/bootstrap.sh nextjs $(APP)

bootstrap-angular: ## Create an Angular app (APP=name)
	@./scripts/bootstrap.sh angular $(APP)

# ─── Bootstrap: Backends ─────────────────────────────────────
bootstrap-node: ## Create a Node.js backend (APP=name)
	@./scripts/bootstrap.sh node $(APP)

bootstrap-python: ## Create a Python backend (APP=name)
	@./scripts/bootstrap.sh python $(APP)

bootstrap-go: ## Create a Go backend (APP=name)
	@./scripts/bootstrap.sh go $(APP)

bootstrap-rust: ## Create a Rust backend (APP=name)
	@./scripts/bootstrap.sh rust $(APP)

# ─── Bootstrap: Packages ─────────────────────────────────────
bootstrap-package: ## Create a shared package (FW=framework APP=name)
	@./scripts/bootstrap.sh $(FW) $(APP) --package

# ─── Quality: Lint ───────────────────────────────────────────
lint: ## Run linters for all detected projects
	@echo "Scanning for projects to lint..."
	@for scan_root in $(SCAN_DIRS); do \
		[ -d "$$scan_root" ] || continue; \
		for dir in $$scan_root/*/; do \
			[ -d "$$dir" ] || continue; \
			if [ -f "$$dir/pubspec.yaml" ]; then \
				echo "── Flutter: $$dir"; \
				$(call run_cmd,(cd "$$dir" && flutter analyze --no-fatal-infos)); \
			elif [ -f "$$dir/Cargo.toml" ]; then \
				echo "── Rust: $$dir"; \
				$(call run_cmd,(cd "$$dir" && cargo clippy -- -D warnings)); \
			elif [ -f "$$dir/go.mod" ]; then \
				echo "── Go: $$dir"; \
				if command -v golangci-lint >/dev/null 2>&1; then \
					$(call run_cmd,(cd "$$dir" && golangci-lint run)); \
				else \
					$(call run_cmd,(cd "$$dir" && go vet ./...)); \
				fi; \
			elif [ -f "$$dir/Package.swift" ]; then \
				echo "── Swift: $$dir"; \
				$(call run_cmd,(cd "$$dir" && swift build)); \
			elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
				echo "── Kotlin: $$dir"; \
				$(call run_cmd,(cd "$$dir" && ./gradlew lint)); \
			elif [ -f "$$dir/pyproject.toml" ] || [ -f "$$dir/requirements.txt" ]; then \
				echo "── Python: $$dir"; \
				if command -v ruff >/dev/null 2>&1; then \
					$(call run_cmd,(cd "$$dir" && ruff check .)); \
				else \
					$(call run_cmd,(cd "$$dir" && flake8 .)); \
				fi; \
			elif [ -f "$$dir/package.json" ]; then \
				echo "── Node/RN: $$dir"; \
				if [ -f "$$dir/node_modules/.bin/eslint" ] || grep -q '"eslint"' "$$dir/package.json" 2>/dev/null; then \
					$(call run_cmd,(cd "$$dir" && npx eslint . --max-warnings 0)); \
				else \
					echo "   (eslint not found, skipping)"; \
				fi; \
			fi; \
		done; \
	done

# ─── Quality: Test ───────────────────────────────────────────
test: ## Run tests for all detected projects
	@echo "Running tests..."
	@for scan_root in $(SCAN_DIRS); do \
		[ -d "$$scan_root" ] || continue; \
		for dir in $$scan_root/*/; do \
			[ -d "$$dir" ] || continue; \
			if [ -f "$$dir/pubspec.yaml" ]; then \
				echo "── Flutter: $$dir"; \
				$(call run_cmd,(cd "$$dir" && flutter test)); \
			elif [ -f "$$dir/Cargo.toml" ]; then \
				echo "── Rust: $$dir"; \
				$(call run_cmd,(cd "$$dir" && cargo test)); \
			elif [ -f "$$dir/go.mod" ]; then \
				echo "── Go: $$dir"; \
				$(call run_cmd,(cd "$$dir" && go test ./...)); \
			elif [ -f "$$dir/Package.swift" ]; then \
				echo "── Swift: $$dir"; \
				$(call run_cmd,(cd "$$dir" && swift test)); \
			elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
				echo "── Kotlin: $$dir"; \
				$(call run_cmd,(cd "$$dir" && ./gradlew test)); \
			elif [ -f "$$dir/pyproject.toml" ] || [ -f "$$dir/requirements.txt" ]; then \
				echo "── Python: $$dir"; \
				if command -v pytest >/dev/null 2>&1; then \
					$(call run_cmd,(cd "$$dir" && pytest)); \
				else \
					$(call run_cmd,(cd "$$dir" && python -m pytest)); \
				fi; \
			elif [ -f "$$dir/package.json" ]; then \
				echo "── Node/RN: $$dir"; \
				$(call run_cmd,(cd "$$dir" && npm test -- --watchAll=false)); \
			fi; \
		done; \
	done

# ─── Quality: Format ────────────────────────────────────────
format: ## Format code in all detected projects
	@echo "Formatting..."
	@for scan_root in $(SCAN_DIRS); do \
		[ -d "$$scan_root" ] || continue; \
		for dir in $$scan_root/*/; do \
			[ -d "$$dir" ] || continue; \
			if [ -f "$$dir/pubspec.yaml" ]; then \
				echo "── Flutter: $$dir"; \
				$(call run_cmd,(cd "$$dir" && dart format .)); \
			elif [ -f "$$dir/Cargo.toml" ]; then \
				echo "── Rust: $$dir"; \
				$(call run_cmd,(cd "$$dir" && cargo fmt)); \
			elif [ -f "$$dir/go.mod" ]; then \
				echo "── Go: $$dir"; \
				$(call run_cmd,(cd "$$dir" && gofmt -w .)); \
			elif [ -f "$$dir/Package.swift" ]; then \
				echo "── Swift: $$dir"; \
				$(call run_cmd,(cd "$$dir" && swift-format format -r . -i)); \
			elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
				echo "── Kotlin: $$dir"; \
				$(call run_cmd,(cd "$$dir" && ./gradlew ktlintFormat)); \
			elif [ -f "$$dir/pyproject.toml" ] || [ -f "$$dir/requirements.txt" ]; then \
				echo "── Python: $$dir"; \
				if command -v ruff >/dev/null 2>&1; then \
					$(call run_cmd,(cd "$$dir" && ruff format .)); \
				else \
					$(call run_cmd,(cd "$$dir" && black .)); \
				fi; \
			elif [ -f "$$dir/package.json" ]; then \
				echo "── Node/RN: $$dir"; \
				$(call run_cmd,(cd "$$dir" && npx prettier --write .)); \
			fi; \
		done; \
	done

# ─── Setup ───────────────────────────────────────────────────
setup-protection: ## Configure branch protection rules (REPO=owner/repo)
	@./scripts/setup-branch-protection.sh $(REPO)

# ─── Clean ───────────────────────────────────────────────────
clean: ## Clean build artifacts for all projects
	@echo "Cleaning..."
	@for scan_root in $(SCAN_DIRS); do \
		[ -d "$$scan_root" ] || continue; \
		for dir in $$scan_root/*/; do \
			[ -d "$$dir" ] || continue; \
			if [ -f "$$dir/pubspec.yaml" ]; then \
				echo "── Flutter: $$dir"; \
				$(call run_cmd,(cd "$$dir" && flutter clean)); \
			elif [ -f "$$dir/Cargo.toml" ]; then \
				echo "── Rust: $$dir"; \
				$(call run_cmd,(cd "$$dir" && cargo clean)); \
			elif [ -f "$$dir/go.mod" ]; then \
				echo "── Go: $$dir"; \
				$(call run_cmd,(cd "$$dir" && go clean)); \
			elif [ -f "$$dir/Package.swift" ]; then \
				echo "── Swift: $$dir"; \
				$(call run_cmd,(cd "$$dir" && swift package clean)); \
			elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
				echo "── Kotlin: $$dir"; \
				$(call run_cmd,(cd "$$dir" && ./gradlew clean)); \
			elif [ -f "$$dir/pyproject.toml" ] || [ -f "$$dir/requirements.txt" ]; then \
				echo "── Python: $$dir"; \
				rm -rf "$$dir/__pycache__" "$$dir/.pytest_cache" "$$dir/.ruff_cache" "$$dir/dist" "$$dir/*.egg-info" "$$dir/.venv"; \
			elif [ -f "$$dir/package.json" ]; then \
				echo "── Node/RN: $$dir"; \
				rm -rf "$$dir/node_modules" "$$dir/.cache" "$$dir/.next" "$$dir/dist" "$$dir/build"; \
			fi; \
		done; \
	done
