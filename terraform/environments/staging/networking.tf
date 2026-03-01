# --- Networking ---
module "networking" {
  source = "../../modules/networking"

  project_id                  = var.project_id
  project_name                = var.project_name
  region                      = var.region
  enable_nat                  = true
  enable_serverless_connector = true

  depends_on = [module.project_setup]
}
