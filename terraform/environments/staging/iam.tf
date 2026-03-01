# --- IAM + Workload Identity Federation ---
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
