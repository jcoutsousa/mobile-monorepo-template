output "repository_ids" {
  description = "Map of registry keys to their repository IDs"
  value       = { for k, v in google_artifact_registry_repository.repos : k => v.repository_id }
}

output "repository_urls" {
  description = "Map of registry keys to their full registry URLs (for docker push, npm publish, etc.)"
  value = { for k, v in google_artifact_registry_repository.repos : k =>
    v.format == "DOCKER" ? "${var.region}-docker.pkg.dev/${var.project_id}/${v.repository_id}" :
    v.format == "NPM" ? "https://${var.region}-npm.pkg.dev/${var.project_id}/${v.repository_id}/" :
    v.format == "PYTHON" ? "https://${var.region}-python.pkg.dev/${var.project_id}/${v.repository_id}/simple/" :
    v.format == "MAVEN" ? "https://${var.region}-maven.pkg.dev/${var.project_id}/${v.repository_id}" :
    "${var.region}-${lower(v.format)}.pkg.dev/${var.project_id}/${v.repository_id}"
  }
}
