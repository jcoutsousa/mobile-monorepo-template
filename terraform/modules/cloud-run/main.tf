# =============================================================================
# Cloud Run Module — backend API services with auto-scaling
# =============================================================================

resource "google_cloud_run_v2_service" "services" {
  for_each = var.services

  name     = "${var.project_name}-${each.key}"
  location = var.region
  project  = var.project_id

  template {
    service_account = each.value.service_account_email

    scaling {
      min_instance_count = each.value.min_instances
      max_instance_count = each.value.max_instances
    }

    containers {
      image = each.value.image

      ports {
        container_port = each.value.container_port
      }

      resources {
        limits = {
          cpu    = each.value.cpu
          memory = each.value.memory
        }
        cpu_idle          = each.value.cpu_idle
        startup_cpu_boost = each.value.startup_cpu_boost
      }

      dynamic "env" {
        for_each = each.value.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = each.value.secret_env_vars
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value.secret_id
              version = lookup(env.value, "version", "latest")
            }
          }
        }
      }

      startup_probe {
        http_get {
          path = each.value.health_check_path
          port = each.value.container_port
        }
        initial_delay_seconds = 5
        period_seconds        = 10
        failure_threshold     = 3
      }

      liveness_probe {
        http_get {
          path = each.value.health_check_path
          port = each.value.container_port
        }
        period_seconds    = 30
        failure_threshold = 3
      }
    }

    dynamic "vpc_access" {
      for_each = each.value.vpc_connector_id != "" ? [1] : []
      content {
        connector = each.value.vpc_connector_id
        egress    = "PRIVATE_RANGES_ONLY"
      }
    }

    timeout = each.value.request_timeout
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version,
    ]
  }
}

# -----------------------------------------------------------------------------
# IAM — Allow unauthenticated access (public APIs) or restrict
# -----------------------------------------------------------------------------

resource "google_cloud_run_v2_service_iam_member" "public" {
  for_each = { for k, v in var.services : k => v if v.allow_unauthenticated }

  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.services[each.key].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# -----------------------------------------------------------------------------
# Custom Domain Mapping
# -----------------------------------------------------------------------------

resource "google_cloud_run_domain_mapping" "domains" {
  for_each = { for k, v in var.services : k => v if v.custom_domain != "" }

  name     = each.value.custom_domain
  location = var.region
  project  = var.project_id

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.services[each.key].name
  }
}
