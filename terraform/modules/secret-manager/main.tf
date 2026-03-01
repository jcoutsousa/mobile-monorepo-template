# =============================================================================
# Secret Manager Module — secrets with IAM and rotation hints
# =============================================================================

resource "google_secret_manager_secret" "secrets" {
  for_each = var.secrets

  project   = var.project_id
  secret_id = each.key

  labels = merge(var.labels, {
    managed_by  = "terraform"
    environment = var.environment
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  dynamic "rotation" {
    for_each = each.value.rotation_period != "" ? [1] : []
    content {
      rotation_period = each.value.rotation_period
    }
  }

  dynamic "topics" {
    for_each = each.value.pubsub_topic != "" ? [1] : []
    content {
      name = each.value.pubsub_topic
    }
  }
}

# Initial secret version (placeholder — actual value set externally)
resource "google_secret_manager_secret_version" "initial" {
  for_each = { for k, v in var.secrets : k => v if v.initial_value != "" }

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.initial_value

  lifecycle {
    ignore_changes = [secret_data]
  }
}

# IAM — grant access to specific service accounts
resource "google_secret_manager_secret_iam_member" "accessors" {
  for_each = { for binding in local.secret_bindings : "${binding.secret_key}-${binding.member}" => binding }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret_key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.member
}

locals {
  secret_bindings = flatten([
    for secret_key, secret in var.secrets : [
      for accessor in secret.accessor_members : {
        secret_key = secret_key
        member     = accessor
      }
    ]
  ])
}
