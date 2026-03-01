# Web — Web Applications

This directory contains web applications. Each app lives in its own subdirectory, prefixed by framework name.

For mobile apps, see [`apps/`](../apps/). For backend services, see [`backends/`](../backends/). For shared libraries, see [`packages/`](../packages/).

## Naming Convention

| Prefix | Framework | Marker File | Example |
|--------|-----------|-------------|---------|
| `react_` | React | `package.json` | `react_dashboard/` |
| `vue_` | Vue.js | `package.json` | `vue_portal/` |
| `nextjs_` | Next.js | `package.json` | `nextjs_marketing/` |
| `angular_` | Angular | `package.json` | `angular_admin/` |

## Bootstrap Commands

```bash
# Using the bootstrap script directly
./scripts/bootstrap.sh react myapp         # → web/react_myapp/
./scripts/bootstrap.sh vue myapp           # → web/vue_myapp/
./scripts/bootstrap.sh nextjs myapp        # → web/nextjs_myapp/
./scripts/bootstrap.sh angular myapp       # → web/angular_myapp/

# Using the Makefile
make bootstrap-react APP=dashboard
make bootstrap-vue APP=portal
make bootstrap-nextjs APP=marketing
make bootstrap-angular APP=admin
```

## What CI Runs

When files in `web/` change on a PR, the `web-ci` job runs for each project that has a `package.json`:

| Step | Command | Notes |
|------|---------|-------|
| Install | `npm ci` | Clean install from lockfile |
| Lint | `npx eslint . --max-warnings 0` | If ESLint is available |
| Type-check | `npx tsc --noEmit` | If `tsconfig.json` exists |
| Test | `npm test -- --watchAll=false --passWithNoTests` | If `test` script is defined |
| Build | `npm run build` | If `build` script is defined |

No workflow modifications are needed when adding a new web app. The CI pipeline detects all directories under `web/`.

## Deployment

Web apps are deployed via the manual-trigger `cd-web.yml` workflow. Select the app directory name and target environment (staging or production).

## Guidelines

- Each app should be self-contained with its own `package.json` and dependencies.
- Shared code belongs in [`packages/`](../packages/), not duplicated across apps.
- All apps should include a `build` script for production builds.
- All apps must include tests. CI will run them automatically.
