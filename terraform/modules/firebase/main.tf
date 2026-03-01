# =============================================================================
# Firebase Module — Firebase project, apps, and services
# =============================================================================
# Requires google-beta provider for most Firebase resources.

terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

# -----------------------------------------------------------------------------
# Firebase Project
# -----------------------------------------------------------------------------

resource "google_firebase_project" "this" {
  provider = google-beta
  project  = var.project_id
}

# -----------------------------------------------------------------------------
# Firebase Android App(s)
# -----------------------------------------------------------------------------

resource "google_firebase_android_app" "apps" {
  for_each = var.android_apps

  provider     = google-beta
  project      = var.project_id
  display_name = each.value.display_name
  package_name = each.value.package_name

  depends_on = [google_firebase_project.this]
}

# -----------------------------------------------------------------------------
# Firebase iOS App(s)
# -----------------------------------------------------------------------------

resource "google_firebase_apple_app" "apps" {
  for_each = var.ios_apps

  provider     = google-beta
  project      = var.project_id
  display_name = each.value.display_name
  bundle_id    = each.value.bundle_id
  app_store_id = lookup(each.value, "app_store_id", null)

  depends_on = [google_firebase_project.this]
}

# -----------------------------------------------------------------------------
# Firebase Web App(s) — optional, for admin dashboards or PWAs
# -----------------------------------------------------------------------------

resource "google_firebase_web_app" "apps" {
  for_each = var.web_apps

  provider     = google-beta
  project      = var.project_id
  display_name = each.value.display_name

  depends_on = [google_firebase_project.this]
}

# -----------------------------------------------------------------------------
# Firestore Database
# -----------------------------------------------------------------------------

resource "google_firestore_database" "default" {
  count = var.enable_firestore ? 1 : 0

  provider                    = google-beta
  project                     = var.project_id
  name                        = "(default)"
  location_id                 = var.firestore_location
  type                        = "FIRESTORE_NATIVE"
  concurrency_mode            = var.environment == "prod" ? "OPTIMISTIC" : "PESSIMISTIC"
  app_engine_integration_mode = "DISABLED"

  depends_on = [google_firebase_project.this]

  lifecycle {
    prevent_destroy = true
  }
}

# -----------------------------------------------------------------------------
# Firebase Authentication — Identity Platform config
# -----------------------------------------------------------------------------

resource "google_identity_platform_config" "auth" {
  count = var.enable_auth ? 1 : 0

  provider = google-beta
  project  = var.project_id

  sign_in {
    allow_duplicate_emails = false

    dynamic "email" {
      for_each = var.auth_email_enabled ? [1] : []
      content {
        enabled           = true
        password_required = var.auth_password_required
      }
    }

    dynamic "anonymous" {
      for_each = var.auth_anonymous_enabled ? [1] : []
      content {
        enabled = true
      }
    }
  }

  depends_on = [google_firebase_project.this]
}
