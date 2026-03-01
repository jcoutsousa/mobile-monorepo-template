locals {
  environment = "dev"
  labels = merge(var.labels, {
    environment = local.environment
    managed_by  = "terraform"
  })
}
