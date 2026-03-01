## Summary
<!-- 1-3 bullet points describing what this PR does -->

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring (no functional changes)
- [ ] Documentation update
- [ ] CI/CD changes
- [ ] Infrastructure (Terraform) changes
- [ ] Dependencies update

## Area(s) Affected
- [ ] `apps/flutter_*` (Flutter mobile)
- [ ] `apps/rn_*` (React Native mobile)
- [ ] `apps/kotlin_*` (Kotlin mobile)
- [ ] `apps/ios_*` (Swift/iOS mobile)
- [ ] `web/react_*` (React web)
- [ ] `web/vue_*` (Vue.js web)
- [ ] `web/nextjs_*` (Next.js web)
- [ ] `web/angular_*` (Angular web)
- [ ] `backends/node_*` (Node.js backend)
- [ ] `backends/python_*` (Python backend)
- [ ] `backends/go_*` (Go backend)
- [ ] `backends/rust_*` (Rust backend)
- [ ] `packages/*` (Shared libraries)
- [ ] `terraform/*` (Infrastructure)
- [ ] `.github/*` (CI/CD, agents, instructions)
- [ ] Other: ___

## Checklist
- [ ] Code follows the project's style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated for new functionality
- [ ] All CI checks pass
- [ ] No hardcoded secrets, keys, or credentials
- [ ] Documentation updated if needed

## Stack-Specific Checks

### Mobile (if applicable)
- [ ] Flutter: `flutter analyze` passes with no issues
- [ ] React Native: TypeScript strict mode (`tsc --noEmit`) passes
- [ ] Kotlin: Detekt / ktlint passes
- [ ] Swift: Builds with `swift build` or `xcodebuild`

### Web (if applicable)
- [ ] ESLint passes with zero warnings
- [ ] TypeScript type-check passes (if applicable)
- [ ] Production build succeeds (`npm run build`)

### Backend (if applicable)
- [ ] Linter passes (ESLint / ruff / golangci-lint / clippy)
- [ ] All tests pass
- [ ] Dockerfile builds successfully
- [ ] Health endpoint (`/health`) is functional

### Infrastructure (if applicable)
- [ ] `terraform fmt` applied
- [ ] `terraform validate` passes for all environments
- [ ] `terraform plan` reviewed for unintended changes
- [ ] No secrets in `.tf` or `.tfvars` files

## AI Components (if applicable)
- [ ] AI risk classification reviewed
- [ ] Transparency/disclosure requirements met
- [ ] Human oversight mechanisms in place
- [ ] Data governance documentation updated

## Test Plan
<!-- How was this tested? -->
