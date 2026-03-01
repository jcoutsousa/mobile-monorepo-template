output "enabled_apis" {
  description = "List of enabled GCP API services"
  value       = [for api in google_project_service.apis : api.service]
}

output "budget_id" {
  description = "Billing budget ID (empty if billing not configured)"
  value       = length(google_billing_budget.environment) > 0 ? google_billing_budget.environment[0].id : ""
}
