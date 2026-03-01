# --- Storage ---
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
