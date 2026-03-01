# Backends — Backend Services

This directory contains backend services. Each service lives in its own subdirectory, prefixed by stack name. Backend scaffolds include a Dockerfile for containerized deployment to GCP Cloud Run.

For mobile apps, see [`apps/`](../apps/). For web applications, see [`web/`](../web/). For shared libraries, see [`packages/`](../packages/).

## Naming Convention

| Prefix | Stack | Marker File | Example |
|--------|-------|-------------|---------|
| `node_` | Node.js + Express | `package.json` | `node_api/` |
| `python_` | Python + FastAPI | `pyproject.toml` | `python_api/` |
| `go_` | Go HTTP server | `go.mod` | `go_api/` |
| `rust_` | Rust | `Cargo.toml` | `rust_api/` |

## Bootstrap Commands

```bash
# Using the bootstrap script directly
./scripts/bootstrap.sh node api            # → backends/node_api/
./scripts/bootstrap.sh python api          # → backends/python_api/
./scripts/bootstrap.sh go api              # → backends/go_api/
./scripts/bootstrap.sh rust api            # → backends/rust_api/

# Using the Makefile
make bootstrap-node APP=api
make bootstrap-python APP=api
make bootstrap-go APP=api
make bootstrap-rust APP=api
```

## What CI Runs

When files in `backends/` change on a PR, the `backend-ci` job iterates over each service directory and auto-detects the stack by marker file:

| Stack | Lint | Test |
|-------|------|------|
| Node.js | `eslint . --max-warnings 0` | `npm test` |
| Python | `ruff check .` (or `flake8`) | `pytest` |
| Go | `golangci-lint run` (or `go vet`) | `go test ./...` |
| Rust | `cargo clippy -- -D warnings` | `cargo test` |

Runtime setup is conditional: only the runtimes needed for the detected stacks are installed (Node.js, Python, Go, Rust).

No workflow modifications are needed when adding a new backend service. The CI pipeline detects it by the marker file.

## Deployment

Backend services are deployed via the manual-trigger `cd-backend.yml` workflow, which builds a Docker image and deploys to GCP Cloud Run. Select the service directory name and target environment (dev, staging, or production).

Each bootstrapped backend includes:
- A production `Dockerfile` with multi-stage build and non-root user
- A `.dockerignore` for efficient image builds
- A `/health` endpoint for Cloud Run health checks

## Terraform Integration

Backend services are configured in Terraform via the `cloud-run` module. To add a new service to infrastructure, add it to the `cloud_run_services` variable in your environment's `terraform.tfvars`. See [`terraform/README.md`](../terraform/README.md) for details.

## Guidelines

- Each service should be self-contained with its own dependencies, Dockerfile, and health endpoint.
- Shared code belongs in [`packages/`](../packages/), not duplicated across services.
- All services must include tests. CI will run them automatically.
- Use environment variables for configuration (port, database URLs, secrets).
