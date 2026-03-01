# --- Artifact Registry ---
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
