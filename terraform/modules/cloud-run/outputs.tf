output "service_urls" {
  description = "Map of service keys to their Cloud Run URLs"
  value       = { for k, v in google_cloud_run_v2_service.services : k => v.uri }
}

output "service_names" {
  description = "Map of service keys to their Cloud Run service names"
  value       = { for k, v in google_cloud_run_v2_service.services : k => v.name }
}

output "latest_revisions" {
  description = "Map of service keys to their latest ready revision"
  value       = { for k, v in google_cloud_run_v2_service.services : k => v.latest_ready_revision }
}
