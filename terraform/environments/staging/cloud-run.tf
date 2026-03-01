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
      # Staging: slightly more resources than dev
      min_instances = lookup(v, "min_instances", 0)
      max_instances = lookup(v, "max_instances", 5)
      cpu           = lookup(v, "cpu", "1")
      memory        = lookup(v, "memory", "512Mi")
    })
  }

  depends_on = [module.project_setup, module.iam, module.networking]
}
