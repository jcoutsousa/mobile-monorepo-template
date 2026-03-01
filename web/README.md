# Web

Web applications live here. Each app has its own directory with a framework prefix.

## Naming Convention

| Prefix | Framework | Example |
|--------|-----------|---------|
| `react_` | React | `react_dashboard/` |
| `vue_` | Vue.js | `vue_portal/` |
| `nextjs_` | Next.js | `nextjs_marketing/` |
| `angular_` | Angular | `angular_admin/` |

## Create a New Web App

```bash
# From the repo root
./scripts/bootstrap.sh react myapp
./scripts/bootstrap.sh vue myapp
./scripts/bootstrap.sh nextjs myapp
./scripts/bootstrap.sh angular myapp
```

CI automatically detects web apps in this directory -- no workflow changes needed.
