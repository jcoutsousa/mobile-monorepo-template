# =============================================================================
# Dev Environment Outputs
# =============================================================================

output "cloud_run_urls" {
  description = "Cloud Run service URLs"
  value       = module.cloud_run.service_urls
}

output "artifact_registry_urls" {
  description = "Artifact Registry repository URLs"
  value       = module.artifact_registry.repository_urls
}

output "wif_provider" {
  description = "WIF provider name (set as GitHub secret WIF_PROVIDER)"
  value       = module.iam.wif_provider_name
}

output "service_account_emails" {
  description = "Service account emails"
  value       = module.iam.service_account_emails
}

output "vpc_connector_id" {
  description = "Serverless VPC connector ID"
  value       = module.networking.serverless_connector_id
}

output "firebase_android_app_ids" {
  description = "Firebase Android app IDs"
  value       = var.enable_firebase ? module.firebase[0].android_app_ids : {}
}

output "firebase_ios_app_ids" {
  description = "Firebase iOS app IDs"
  value       = var.enable_firebase ? module.firebase[0].ios_app_ids : {}
}

output "bucket_names" {
  description = "GCS bucket names"
  value       = module.storage.bucket_names
}
