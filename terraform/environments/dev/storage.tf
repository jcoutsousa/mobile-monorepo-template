# --- Storage ---
module "storage" {
  source = "../../modules/storage"

  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region
  labels       = local.labels

  buckets = {
    "assets" = {
      storage_class      = "STANDARD"
      versioning         = false
      lifecycle_age_days = 90
    }
  }

  depends_on = [module.project_setup]
}
