# --- Monitoring ---
module "monitoring" {
  source = "../../modules/monitoring"

  project_id   = var.project_id
  project_name = var.project_name
  alert_emails = var.alert_emails

  enable_cloud_run_alerts = true
  enable_dashboard        = true
  # Production: stricter thresholds
  error_rate_threshold = 0.5
  latency_threshold_ms = 3000
  uptime_checks        = var.uptime_checks

  depends_on = [module.project_setup]
}
