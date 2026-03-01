# Infrastructure

Infrastructure-as-Code for backend services, deployment, and cloud resources.

## Structure

```
infrastructure/
├── terraform/    # → see /terraform/ (root level)
├── kubernetes/   # K8s manifests / Helm charts (add when needed)
└── scripts/      # Infra utility scripts (add when needed)
```

## Terraform

The Terraform configuration is located at the **repository root** under [`/terraform/`](../terraform/README.md) for easier access and CI/CD integration.

See [`terraform/README.md`](../terraform/README.md) for full setup instructions, module documentation, and environment configuration.

### Quick Overview

| Module | Purpose |
|--------|---------|
| `project-setup` | GCP APIs, billing budgets |
| `firebase` | Firebase project, apps, Auth, Firestore |
| `cloud-run` | Backend API services |
| `artifact-registry` | Docker, npm, Python, Maven registries |
| `networking` | VPC, subnets, Cloud NAT, VPC connector |
| `iam` | Service accounts, Workload Identity Federation |
| `secret-manager` | Secrets with IAM and rotation |
| `monitoring` | Dashboards, alerts, uptime checks |
| `storage` | GCS buckets |
