# =============================================================================
# Production Environment — HA resources, stricter security, full monitoring
# =============================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }

  # Uncomment after creating the state bucket
  # backend "gcs" {
  #   bucket = "YOUR_PROJECT_NAME-terraform-state"
  #   prefix = "env/prod"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

locals {
  environment = "prod"
  labels = merge(var.labels, {
    environment = local.environment
    managed_by  = "terraform"
  })
}

module "project_setup" {
  source = "../../modules/project-setup"

  project_id         = var.project_id
  project_name       = var.project_name
  environment        = local.environment
  enable_firebase    = var.enable_firebase
  billing_account_id = var.billing_account_id
  budget_amount      = var.budget_amount
  budget_alert_thresholds = [0.5, 0.75, 0.9, 1.0, 1.1]
}

module "networking" {
  source = "../../modules/networking"

  project_id                  = var.project_id
  project_name                = var.project_name
  region                      = var.region
  enable_nat                  = true
  enable_serverless_connector = true
  # Production: higher throughput
  connector_min_instances  = 2
  connector_max_instances  = 5
  connector_min_throughput = 200
  connector_max_throughput = 800

  depends_on = [module.project_setup]
}

module "iam" {
  source = "../../modules/iam"

  project_id        = var.project_id
  project_name      = var.project_name
  enable_wif        = var.enable_wif
  github_repository = var.github_repository

  service_accounts = {
    "github-actions-sa" = {
      display_name = "GitHub Actions CI/CD"
      description  = "Service account for GitHub Actions deployments (prod)"
      roles = [
        "roles/run.admin",
        "roles/artifactregistry.writer",
        "roles/iam.serviceAccountUser",
        "roles/secretmanager.secretAccessor",
      ]
    }
    "cloud-run-sa" = {
      display_name = "Cloud Run Runtime"
      description  = "Service account for Cloud Run services (prod)"
      roles = [
        "roles/secretmanager.secretAccessor",
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/cloudtrace.agent",
        "roles/errorreporting.writer",
      ]
    }
  }

  wif_service_account_bindings = {}

  # Production: only main branch can deploy
  wif_branch_restrictions = var.enable_wif ? {
    "deploy-main" = {
      service_account_key = "github-actions-sa"
      branch              = "main"
    }
  } : {}

  depends_on = [module.project_setup]
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id    = var.project_id
  project_name  = var.project_name
  region        = var.region
  labels        = local.labels
  enable_docker = true
  enable_npm    = var.enable_npm_registry
  enable_python = var.enable_python_registry
  enable_maven  = var.enable_maven_registry
  # Production: keep more versions
  cleanup_keep_count = 25
  cleanup_older_than = "15552000s"

  depends_on = [module.project_setup]
}

module "secrets" {
  source = "../../modules/secret-manager"

  project_id  = var.project_id
  region      = var.region
  environment = local.environment
  labels      = local.labels
  secrets     = var.secrets

  depends_on = [module.project_setup]
}

module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region

  services = {
    for k, v in var.cloud_run_services : k => merge(v, {
      service_account_email = module.iam.service_account_emails["cloud-run-sa"]
      vpc_connector_id      = module.networking.serverless_connector_id
      # Production defaults: always-on, more resources
      min_instances     = lookup(v, "min_instances", 1)
      max_instances     = lookup(v, "max_instances", 20)
      cpu               = lookup(v, "cpu", "2")
      memory            = lookup(v, "memory", "1Gi")
      cpu_idle          = false
      startup_cpu_boost = true
    })
  }

  depends_on = [module.project_setup, module.iam, module.networking]
}

module "firebase" {
  count  = var.enable_firebase ? 1 : 0
  source = "../../modules/firebase"

  project_id   = var.project_id
  environment  = local.environment
  android_apps = var.android_apps
  ios_apps     = var.ios_apps
  web_apps     = var.web_apps

  depends_on = [module.project_setup]
}

module "storage" {
  source = "../../modules/storage"

  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region
  labels       = local.labels

  buckets = {
    "assets" = {
      storage_class       = "STANDARD"
      versioning          = true
      nearline_after_days = 90
    }
    "backups" = {
      storage_class       = "NEARLINE"
      versioning          = true
      lifecycle_age_days  = 365
      nearline_after_days = 0
    }
  }

  depends_on = [module.project_setup]
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_id   = var.project_id
  project_name = var.project_name
  alert_emails = var.alert_emails

  enable_cloud_run_alerts = true
  enable_dashboard        = true
  # Production: stricter thresholds
  error_rate_threshold = 0.5
  latency_threshold_ms = 3000
  uptime_checks        = var.uptime_checks

  depends_on = [module.project_setup]
}
