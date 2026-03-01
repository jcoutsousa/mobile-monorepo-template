locals {
  environment = "staging"
  labels = merge(var.labels, {
    environment = local.environment
    managed_by  = "terraform"
  })
}
