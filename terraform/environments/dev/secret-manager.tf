# --- Secret Manager ---
module "secrets" {
  source = "../../modules/secret-manager"

  project_id  = var.project_id
  region      = var.region
  environment = local.environment
  labels      = local.labels

  secrets = var.secrets

  depends_on = [module.project_setup]
}
