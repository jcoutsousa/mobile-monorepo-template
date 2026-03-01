# =============================================================================
# Artifact Registry Module — Docker + language-specific registries
# =============================================================================

locals {
  registries = merge(
    var.enable_docker ? {
      docker = {
        format      = "DOCKER"
        description = "Docker container images"
      }
    } : {},
    var.enable_npm ? {
      npm = {
        format      = "NPM"
        description = "npm packages (React Native)"
      }
    } : {},
    var.enable_python ? {
      python = {
        format      = "PYTHON"
        description = "Python packages"
      }
    } : {},
    var.enable_maven ? {
      maven = {
        format      = "MAVEN"
        description = "Maven/Gradle packages (Kotlin)"
      }
    } : {},
    var.extra_registries,
  )
}

resource "google_artifact_registry_repository" "repos" {
  for_each = local.registries

  project       = var.project_id
  location      = var.region
  repository_id = "${var.project_name}-${each.key}"
  format        = each.value.format
  description   = each.value.description

  labels = var.labels

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policy_enabled ? [1] : []
    content {
      id     = "keep-recent"
      action = "KEEP"

      most_recent_versions {
        keep_count = var.cleanup_keep_count
      }
    }
  }

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policy_enabled ? [1] : []
    content {
      id     = "delete-old"
      action = "DELETE"

      condition {
        older_than = var.cleanup_older_than
      }
    }
  }
}
