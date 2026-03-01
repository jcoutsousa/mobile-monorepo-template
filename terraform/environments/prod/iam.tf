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
      description  = "Service account for GitHub Actions deployments (prod)"
      roles = [
        "roles/run.developer",
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
