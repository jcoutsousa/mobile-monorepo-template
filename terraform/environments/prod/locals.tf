locals {
  environment = "prod"
  labels = merge(var.labels, {
    environment = local.environment
    managed_by  = "terraform"
  })
}
