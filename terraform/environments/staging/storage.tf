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
      versioning         = true
      lifecycle_age_days = 180
    }
  }

  depends_on = [module.project_setup]
}
