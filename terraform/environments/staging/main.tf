# =============================================================================
# Staging Environment — mirrors prod but with reduced resources
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
  #   prefix = "env/staging"
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
  environment = "staging"
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
}

module "networking" {
  source = "../../modules/networking"

  project_id                  = var.project_id
  project_name                = var.project_name
  region                      = var.region
  enable_nat                  = true
  enable_serverless_connector = true

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
      description  = "Service account for GitHub Actions deployments"
      roles = [
        "roles/run.developer",
        "roles/artifactregistry.writer",
        "roles/iam.serviceAccountUser",
        "roles/secretmanager.secretAccessor",
      ]
    }
    "cloud-run-sa" = {
      display_name = "Cloud Run Runtime"
      description  = "Service account for Cloud Run services"
      roles = [
        "roles/secretmanager.secretAccessor",
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/cloudtrace.agent",
      ]
    }
  }

  wif_service_account_bindings = var.enable_wif ? {
    "github-actions" = {
      service_account_key = "github-actions-sa"
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
      # Staging: slightly more resources than dev
      min_instances = lookup(v, "min_instances", 0)
      max_instances = lookup(v, "max_instances", 5)
      cpu           = lookup(v, "cpu", "1")
      memory        = lookup(v, "memory", "512Mi")
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
      storage_class      = "STANDARD"
      versioning         = true
      lifecycle_age_days = 180
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
  uptime_checks           = var.uptime_checks

  depends_on = [module.project_setup]
}
