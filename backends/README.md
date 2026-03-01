# Backends

Backend services live here. Each service has its own directory with a stack prefix.

## Naming Convention

| Prefix | Stack | Example |
|--------|-------|---------|
| `node_` | Node.js | `node_api/` |
| `python_` | Python | `python_api/` |
| `go_` | Go | `go_api/` |
| `rust_` | Rust | `rust_api/` |

## Create a New Backend

```bash
# From the repo root
./scripts/bootstrap.sh node api
./scripts/bootstrap.sh python api
./scripts/bootstrap.sh go api
./scripts/bootstrap.sh rust api
```

Each backend includes a Dockerfile for containerized deployment to Cloud Run.

CI automatically detects backends in this directory -- no workflow changes needed.
