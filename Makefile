# ─── Mobile Monorepo Makefile ─────────────────────────────────
# Auto-detects apps and runs the appropriate tools per framework.

.PHONY: help bootstrap-flutter bootstrap-rn bootstrap-kotlin setup-protection lint test clean

# ─── Default ──────────────────────────────────────────────────
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# ─── Bootstrap ────────────────────────────────────────────────
bootstrap-flutter: ## Create a new Flutter app (usage: make bootstrap-flutter APP=myapp)
	@./scripts/bootstrap.sh flutter $(APP)

bootstrap-rn: ## Create a new React Native app (usage: make bootstrap-rn APP=myapp)
	@./scripts/bootstrap.sh rn $(APP)

bootstrap-kotlin: ## Create a new Kotlin app (usage: make bootstrap-kotlin APP=myapp)
	@./scripts/bootstrap.sh kotlin $(APP)

bootstrap-package: ## Create a shared package (usage: make bootstrap-package FW=flutter APP=utils)
	@./scripts/bootstrap.sh $(FW) $(APP) --package

# ─── Quality ──────────────────────────────────────────────────
lint: ## Run linters for all detected apps
	@echo "Scanning for apps..."
	@for dir in apps/*/; do \
		if [ -f "$$dir/pubspec.yaml" ]; then \
			echo "── Flutter: $$dir"; \
			if [ -n "$$ALLOW_FAILURES" ]; then (cd "$$dir" && flutter analyze --no-fatal-infos) || true; else (cd "$$dir" && flutter analyze --no-fatal-infos); fi; \
		elif [ -f "$$dir/package.json" ]; then \
			echo "── React Native: $$dir"; \
			if [ -n "$$ALLOW_FAILURES" ]; then (cd "$$dir" && npx eslint . --ext .ts,.tsx,.js,.jsx --max-warnings 0) || true; else (cd "$$dir" && npx eslint . --ext .ts,.tsx,.js,.jsx --max-warnings 0); fi; \
		elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
			echo "── Kotlin: $$dir"; \
			if [ -n "$$ALLOW_FAILURES" ]; then (cd "$$dir" && ./gradlew lint) || true; else (cd "$$dir" && ./gradlew lint); fi; \
		fi; \
	done

test: ## Run tests for all detected apps
	@echo "Running tests..."
	@for dir in apps/*/; do \
		if [ -f "$$dir/pubspec.yaml" ]; then \
			echo "── Flutter: $$dir"; \
			(cd "$$dir" && flutter test) || true; \
		elif [ -f "$$dir/package.json" ]; then \
			echo "── React Native: $$dir"; \
			(cd "$$dir" && npm test -- --watchAll=false) || true; \
		elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
			echo "── Kotlin: $$dir"; \
			(cd "$$dir" && ./gradlew test) || true; \
		fi; \
	done

format: ## Format code in all detected apps
	@echo "Formatting..."
	@for dir in apps/*/; do \
		if [ -f "$$dir/pubspec.yaml" ]; then \
			echo "── Flutter: $$dir"; \
			(cd "$$dir" && dart format .) || true; \
		elif [ -f "$$dir/package.json" ]; then \
			echo "── React Native: $$dir"; \
			(cd "$$dir" && npx prettier --write "src/**/*.{ts,tsx,js,jsx}") || true; \
		elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
			echo "── Kotlin: $$dir"; \
			(cd "$$dir" && ./gradlew ktlintFormat 2>/dev/null) || true; \
		fi; \
	done

# ─── Setup ────────────────────────────────────────────────────
setup-protection: ## Configure branch protection rules (usage: make setup-protection REPO=owner/repo)
	@./scripts/setup-branch-protection.sh $(REPO)

# ─── Clean ────────────────────────────────────────────────────
clean: ## Clean build artifacts for all apps
	@echo "Cleaning..."
	@for dir in apps/*/; do \
		if [ -f "$$dir/pubspec.yaml" ]; then \
			echo "── Flutter: $$dir"; \
			(cd "$$dir" && flutter clean) || true; \
		elif [ -f "$$dir/package.json" ]; then \
			echo "── React Native: $$dir"; \
			rm -rf "$$dir/node_modules" "$$dir/.cache"; \
		elif [ -f "$$dir/build.gradle.kts" ] || [ -f "$$dir/build.gradle" ]; then \
			echo "── Kotlin: $$dir"; \
			(cd "$$dir" && ./gradlew clean) || true; \
		fi; \
	done
