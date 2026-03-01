# --- Cloud Run ---
module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region

  services = {
    for k, v in var.cloud_run_services : k => merge(v, {
      service_account_email = module.iam.service_account_emails["cloud-run-sa"]
      vpc_connector_id      = module.networking.serverless_connector_id
      # Production defaults: always-on, more resources
      min_instances     = lookup(v, "min_instances", 1)
      max_instances     = lookup(v, "max_instances", 20)
      cpu               = lookup(v, "cpu", "2")
      memory            = lookup(v, "memory", "1Gi")
      cpu_idle          = false
      startup_cpu_boost = true
    })
  }

  depends_on = [module.project_setup, module.iam, module.networking]
}
