# --- Project Setup (APIs + Budget) ---
module "project_setup" {
  source = "../../modules/project-setup"

  project_id         = var.project_id
  project_name       = var.project_name
  environment        = local.environment
  enable_firebase    = var.enable_firebase
  billing_account_id = var.billing_account_id
  budget_amount      = var.budget_amount
  budget_alert_thresholds = [0.5, 0.75, 0.9, 1.0, 1.1]
}
