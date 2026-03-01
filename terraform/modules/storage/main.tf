# =============================================================================
# Storage Module — GCS buckets (state, assets, backups, app distribution)
# =============================================================================

resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name     = "${var.project_name}-${each.key}"
  project  = var.project_id
  location = each.value.location != "" ? each.value.location : var.region

  storage_class               = each.value.storage_class
  uniform_bucket_level_access = true
  public_access_prevention    = each.value.public ? "inherited" : "enforced"

  labels = merge(var.labels, {
    purpose = each.key
  })

  versioning {
    enabled = each.value.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_age_days > 0 ? [1] : []
    content {
      condition {
        age = each.value.lifecycle_age_days
      }
      action {
        type = "Delete"
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.versioning ? [1] : []
    content {
      condition {
        num_newer_versions = each.value.max_versions
        with_state         = "ARCHIVED"
      }
      action {
        type = "Delete"
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.nearline_after_days > 0 ? [1] : []
    content {
      condition {
        age = each.value.nearline_after_days
      }
      action {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
    }
  }
}

# IAM — bucket-level access
resource "google_storage_bucket_iam_member" "access" {
  for_each = { for binding in local.bucket_bindings : "${binding.bucket_key}-${binding.role}-${binding.member}" => binding }

  bucket = google_storage_bucket.buckets[each.value.bucket_key].name
  role   = each.value.role
  member = each.value.member
}

locals {
  bucket_bindings = flatten([
    for bucket_key, bucket in var.buckets : [
      for binding in bucket.iam_bindings : {
        bucket_key = bucket_key
        role       = binding.role
        member     = binding.member
      }
    ]
  ])
}
