# ─── Monorepo Makefile ──────────────────────────────────────
# Auto-discovers apps via framework plugins in frameworks/.
# No hardcoded languages — add a .sh file to frameworks/ to
# support a new framework.

.PHONY: help bootstrap bootstrap-package lint test format clean setup-protection list-frameworks

FRAMEWORKS_DIR := frameworks

# ─── Default ──────────────────────────────────────────────────
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# ─── Bootstrap ────────────────────────────────────────────────
bootstrap: ## Create a new app (usage: make bootstrap FW=flutter APP=myapp)
	@./scripts/bootstrap.sh $(FW) $(APP)

bootstrap-package: ## Create a shared package (usage: make bootstrap-package FW=flutter APP=utils)
	@./scripts/bootstrap.sh $(FW) $(APP) --package

list-frameworks: ## List available frameworks
	@./scripts/bootstrap.sh --list

# ─── Quality ──────────────────────────────────────────────────
# Discovers apps by sourcing each framework plugin and checking
# for the detect file in each apps/* directory.

lint: ## Run linters for all detected apps
	@echo "Scanning for apps..."
	@for fw in $(FRAMEWORKS_DIR)/*.sh; do \
		base=$$(basename "$$fw" .sh); \
		[ "$$base" = "_template" ] && continue; \
		FRAMEWORK_DETECT_FILE=""; FRAMEWORK_LINT_CMD=""; FRAMEWORK_INSTALL_CMD=""; FRAMEWORK_NAME=""; \
		eval "$$(grep -E '^FRAMEWORK_(DETECT_FILE|LINT_CMD|INSTALL_CMD|NAME)=' "$$fw")"; \
		[ -z "$$FRAMEWORK_LINT_CMD" ] && continue; \
		for dir in apps/*/; do \
			[ ! -d "$$dir" ] && continue; \
			if [ -f "$$dir/$$FRAMEWORK_DETECT_FILE" ]; then \
				echo "── $$FRAMEWORK_NAME: $$dir"; \
				if [ -n "$$FRAMEWORK_INSTALL_CMD" ]; then \
					(cd "$$dir" && eval "$$FRAMEWORK_INSTALL_CMD" 2>/dev/null) || true; \
				fi; \
				(cd "$$dir" && eval "$$FRAMEWORK_LINT_CMD") || true; \
			fi; \
		done; \
	done

test: ## Run tests for all detected apps
	@echo "Running tests..."
	@for fw in $(FRAMEWORKS_DIR)/*.sh; do \
		base=$$(basename "$$fw" .sh); \
		[ "$$base" = "_template" ] && continue; \
		FRAMEWORK_DETECT_FILE=""; FRAMEWORK_TEST_CMD=""; FRAMEWORK_INSTALL_CMD=""; FRAMEWORK_NAME=""; \
		eval "$$(grep -E '^FRAMEWORK_(DETECT_FILE|TEST_CMD|INSTALL_CMD|NAME)=' "$$fw")"; \
		[ -z "$$FRAMEWORK_TEST_CMD" ] && continue; \
		for dir in apps/*/; do \
			[ ! -d "$$dir" ] && continue; \
			if [ -f "$$dir/$$FRAMEWORK_DETECT_FILE" ]; then \
				echo "── $$FRAMEWORK_NAME: $$dir"; \
				if [ -n "$$FRAMEWORK_INSTALL_CMD" ]; then \
					(cd "$$dir" && eval "$$FRAMEWORK_INSTALL_CMD" 2>/dev/null) || true; \
				fi; \
				(cd "$$dir" && eval "$$FRAMEWORK_TEST_CMD") || true; \
			fi; \
		done; \
	done

format: ## Format code in all detected apps
	@echo "Formatting..."
	@for fw in $(FRAMEWORKS_DIR)/*.sh; do \
		base=$$(basename "$$fw" .sh); \
		[ "$$base" = "_template" ] && continue; \
		FRAMEWORK_DETECT_FILE=""; FRAMEWORK_FORMAT_CMD=""; FRAMEWORK_NAME=""; \
		eval "$$(grep -E '^FRAMEWORK_(DETECT_FILE|FORMAT_CMD|NAME)=' "$$fw")"; \
		[ -z "$$FRAMEWORK_FORMAT_CMD" ] && continue; \
		for dir in apps/*/; do \
			[ ! -d "$$dir" ] && continue; \
			if [ -f "$$dir/$$FRAMEWORK_DETECT_FILE" ]; then \
				echo "── $$FRAMEWORK_NAME: $$dir"; \
				(cd "$$dir" && eval "$$FRAMEWORK_FORMAT_CMD") || true; \
			fi; \
		done; \
	done

clean: ## Clean build artifacts for all detected apps
	@echo "Cleaning..."
	@for fw in $(FRAMEWORKS_DIR)/*.sh; do \
		base=$$(basename "$$fw" .sh); \
		[ "$$base" = "_template" ] && continue; \
		FRAMEWORK_DETECT_FILE=""; FRAMEWORK_CLEAN_CMD=""; FRAMEWORK_NAME=""; \
		eval "$$(grep -E '^FRAMEWORK_(DETECT_FILE|CLEAN_CMD|NAME)=' "$$fw")"; \
		[ -z "$$FRAMEWORK_CLEAN_CMD" ] && continue; \
		for dir in apps/*/; do \
			[ ! -d "$$dir" ] && continue; \
			if [ -f "$$dir/$$FRAMEWORK_DETECT_FILE" ]; then \
				echo "── $$FRAMEWORK_NAME: $$dir"; \
				(cd "$$dir" && eval "$$FRAMEWORK_CLEAN_CMD") || true; \
			fi; \
		done; \
	done

# ─── Setup ────────────────────────────────────────────────────
setup-protection: ## Configure branch protection rules (usage: make setup-protection REPO=owner/repo)
	@./scripts/setup-branch-protection.sh $(REPO)
