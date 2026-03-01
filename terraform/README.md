# Terraform — GCP Infrastructure

Modular Terraform configuration for deploying GCP infrastructure to support mobile, web, and backend services in the monorepo.

## Architecture

```
terraform/
├── environments/           # Per-environment configurations
│   ├── dev/                # Development (minimal resources)
│   ├── staging/            # Staging (mirrors prod, reduced scale)
│   └── prod/               # Production (HA, always-on, full monitoring)
├── modules/                # Reusable infrastructure modules
│   ├── project-setup/      # GCP APIs, billing budgets
│   ├── firebase/           # Firebase project, apps, Auth, Firestore
│   ├── cloud-run/          # Backend API services with auto-scaling
│   ├── artifact-registry/  # Docker, npm, Python, Maven registries
│   ├── networking/         # VPC, subnets, Cloud NAT, VPC connector
│   ├── iam/                # Service accounts, Workload Identity Federation
│   ├── secret-manager/     # Secrets with IAM and rotation
│   ├── monitoring/         # Dashboards, alerts, uptime checks
│   └── storage/            # GCS buckets (state, assets, backups)
├── backend.tf.example      # Remote state backend template
└── variables-global.tf     # Shared variable definitions
```

## Quick Start

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) authenticated
- A GCP project with billing enabled
- A GitHub repository for CI/CD

### 1. Bootstrap — Create State Bucket

Before running Terraform, create the GCS bucket for remote state:

```bash
# Set your project
export PROJECT_ID="my-app-dev-123456"
export PROJECT_NAME="my-app"
export REGION="europe-west1"

# Create the state bucket
gcloud storage buckets create "gs://${PROJECT_NAME}-terraform-state" \
  --project="${PROJECT_ID}" \
  --location="${REGION}" \
  --uniform-bucket-level-access \
  --public-access-prevention

# Enable versioning for state recovery
gcloud storage buckets update "gs://${PROJECT_NAME}-terraform-state" \
  --versioning
```

### 2. Configure Environment

```bash
cd terraform/environments/dev

# Copy the example tfvars
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
$EDITOR terraform.tfvars
```

### 3. Uncomment Backend

In `main.tf`, uncomment the `backend "gcs"` block and fill in your bucket name:

```hcl
backend "gcs" {
  bucket = "my-app-terraform-state"
  prefix = "env/dev"
}
```

### 4. Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

### 5. Configure GitHub Actions

After `terraform apply`, retrieve the WIF configuration:

```bash
terraform output wif_provider
terraform output service_account_emails
```

Add these as GitHub repository secrets:

| Secret | Value | Source |
|--------|-------|--------|
| `WIF_PROVIDER` | `projects/.../providers/github-provider` | `terraform output wif_provider` |
| `GCP_SERVICE_ACCOUNT` | `github-actions-sa@...iam.gserviceaccount.com` | `terraform output service_account_emails` |
| `GCP_PROJECT_ID` | Your project ID | Your GCP console |

Then update your GitHub Actions workflows to use keyless auth:

```yaml
- uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: ${{ secrets.WIF_PROVIDER }}
    service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
```

## Modules

### project-setup

Enables required GCP APIs and creates billing budgets with alert thresholds.

| Variable | Default | Description |
|----------|---------|-------------|
| `enable_firebase` | `true` | Enable Firebase APIs |
| `billing_account_id` | `""` | Billing account for budget alerts |
| `budget_amount` | `100` | Monthly budget in EUR |
| `budget_alert_thresholds` | `[0.5, 0.8, 0.9, 1.0]` | Alert at these % |

### firebase

Configures Firebase project, registers apps (Android, iOS, web), sets up Firestore and Authentication.

| Variable | Default | Description |
|----------|---------|-------------|
| `android_apps` | `{}` | Map of Android apps (`display_name`, `package_name`) |
| `ios_apps` | `{}` | Map of iOS apps (`display_name`, `bundle_id`) |
| `enable_firestore` | `true` | Create Firestore database |
| `enable_auth` | `true` | Enable Firebase Auth |

### cloud-run

Deploys backend API services with auto-scaling, health checks, and VPC connectivity.

| Variable | Default (dev) | Default (prod) | Description |
|----------|---------------|----------------|-------------|
| `min_instances` | `0` | `1` | Minimum instances (0 = scale to zero) |
| `max_instances` | `3` | `20` | Maximum instances |
| `cpu` | `"1"` | `"2"` | CPU allocation |
| `memory` | `"512Mi"` | `"1Gi"` | Memory allocation |

### artifact-registry

Creates container and package registries with cleanup policies.

| Variable | Default | Description |
|----------|---------|-------------|
| `enable_docker` | `true` | Docker registry |
| `enable_npm` | `false` | npm registry (React Native) |
| `enable_python` | `false` | Python registry |
| `enable_maven` | `false` | Maven registry (Kotlin) |

### networking

VPC with private subnets, Cloud NAT for outbound access, and Serverless VPC connector.

| Variable | Default | Description |
|----------|---------|-------------|
| `subnet_cidr` | `10.0.0.0/24` | Main subnet CIDR |
| `enable_nat` | `true` | Cloud NAT for outbound internet |
| `enable_serverless_connector` | `true` | VPC connector for Cloud Run |

### iam

Service accounts with least-privilege roles and Workload Identity Federation for GitHub Actions.

**WIF eliminates the need for service account keys** — GitHub Actions authenticates via OIDC tokens.

| Variable | Default | Description |
|----------|---------|-------------|
| `enable_wif` | `true` | Enable WIF for GitHub Actions |
| `github_repository` | `""` | `owner/repo` for OIDC condition |

### secret-manager

Creates secrets with IAM access control and optional rotation.

### monitoring

Cloud Monitoring dashboards, error/latency alerts, and uptime checks.

| Variable | Default (dev) | Default (prod) | Description |
|----------|---------------|----------------|-------------|
| `error_rate_threshold` | `1` | `0.5` | 5xx errors/sec trigger |
| `latency_threshold_ms` | `5000` | `3000` | p99 latency trigger |
| Uptime check period | `300s` | `60s` | Check frequency |

### storage

GCS buckets with lifecycle policies, versioning, and IAM.

## Environment Differences

| Feature | Dev | Staging | Prod |
|---------|-----|---------|------|
| Cloud Run min instances | 0 | 0 | 1 |
| Cloud Run max instances | 3 | 5 | 20 |
| CPU | 1 | 1 | 2 |
| Memory | 512Mi | 512Mi | 1Gi |
| VPC connector throughput | 200-300 Mbps | 200-300 Mbps | 200-800 Mbps |
| Budget | 50 EUR | 150 EUR | 500 EUR |
| Uptime check period | 5 min | 5 min | 1 min |
| Error rate threshold | 1/sec | 1/sec | 0.5/sec |
| WIF branch restriction | Any branch | Any branch | `main` only |
| Storage versioning | No | Yes | Yes |
| Backup bucket | No | No | Yes |

## Operations

### Adding a New Backend Service

1. Add to `cloud_run_services` in your `terraform.tfvars`:

```hcl
cloud_run_services = {
  "api" = {
    image             = "europe-west1-docker.pkg.dev/my-project/my-app-docker/api:latest"
    health_check_path = "/health"
  }
}
```

2. Run `terraform plan` then `terraform apply`.

### Adding a New Secret

```hcl
secrets = {
  "api-key" = {
    accessor_members = ["serviceAccount:cloud-run-sa@my-project.iam.gserviceaccount.com"]
  }
}
```

Set the secret value after creation:

```bash
echo -n "your-secret-value" | gcloud secrets versions add api-key --data-file=-
```

### Destroying an Environment

```bash
cd terraform/environments/dev
terraform destroy
```

> **Warning**: Production has `prevent_destroy` on Firestore. Remove the lifecycle block first if you truly need to destroy.
