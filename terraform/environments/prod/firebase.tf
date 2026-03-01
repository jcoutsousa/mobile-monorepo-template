# --- Firebase (optional) ---
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
