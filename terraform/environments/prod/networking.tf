# --- Networking ---
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
