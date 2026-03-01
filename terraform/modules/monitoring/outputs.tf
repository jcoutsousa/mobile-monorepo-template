output "notification_channel_ids" {
  description = "IDs of created notification channels"
  value       = [for ch in google_monitoring_notification_channel.email : ch.id]
}

output "uptime_check_ids" {
  description = "Map of uptime check keys to their IDs"
  value       = { for k, v in google_monitoring_uptime_check_config.checks : k => v.uptime_check_id }
}

output "dashboard_id" {
  description = "Cloud Monitoring dashboard ID (empty if not enabled)"
  value       = length(google_monitoring_dashboard.cloud_run) > 0 ? google_monitoring_dashboard.cloud_run[0].id : ""
}
